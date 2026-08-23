$ErrorActionPreference = "Stop"

$evidenceRoot = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $evidenceRoot "..\..\..\..")).Path
$metrics = Get-Content -LiteralPath (Join-Path $evidenceRoot "metrics.json") -Raw | ConvertFrom-Json
$references = Get-Content -LiteralPath (Join-Path $evidenceRoot "references.json") -Raw | ConvertFrom-Json

$comparisonFields = @("wpfOffice", "avaloniaOffice", "wpfAvalonia")
$maxChannelFields = @(
    "wpfOfficeMaxChannel",
    "avaloniaOfficeMaxChannel",
    "wpfAvaloniaMaxChannel"
)
$allMetricFields = $comparisonFields + $maxChannelFields
$metricRoundingDigits = 4
$metricRoundingTolerance = [math]::Pow(10, -($metricRoundingDigits + 1)) + 1e-9

function Fail([string]$message) {
    throw "FreeP Wave192 evidence integrity failed: $message"
}

function Get-RequiredProperty($object, [string]$name, [string]$context) {
    $property = $object.PSObject.Properties[$name]
    if ($null -eq $property) {
        Fail "$context is missing '$name'."
    }

    return $property.Value
}

function Get-Number($object, [string]$name, [string]$context) {
    $value = Get-RequiredProperty $object $name $context
    try {
        $number = [double]$value
    }
    catch {
        Fail "$context.$name is not numeric: '$value'."
    }

    if ([double]::IsNaN($number) -or [double]::IsInfinity($number)) {
        Fail "$context.$name is not finite: '$value'."
    }

    return $number
}

function Assert-Within([double]$actual, [double]$expected, [double]$tolerance, [string]$context) {
    if ([math]::Abs($actual - $expected) -gt $tolerance) {
        Fail "$context differs: expected $expected, found $actual (tolerance $tolerance)."
    }
}

function Get-RowKey($row, [string]$context) {
    $deck = [string](Get-RequiredProperty $row "deck" $context)
    $slide = [string](Get-RequiredProperty $row "slide" $context)
    if ([string]::IsNullOrWhiteSpace($deck) -or [string]::IsNullOrWhiteSpace($slide)) {
        Fail "$context has an empty deck or slide key."
    }

    return "$deck/$slide"
}

function Read-PngDimensions([string]$path) {
    $bytes = [io.file]::ReadAllBytes($path)
    if ($bytes.Length -lt 24) {
        Fail "PNG '$path' is too short to contain an IHDR."
    }

    $signature = @(137, 80, 78, 71, 13, 10, 26, 10)
    for ($index = 0; $index -lt $signature.Count; $index++) {
        if ($bytes[$index] -ne $signature[$index]) {
            Fail "PNG '$path' has an invalid PNG signature."
        }
    }

    if ([text.encoding]::ASCII.GetString($bytes, 12, 4) -ne "IHDR") {
        Fail "PNG '$path' does not begin with an IHDR chunk."
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

function Assert-GitPath([string]$revision, [string]$relativePath, [string]$context) {
    & git -C $repoRoot cat-file -e "$revision`:$relativePath" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Fail "$context '$relativePath' is not present at committed revision $revision."
    }
}

$sourceDecks = [int](Get-RequiredProperty $metrics.source "corpusDecks" "metrics.source")
$sourceSlides = [int](Get-RequiredProperty $metrics.source "corpusSlides" "metrics.source")
$expectedWidth = [int](Get-RequiredProperty $metrics.source "width" "metrics.source")
$expectedHeight = [int](Get-RequiredProperty $metrics.source "height" "metrics.source")
$referenceRoot = [string](Get-RequiredProperty $metrics.source "officeReferenceRoot" "metrics.source")

if ($sourceDecks -ne 27 -or $sourceSlides -ne 53) {
    Fail "unexpected declared corpus cardinality: $sourceDecks decks / $sourceSlides slides."
}

$rows = @($metrics.rows)
if ($rows.Count -ne $sourceSlides) {
    Fail "metrics.rows has $($rows.Count) entries; expected exactly $sourceSlides."
}

$rowKeys = @($rows | ForEach-Object { Get-RowKey $_ "metrics.rows entry" })
$uniqueRowKeys = @($rowKeys | Sort-Object -Unique)
if ($uniqueRowKeys.Count -ne $rows.Count) {
    Fail "metrics.rows contains duplicate deck/slide entries."
}
if (@($uniqueRowKeys | ForEach-Object { ($_ -split "/", 2)[0] } | Sort-Object -Unique).Count -ne $sourceDecks) {
    Fail "metrics.rows does not cover exactly $sourceDecks unique decks."
}

$comparisonCount = 0
foreach ($row in $rows) {
    $context = "metrics.rows[$(Get-RowKey $row 'metrics.rows entry')]"
    foreach ($field in $comparisonFields) {
        [void](Get-Number $row $field $context)
        $comparisonCount++
    }
    foreach ($field in $maxChannelFields) {
        $value = Get-Number $row $field $context
        if ($value -lt 0 -or $value -gt 255 -or $value -ne [math]::Truncate($value)) {
            Fail "$context.$field must be an integer channel value from 0 through 255."
        }
    }
}
if ($comparisonCount -ne 159) {
    Fail "expected 159 metric comparisons, found $comparisonCount."
}

foreach ($field in $comparisonFields) {
    $values = @($rows | ForEach-Object { Get-Number $_ $field "metrics.rows" })
    $average = ($values | Measure-Object -Average).Average
    $maximum = ($values | Measure-Object -Maximum).Maximum
    $roundedAverage = [math]::Round($average, $metricRoundingDigits)
    $declaredAverage = [double](Get-RequiredProperty $metrics.aggregate "${field}Average" "metrics.aggregate")
    $declaredMaximum = [double](Get-RequiredProperty $metrics.aggregate "${field}Maximum" "metrics.aggregate")
    Assert-Within $roundedAverage $declaredAverage $metricRoundingTolerance "metrics.aggregate.${field}Average (rounded to $metricRoundingDigits decimals)"
    Assert-Within $maximum $declaredMaximum $metricRoundingTolerance "metrics.aggregate.${field}Maximum"
}

function Assert-SnapshotRowsMatch($snapshots, [string]$label) {
    $snapshotRows = @($snapshots)
    foreach ($snapshot in $snapshotRows) {
        $key = Get-RowKey $snapshot "$label entry"
        $matches = @($rows | Where-Object { (Get-RowKey $_ "metrics.rows entry") -eq $key })
        if ($matches.Count -ne 1) {
            Fail "$label row '$key' does not map to exactly one corpus row."
        }

        $corpusRow = $matches[0]
        foreach ($field in $allMetricFields) {
            $snapshotValue = Get-Number $snapshot $field "$label[$key]"
            $corpusValue = Get-Number $corpusRow $field "metrics.rows[$key]"
            $tolerance = if ($field -in $comparisonFields) { $metricRoundingTolerance } else { 0 }
            Assert-Within $snapshotValue $corpusValue $tolerance "$label[$key].$field"
        }
    }
}

Assert-SnapshotRowsMatch $metrics.target "metrics.target"
Assert-SnapshotRowsMatch $metrics.controls "metrics.controls"

$images = @($metrics.images.PSObject.Properties)
if ($images.Count -ne 9) {
    Fail "expected nine retained Wave192 evidence PNGs, found $($images.Count)."
}
foreach ($image in $images) {
    $imagePath = Join-Path $evidenceRoot $image.Name
    if (-not (Test-Path -LiteralPath $imagePath -PathType Leaf)) {
        Fail "missing retained evidence image '$($image.Name)'."
    }

    $dimensions = Read-PngDimensions $imagePath
    if ($dimensions.Width -ne $expectedWidth -or $dimensions.Height -ne $expectedHeight) {
        Fail "image '$($image.Name)' is $($dimensions.Width)x$($dimensions.Height); expected ${expectedWidth}x${expectedHeight}."
    }

    $actualHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $expectedHash = ([string]$image.Value).ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        Fail "retained evidence hash mismatch for '$($image.Name)': expected $expectedHash, found $actualHash."
    }
}

$wpfImageName = "wpf-increasing-circle-slide-09.png"
$wpfImagePath = Join-Path $evidenceRoot $wpfImageName
$wpfActualHash = (Get-FileHash -LiteralPath $wpfImagePath -Algorithm SHA256).Hash.ToLowerInvariant()
$wpfImageManifestHash = ([string](Get-RequiredProperty $metrics.images $wpfImageName "metrics.images")).ToLowerInvariant()
if ($wpfActualHash -ne $wpfImageManifestHash) {
    Fail "actual WPF increasing-circle PNG hash does not match metrics.images."
}
foreach ($stabilityField in @("wpfIncreasingCircleSlide09Wave191Sha256", "wpfIncreasingCircleSlide09Wave192Sha256")) {
    $stabilityHash = ([string](Get-RequiredProperty $metrics.stability $stabilityField "metrics.stability")).ToLowerInvariant()
    if ($wpfActualHash -ne $stabilityHash) {
        Fail "actual WPF increasing-circle PNG hash does not match metrics.stability.$stabilityField."
    }
}
if (-not [bool]$metrics.stability.wpfByteStable -or [bool]$metrics.stability.runtimeSourceChanged) {
    Fail "WPF stability/runtime-source decision gate failed."
}

if ([string]$references.root -ne $referenceRoot -or [int]$references.expectedWidth -ne $expectedWidth -or [int]$references.expectedHeight -ne $expectedHeight) {
    Fail "references.json provenance root or expected dimensions disagree with metrics.source."
}
$referenceRevision = [string](Get-RequiredProperty $references "sourceRevision" "references")
$metricsRevision = [string](Get-RequiredProperty $metrics.source "baseRevision" "metrics.source")
if ($referenceRevision -ne $metricsRevision) {
    Fail "references.sourceRevision '$referenceRevision' does not match metrics.source.baseRevision '$metricsRevision'."
}
& git -C $repoRoot cat-file -e "$referenceRevision^{commit}" 2>$null
if ($LASTEXITCODE -ne 0) {
    Fail "references.sourceRevision '$referenceRevision' is not a committed revision."
}
$referenceRows = @($references.rows)
if ($referenceRows.Count -ne $rows.Count) {
    Fail "references.json has $($referenceRows.Count) mappings; expected $($rows.Count)."
}
$referenceKeys = @($referenceRows | ForEach-Object { Get-RowKey $_ "references row" })
if (@($referenceKeys | Sort-Object -Unique).Count -ne $referenceRows.Count) {
    Fail "references.json contains duplicate deck/slide mappings."
}
if (@(Compare-Object ($uniqueRowKeys | Sort-Object) ($referenceKeys | Sort-Object)).Count -ne 0) {
    Fail "references.json mapping keys do not exactly match metrics.rows."
}

foreach ($reference in $referenceRows) {
    $key = Get-RowKey $reference "references row"
    $path = [string](Get-RequiredProperty $reference "path" "references[$key]")
    if ([string]::IsNullOrWhiteSpace($path) -or $path.StartsWith("/") -or $path.Contains("..")) {
        Fail "references[$key].path is not a safe repository-relative path: '$path'."
    }
    $normalizedPath = $path.Replace("\", "/")
    $expectedPath = "$($reference.deck)/$($reference.slide).png"
    if ($normalizedPath -ne $expectedPath) {
        Fail "references[$key].path '$path' does not map to its deck/slide key '$expectedPath'."
    }
    $relativePath = "$referenceRoot/$path"
    $absolutePath = Join-Path $repoRoot ($relativePath -replace "/", "\")
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        Fail "committed PowerPoint reference is missing: '$relativePath'."
    }

    $trackedPath = (& git -C $repoRoot ls-files --error-unmatch -- $relativePath 2>$null)
    if ($LASTEXITCODE -ne 0 -or [string]$trackedPath -ne $relativePath) {
        Fail "PowerPoint reference is not tracked by Git: '$relativePath'."
    }
    Assert-GitPath $referenceRevision $relativePath "PowerPoint reference"

    $dimensions = Read-PngDimensions $absolutePath
    $declaredWidth = [int](Get-RequiredProperty $reference "width" "references[$key]")
    $declaredHeight = [int](Get-RequiredProperty $reference "height" "references[$key]")
    if ($dimensions.Width -ne $expectedWidth -or $dimensions.Height -ne $expectedHeight -or $declaredWidth -ne $expectedWidth -or $declaredHeight -ne $expectedHeight) {
        Fail "PowerPoint reference '$relativePath' does not prove the expected ${expectedWidth}x${expectedHeight} dimensions."
    }

    $actualHash = (Get-FileHash -LiteralPath $absolutePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $declaredHash = ([string](Get-RequiredProperty $reference "sha256" "references[$key]")).ToLowerInvariant()
    if ($actualHash -ne $declaredHash) {
        Fail "PowerPoint reference hash mismatch for '$relativePath'."
    }
}

Write-Output "Wave192 FreeP retained evidence integrity passed."
Write-Output "- corpus: $($rows.Count) unique rows / $sourceDecks decks / $sourceSlides slides"
Write-Output "- comparisons: $comparisonCount (three per row); aggregate averages/maxima recomputed with $metricRoundingDigits-decimal rounding"
Write-Output "- target/control snapshots: $(@($metrics.target).Count) targets and $(@($metrics.controls).Count) controls matched to corpus rows"
Write-Output "- retained evidence PNGs: $($images.Count)/$($images.Count) hashes and ${expectedWidth}x${expectedHeight} dimensions"
Write-Output "- committed PowerPoint references: $($referenceRows.Count)/$($referenceRows.Count) mapped, tracked, hashed, and ${expectedWidth}x${expectedHeight}"
Write-Output "- WPF increasing-circle stability: actual PNG hash matches Wave191 and Wave192 stability hashes"
Write-Output "- proof boundary: retained evidence does not independently prove the worker-run claim of 106/106 renders"
