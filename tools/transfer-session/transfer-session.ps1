<#
.SYNOPSIS
  transfer-session — package a Claude Code session (transcript + subagents + memory + local-only
  assets) into a bundle and move it between machines via Google Drive (rclone).

.DESCRIPTION
  PUSH (source machine): bundles the current session and uploads the .zip to Drive.
  PULL (target machine): downloads the bundle, restores transcript+memory+assets under THIS
  machine's project dir, and self-installs this skill. Then `claude --resume <id>`.

  Bytes flow disk<->Drive directly through rclone (never through the model), so there is no size limit.

.PARAMETER Mode      push | pull
.PARAMETER SessionId push: defaults to $env:CLAUDE_CODE_SESSION_ID. pull: the id to fetch, or 'latest'.
.PARAMETER Remote    rclone remote name (default 'gdrive').
.PARAMETER DriveRoot Drive folder that holds per-session bundles (default 'transfer-session').
.PARAMETER RepoRoot  Repo/cwd used to locate the project dir + resolve repo-relative assets (default: cwd).
.PARAMETER BundleZip pull: use a local .zip instead of downloading (skips rclone).
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)][ValidateSet('push','pull')] [string]$Mode,
  [string]$SessionId,
  [string]$Remote   = 'gdrive',
  [string]$DriveRoot= 'transfer-session',
  [string]$RepoRoot = (Get-Location).Path,
  [string]$BundleZip
)
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[transfer-session] $m" }
function Die($m){ Write-Error "[transfer-session] $m"; exit 1 }

# --- resolve rclone (winget puts it on PATH after a shell restart; fall back to known install dirs) ---
function Get-Rclone {
  $c = Get-Command rclone -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  $cands = @(
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links\rclone.exe"
  ) + (Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Rclone.Rclone*\*\rclone.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
  foreach ($p in $cands) { if ($p -and (Test-Path $p)) { return $p } }
  return $null
}

$ProjectsBase = Join-Path $env:USERPROFILE '.claude\projects'
$SkillDir     = $PSScriptRoot                      # this skill's own folder (for self-propagation)

# Encode an absolute path the way Claude Code names its project dir: ':' and '\' '/' -> '-'.
function ConvertTo-ProjectDir([string]$absPath){ return ($absPath -replace '[:\\/]','-') }

# Find the project dir that actually contains <sid>.jsonl (robust to drive-letter case etc.).
function Resolve-ProjectDirForSession([string]$sid){
  $hit = Get-ChildItem $ProjectsBase -Directory -ErrorAction SilentlyContinue |
         Where-Object { Test-Path (Join-Path $_.FullName "$sid.jsonl") } | Select-Object -First 1
  if ($hit){ return $hit.FullName }
  return $null
}

# ============================== PUSH ==============================
if ($Mode -eq 'push') {
  if (-not $SessionId) { $SessionId = $env:CLAUDE_CODE_SESSION_ID }
  if (-not $SessionId) { Die "No SessionId and CLAUDE_CODE_SESSION_ID is unset. Pass -SessionId." }
  $rclone = Get-Rclone; if (-not $rclone) { Die "rclone not found. Install: winget install Rclone.Rclone, then 'rclone config' a '$Remote' remote." }

  $projDir = Resolve-ProjectDirForSession $SessionId
  if (-not $projDir) { Die "Could not find $SessionId.jsonl under $ProjectsBase." }
  $repoAbs = (Resolve-Path $RepoRoot).Path

  $stage = Join-Path $env:TEMP "transfer-session-$SessionId"
  if (Test-Path $stage){ Remove-Item $stage -Recurse -Force }
  New-Item -ItemType Directory -Force -Path "$stage\session","$stage\memory","$stage\assets","$stage\skill" | Out-Null

  Info "session  : $SessionId"
  Info "projDir  : $projDir"
  # transcript + subagents
  Copy-Item (Join-Path $projDir "$SessionId.jsonl") "$stage\session\" -Force
  if (Test-Path (Join-Path $projDir $SessionId)) { Copy-Item (Join-Path $projDir $SessionId) "$stage\session\$SessionId" -Recurse -Force }
  # memory
  if (Test-Path (Join-Path $projDir 'memory')) { Copy-Item (Join-Path $projDir 'memory\*') "$stage\memory\" -Recurse -Force -ErrorAction SilentlyContinue }
  # this skill (so the target can self-install it)
  Copy-Item "$SkillDir\*" "$stage\skill\" -Recurse -Force -ErrorAction SilentlyContinue

  # local-only assets from manifest: lines `SRC` or `SRC => DEST` (# comments). SRC repo-relative or absolute.
  # DEST (restore target) repo-relative or absolute; env vars like %USERPROFILE% are expanded on pull.
  $assetMap = @()
  $manifest = Join-Path $repoAbs '.claude\transfer-session.assets'
  if (Test-Path $manifest) {
    Get-Content $manifest | ForEach-Object {
      $line = $_.Trim(); if (-not $line -or $line.StartsWith('#')) { return }
      $parts = $line -split '\s*=>\s*', 2
      $src = $parts[0].Trim(); $dest = if ($parts.Count -gt 1) { $parts[1].Trim() } else { $src }
      $srcAbs = if ([System.IO.Path]::IsPathRooted($src)) { $src } else { Join-Path $repoAbs $src }
      if (-not (Test-Path $srcAbs)) { Info "  asset MISSING (skipped): $src"; return }
      $name = Split-Path $srcAbs -Leaf
      $stageRel = "assets\$name"
      Copy-Item $srcAbs "$stage\$stageRel" -Recurse -Force
      $assetMap += [pscustomobject]@{ stage = ($stageRel -replace '\\','/'); dest = $dest }
      Info "  asset    : $src  ($([math]::Round((Get-Item $srcAbs -ErrorAction SilentlyContinue).Length/1KB)) KB) -> $dest"
    }
  } else { Info "no assets manifest at $manifest (session+memory only)" }

  # meta
  $gitCommit = (& git -C $repoAbs rev-parse --short HEAD 2>$null)
  $gitRemote = (& git -C $repoAbs remote get-url origin 2>$null)
  [pscustomobject]@{
    sessionId        = $SessionId
    createdAt        = (Get-Date).ToString('o')
    sourceRepoPath   = $repoAbs
    sourceProjectDir = (Split-Path $projDir -Leaf)
    gitRemote        = $gitRemote
    gitCommit        = $gitCommit
    assets           = $assetMap
  } | ConvertTo-Json -Depth 6 | Set-Content "$stage\meta.json" -Encoding UTF8

  $zip = Join-Path $env:TEMP "transfer-session-$SessionId.zip"
  if (Test-Path $zip){ Remove-Item $zip -Force }
  Compress-Archive -Path "$stage\*" -DestinationPath $zip -CompressionLevel Optimal
  $mb = [math]::Round((Get-Item $zip).Length/1MB,2)
  Info "bundle   : $zip ($mb MB)"

  $dst = "$Remote`:$DriveRoot/$SessionId/"
  Info "uploading -> $dst"
  & $rclone copy $zip $dst
  if ($LASTEXITCODE -ne 0) { Die "rclone upload failed (exit $LASTEXITCODE). Is the '$Remote' remote configured? (rclone config)" }
  & $rclone ls $dst

  Info "DONE. To acquire on the TARGET machine, run from the repo root there:"
  Info "  pwsh <path>\transfer-session.ps1 -Mode pull -SessionId $SessionId"
  Info "(or -SessionId latest). Then: claude --resume $SessionId"
  exit 0
}

# ============================== PULL ==============================
if ($Mode -eq 'pull') {
  $repoAbs = (Resolve-Path $RepoRoot).Path
  $work = Join-Path $env:TEMP "transfer-session-pull-$([guid]::NewGuid().ToString('N').Substring(0,8))"
  New-Item -ItemType Directory -Force -Path $work | Out-Null

  if ($BundleZip) {
    if (-not (Test-Path $BundleZip)) { Die "BundleZip not found: $BundleZip" }
    Copy-Item $BundleZip "$work\bundle.zip" -Force
  } else {
    $rclone = Get-Rclone; if (-not $rclone) { Die "rclone not found; install+config it, or pass -BundleZip <downloaded.zip>." }
    if (-not $SessionId -or $SessionId -eq 'latest') {
      Info "resolving latest session under $Remote`:$DriveRoot/ ..."
      $dirs = & $rclone lsf "$Remote`:$DriveRoot/" --dirs-only 2>$null
      if (-not $dirs) { Die "No sessions found under $Remote`:$DriveRoot/." }
      # pick the most-recently-modified session folder
      $latest = ($dirs | ForEach-Object { $n=$_.TrimEnd('/'); $t=(& $rclone lsl "$Remote`:$DriveRoot/$n/" 2>$null | Select-Object -First 1); [pscustomobject]@{n=$n; t=$t} } | Sort-Object t -Descending | Select-Object -First 1).n
      $SessionId = $latest
      Info "latest = $SessionId"
    }
    Info "downloading $Remote`:$DriveRoot/$SessionId/ ..."
    & $rclone copy "$Remote`:$DriveRoot/$SessionId/" $work
    if ($LASTEXITCODE -ne 0) { Die "rclone download failed (exit $LASTEXITCODE)." }
    $z = Get-ChildItem "$work\*.zip" | Select-Object -First 1
    if (-not $z) { Die "No .zip downloaded." }
    Move-Item $z.FullName "$work\bundle.zip" -Force
  }

  $ext = Join-Path $work 'extract'
  Expand-Archive "$work\bundle.zip" $ext -Force
  $meta = Get-Content "$ext\meta.json" -Raw | ConvertFrom-Json
  $sid  = $meta.sessionId
  Info "restoring session $sid (from repo $($meta.sourceRepoPath), git $($meta.gitCommit))"

  # Target project dir name(s). Claude Code derives it from the repo's absolute path, but the
  # drive-letter case can vary (this machine has both 'e--' and 'E--'). Restore to every plausible
  # name so `claude --resume` finds the transcript+memory regardless of which case CC uses here.
  $cands = New-Object System.Collections.Generic.List[string]
  if ($meta.sourceRepoPath -and ($meta.sourceRepoPath -ieq $repoAbs) -and $meta.sourceProjectDir) { $cands.Add($meta.sourceProjectDir) }
  $enc = ConvertTo-ProjectDir $repoAbs; $cands.Add($enc)
  if ($enc.Length -ge 1) {                       # drive-letter case flip (e-- <-> E--)
    $c0 = $enc.Substring(0,1)
    if ([char]::IsUpper([char]$c0)) { $c0 = $c0.ToLower() } else { $c0 = $c0.ToUpper() }
    $cands.Add($c0 + $enc.Substring(1))
  }
  $cands = $cands | Select-Object -Unique

  foreach ($leaf in $cands) {
    $destProj = Join-Path $ProjectsBase $leaf
    New-Item -ItemType Directory -Force -Path (Join-Path $destProj 'memory') | Out-Null
    Copy-Item "$ext\session\$sid.jsonl" $destProj -Force
    if (Test-Path "$ext\session\$sid") { Copy-Item "$ext\session\$sid" (Join-Path $destProj $sid) -Recurse -Force }
    if (Test-Path "$ext\memory") { Copy-Item "$ext\memory\*" (Join-Path $destProj 'memory') -Recurse -Force -ErrorAction SilentlyContinue }
    Info "  restored transcript+memory -> $destProj"
  }

  # assets
  foreach ($a in $meta.assets) {
    $srcA = Join-Path $ext ($a.stage -replace '/','\')
    if (-not (Test-Path $srcA)) { Info "  asset missing in bundle: $($a.stage)"; continue }
    $dest = [Environment]::ExpandEnvironmentVariables($a.dest)
    if (-not [System.IO.Path]::IsPathRooted($dest)) { $dest = Join-Path $repoAbs $dest }
    $parent = Split-Path $dest -Parent; if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item $srcA $dest -Recurse -Force
    Info "  asset -> $dest"
  }

  # self-install this skill on the target
  if (Test-Path "$ext\skill\transfer-session.ps1") {
    $skillDest = Join-Path $env:USERPROFILE '.claude\skills\transfer-session'
    New-Item -ItemType Directory -Force -Path $skillDest | Out-Null
    Copy-Item "$ext\skill\*" $skillDest -Recurse -Force
    Info "  skill installed -> $skillDest"
  }

  Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
  Info "DONE. Next:"
  Info "  1) ensure the repo is present/updated:  git -C `"$repoAbs`" pull   (remote: $($meta.gitRemote))"
  Info "  2) resume the conversation:             claude --resume $sid"
  if ($meta.sourceRepoPath -and ($meta.sourceRepoPath -ne $repoAbs)) { Info "  NOTE: source repo path was $($meta.sourceRepoPath); restored under THIS path's project dir(s): $($cands -join ', ') so resume works here." }
  exit 0
}
