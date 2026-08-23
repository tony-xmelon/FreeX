$ErrorActionPreference = "Stop"

$evidenceRoot = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $evidenceRoot "..\..\..\..")).Path
$metrics = Get-Content -LiteralPath (Join-Path $evidenceRoot "metrics.json") -Raw | ConvertFrom-Json
$probes = Get-Content -LiteralPath (Join-Path $evidenceRoot "probes.json") -Raw | ConvertFrom-Json
$images = Get-Content -LiteralPath (Join-Path $evidenceRoot "images.json") -Raw | ConvertFrom-Json
$references = Get-Content -LiteralPath (Join-Path $evidenceRoot "references.json") -Raw | ConvertFrom-Json
$wave192 = Get-Content -LiteralPath (Join-Path $repoRoot "docs\parity\evidence\avalonia-parity-wave192-freep-evidence-20260823\metrics.json") -Raw | ConvertFrom-Json

function Fail([string]$message) {
    throw "FreeP Wave193 evidence integrity failed: $message"
}

function Assert-Equal($actual, $expected, [string]$context) {
    if ($actual -ne $expected) {
        Fail "$context differs: expected '$expected', found '$actual'."
    }
}

function Assert-NumericEqual($actual, $expected, [string]$context) {
    $actualNumber = [double]$actual
    $expectedNumber = [double]$expected
    if ([math]::Abs($actualNumber - $expectedNumber) -gt 0.0000001) {
        Fail "$context differs: expected $expectedNumber, found $actualNumber."
    }
}

function Read-PngDimensions([string]$path) {
    $bytes = [io.file]::ReadAllBytes($path)
    if ($bytes.Length -lt 24) {
        Fail "PNG '$path' is too short."
    }
    $signature = @(137, 80, 78, 71, 13, 10, 26, 10)
    for ($index = 0; $index -lt $signature.Count; $index++) {
        if ($bytes[$index] -ne $signature[$index]) {
            Fail "PNG '$path' has an invalid signature."
        }
    }
    $width = ([uint32]$bytes[16] -shl 24) -bor
        ([uint32]$bytes[17] -shl 16) -bor
        ([uint32]$bytes[18] -shl 8) -bor
        [uint32]$bytes[19]
    $height = ([uint32]$bytes[20] -shl 24) -bor
        ([uint32]$bytes[21] -shl 16) -bor
        ([uint32]$bytes[22] -shl 8) -bor
        [uint32]$bytes[23]
    return [pscustomobject]@{ Width = [int]$width; Height = [int]$height }
}

Assert-Equal $metrics.schema "freep.parity.wave193.corpus.v1" "metrics schema"
Assert-Equal $probes.status "no-runtime-change-verified" "probe status"
Assert-Equal $metrics.source.corpusDecks 27 "corpus deck count"
Assert-Equal $metrics.source.corpusSlides 53 "corpus slide count"
Assert-Equal $metrics.source.rendererOutputs 106 "renderer output count"
Assert-Equal $metrics.source.comparisons 159 "comparison count"
Assert-Equal $metrics.source.width 1280 "render width"
Assert-Equal $metrics.source.height 720 "render height"
Assert-Equal $probes.evidenceBoundary.runtimeChangeRetained $false "runtime-change decision"

$rows = @($metrics.rows)
Assert-Equal $rows.Count 53 "row count"
$keys = @($rows | ForEach-Object { "$($_.deck)/$($_.slide)" })
Assert-Equal (@($keys | Sort-Object -Unique).Count) 53 "unique row count"

$comparisonFields = @("wpfOffice", "avaloniaOffice", "wpfAvalonia")
$maxFields = @("wpfOfficeMaxChannel", "avaloniaOfficeMaxChannel", "wpfAvaloniaMaxChannel")
foreach ($row in $rows) {
    $key = "$($row.deck)/$($row.slide)"
    foreach ($field in $comparisonFields) {
        $value = [double]$row.$field
        if ([double]::IsNaN($value) -or [double]::IsInfinity($value) -or $value -lt 0 -or $value -gt 100) {
            Fail "$key has invalid $field '$value'."
        }
    }
    foreach ($field in $maxFields) {
        $value = [int]$row.$field
        if ($value -lt 0 -or $value -gt 255) {
            Fail "$key has invalid $field '$value'."
        }
    }
}

$aggregateMap = [ordered]@{
    wpfOfficeAverage = @("wpfOffice", "Average")
    wpfOfficeMaximum = @("wpfOffice", "Maximum")
    avaloniaOfficeAverage = @("avaloniaOffice", "Average")
    avaloniaOfficeMaximum = @("avaloniaOffice", "Maximum")
    wpfAvaloniaAverage = @("wpfAvalonia", "Average")
    wpfAvaloniaMaximum = @("wpfAvalonia", "Maximum")
}
foreach ($entry in $aggregateMap.GetEnumerator()) {
    $propertyName = $entry.Value[0]
    $operation = $entry.Value[1]
    $measure = $rows | Measure-Object -Property $propertyName -Average -Maximum
    $actual = if ($operation -eq "Average") { $measure.Average } else { $measure.Maximum }
    $actual = [math]::Round($actual, 4)
    Assert-NumericEqual $metrics.aggregate.($entry.Key) $actual "aggregate $($entry.Key)"
}

if ([double]$metrics.aggregate.avaloniaOfficeAverage -ge [double]$metrics.aggregate.wpfOfficeAverage) {
    Fail "Avalonia no longer has the better Office aggregate."
}

$target = @($rows | Where-Object { $_.deck -eq "17-bullets-autofit" -and $_.slide -eq "slide-02" })
Assert-Equal $target.Count 1 "target row count"
Assert-NumericEqual $target[0].wpfOffice 3.0587 "target WPF/Office"
Assert-NumericEqual $target[0].avaloniaOffice 2.5360 "target Avalonia/Office"
Assert-NumericEqual $target[0].wpfAvalonia 2.9091 "target WPF/Avalonia"

$wave192Rows = @($wave192.rows)
Assert-Equal $wave192Rows.Count $rows.Count "Wave192 row count"
foreach ($row in $rows) {
    $prior = @($wave192Rows | Where-Object { $_.deck -eq $row.deck -and $_.slide -eq $row.slide })
    Assert-Equal $prior.Count 1 "Wave192 mapping for $($row.deck)/$($row.slide)"
    foreach ($field in $comparisonFields + $maxFields) {
        Assert-NumericEqual $row.$field $prior[0].$field "Wave192 equality for $($row.deck)/$($row.slide) $field"
    }
}

$referenceRows = @($references.rows)
Assert-Equal $referenceRows.Count 53 "Office reference count"
foreach ($reference in $referenceRows) {
    $key = "$($reference.deck)/$($reference.slide)"
    if ($keys -notcontains $key) {
        Fail "Office reference '$key' has no metric row."
    }
    $path = Join-Path (Join-Path $repoRoot $references.root) $reference.path
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Fail "Office reference '$key' is missing."
    }
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    Assert-Equal $hash ([string]$reference.sha256).ToLowerInvariant() "Office reference hash for $key"
    $dimensions = Read-PngDimensions $path
    Assert-Equal $dimensions.Width 1280 "Office reference width for $key"
    Assert-Equal $dimensions.Height 720 "Office reference height for $key"
}

$imageProperties = @($images.PSObject.Properties)
Assert-Equal $imageProperties.Count 6 "retained image count"
foreach ($image in $imageProperties) {
    $path = Join-Path $evidenceRoot $image.Name
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Fail "Retained image '$($image.Name)' is missing."
    }
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    Assert-Equal $hash ([string]$image.Value).ToLowerInvariant() "retained image hash for $($image.Name)"
    $dimensions = Read-PngDimensions $path
    Assert-Equal $dimensions.Width 1280 "retained image width for $($image.Name)"
    Assert-Equal $dimensions.Height 720 "retained image height for $($image.Name)"
}

$officeCopyHash = (Get-FileHash -LiteralPath (Join-Path $evidenceRoot "office-slide-02.png") -Algorithm SHA256).Hash.ToLowerInvariant()
$officeAuthorityHash = (Get-FileHash -LiteralPath (Join-Path $repoRoot "tools\FreeP.RenderCompare\corpus\pptx-ref\17-bullets-autofit\slide-02.png") -Algorithm SHA256).Hash.ToLowerInvariant()
Assert-Equal $officeCopyHash $officeAuthorityHash "retained target Office authority copy"

Write-Output "FreeP Wave193 evidence integrity passed."
Write-Output "- 27 decks / 53 unique slides"
Write-Output "- 106/106 current-source renders and 159/159 comparisons recorded"
Write-Output "- 53/53 rows exactly equal Wave192; Avalonia remains better than WPF"
Write-Output "- 53/53 Office references and 6/6 retained images verified"
