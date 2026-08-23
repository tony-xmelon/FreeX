[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$evidenceRoot = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $evidenceRoot "../../../..")).Path
$manifest = Get-Content -LiteralPath (Join-Path $evidenceRoot "manifest.json") -Raw | ConvertFrom-Json

function Get-CanonicalHash {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes, [Parameter(Mandatory = $true)][string]$Mode)
    if ($Mode -eq "canonical-lf") {
        $text = [Text.Encoding]::UTF8.GetString($Bytes).Replace("`r`n", "`n").Replace("`r", "`n")
        $Bytes = [Text.Encoding]::UTF8.GetBytes($text)
    }
    $hasher = [Security.Cryptography.SHA256]::Create()
    try {
        [BitConverter]::ToString($hasher.ComputeHash($Bytes)).Replace("-", "").ToLowerInvariant()
    }
    finally {
        $hasher.Dispose()
    }
}

function Get-GitFileBytes {
    param([Parameter(Mandatory = $true)][string]$Revision, [Parameter(Mandatory = $true)][string]$Path)
    $start = [Diagnostics.ProcessStartInfo]::new("git")
    $start.WorkingDirectory = $repoRoot
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.UseShellExecute = $false
    $start.Arguments = "show --no-textconv `"${Revision}:$Path`""
    $process = [Diagnostics.Process]::Start($start)
    $memory = [IO.MemoryStream]::new()
    $process.StandardOutput.BaseStream.CopyTo($memory)
    $errorText = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { throw "git show failed for ${Revision}:$Path`: $errorText" }
    $memory.ToArray()
}

$audit = [Collections.Generic.List[string]]::new()
$audit.Add("schema-version=1")
$audit.Add("status=$($manifest.status)")
$audit.Add("source-commit=$($manifest.sourceCommit)")

foreach ($file in $manifest.files) {
    $path = Join-Path $evidenceRoot ([string]$file.path)
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing evidence file: $($file.path)" }
    $actual = Get-CanonicalHash -Bytes ([IO.File]::ReadAllBytes($path)) -Mode ([string]$file.hashMode)
    if ($actual -ne [string]$file.sha256) { throw "Evidence hash mismatch: $($file.path)" }
    $audit.Add("$($file.path)|mode=$($file.hashMode)|sha256=$actual|match=True")
}

foreach ($file in $manifest.provenanceFiles) {
    $worktreePath = Join-Path $repoRoot ([string]$file.path)
    if (-not (Test-Path -LiteralPath $worktreePath -PathType Leaf)) { throw "Missing provenance file: $($file.path)" }
    $worktree = Get-CanonicalHash -Bytes ([IO.File]::ReadAllBytes($worktreePath)) -Mode "canonical-lf"
    $committed = Get-CanonicalHash -Bytes (Get-GitFileBytes -Revision $manifest.sourceCommit -Path $file.path) -Mode "canonical-lf"
    if ($worktree -ne [string]$file.sha256 -or $committed -ne [string]$file.sha256) {
        throw "Provenance mismatch: $($file.path)"
    }
    $audit.Add("$($file.path)|worktree=$worktree|commit=$committed|match=True")
}

[IO.File]::WriteAllLines((Join-Path $evidenceRoot "hash-audit.txt"), $audit, [Text.UTF8Encoding]::new($false))
"Wave194 integrity passed: $($manifest.files.Count) evidence files, $($manifest.provenanceFiles.Count) provenance files."
