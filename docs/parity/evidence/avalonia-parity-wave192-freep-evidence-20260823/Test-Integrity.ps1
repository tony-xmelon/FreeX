$ErrorActionPreference = "Stop"

$metricsPath = Join-Path $PSScriptRoot "metrics.json"
$metrics = Get-Content -LiteralPath $metricsPath -Raw | ConvertFrom-Json

if ($metrics.source.corpusDecks -ne 27 -or $metrics.source.corpusSlides -ne 53) {
    throw "Unexpected corpus cardinality: $($metrics.source.corpusDecks) decks / $($metrics.source.corpusSlides) slides."
}

if (-not $metrics.stability.wpfByteStable -or $metrics.stability.runtimeSourceChanged) {
    throw "WPF stability/runtime-source integrity gate failed."
}

$images = @($metrics.images.PSObject.Properties)
if ($images.Count -ne 9) {
    throw "Expected nine Wave192 evidence images, found $($images.Count)."
}

foreach ($image in $images) {
    $imagePath = Join-Path $PSScriptRoot $image.Name
    if (-not (Test-Path -LiteralPath $imagePath -PathType Leaf)) {
        throw "Missing Wave192 evidence image: $($image.Name)"
    }

    $actualHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $expectedHash = ([string]$image.Value).ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        throw "Wave192 evidence hash mismatch for $($image.Name): expected $expectedHash, found $actualHash."
    }
}

Write-Output "Wave192 evidence integrity passed: 9/9 images; 27 decks / 53 slides."
