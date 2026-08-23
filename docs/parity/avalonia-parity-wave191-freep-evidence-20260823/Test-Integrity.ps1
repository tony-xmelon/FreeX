$ErrorActionPreference = "Stop"

$metricsPath = Join-Path $PSScriptRoot "metrics.json"
$metrics = Get-Content -LiteralPath $metricsPath -Raw | ConvertFrom-Json
$images = @($metrics.images.PSObject.Properties)

if ($images.Count -ne 4) {
    throw "Expected four Wave191 evidence images, found $($images.Count)."
}

foreach ($image in $images) {
    $imagePath = Join-Path $PSScriptRoot $image.Name
    if (-not (Test-Path -LiteralPath $imagePath -PathType Leaf)) {
        throw "Missing Wave191 evidence image: $($image.Name)"
    }

    $actualHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $expectedHash = ([string]$image.Value).ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        throw "Wave191 evidence hash mismatch for $($image.Name): expected $expectedHash, found $actualHash."
    }
}

Write-Output "Wave191 evidence integrity passed: 4/4 images."
