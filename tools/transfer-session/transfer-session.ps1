<#
.SYNOPSIS
  transfer-session - package a Claude Code session (transcript + subagents + memory + local-only
  assets) into a bundle and move it between machines via Google Drive (rclone).

.DESCRIPTION
  PUSH (source machine): bundles the current session and uploads the .zip to Drive.
  PULL (target machine): downloads the bundle, restores transcript+memory+assets under THIS
  machine's project dir, and self-installs this skill. Then `claude --resume <id>`.
  PREFLIGHT: verifies rclone is installed, the remote is configured AND authorized, and that the
  session is locatable - i.e. everything that would block a transfer.

  Bytes flow disk<->Drive directly through rclone (never through the model), so there is no size limit.

.PARAMETER Mode      push | pull | preflight
.PARAMETER SessionId push: defaults to $env:CLAUDE_CODE_SESSION_ID. pull: the id to fetch, or 'latest'.
.PARAMETER Remote    rclone remote name (default 'gdrive').
.PARAMETER DriveRoot Drive folder that holds per-session bundles (default 'transfer-session').
.PARAMETER RepoRoot  Repo/cwd used to locate the project dir + resolve repo-relative assets (default: cwd).
.PARAMETER BundleZip pull: use a local .zip instead of downloading (skips rclone).
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)][ValidateSet('push','pull','preflight')] [string]$Mode,
  [string]$SessionId,
  [string]$Remote   = 'gdrive',
  [string]$DriveRoot= 'transfer-session',
  [string]$RepoRoot = (Get-Location).Path,
  [string]$BundleZip
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../ToolScriptSupport.ps1')
function Info($m){ Write-Host "[transfer-session] $m" }
function Die($m){ Write-Error "[transfer-session] $m"; exit 1 }

# --- resolve rclone (winget puts it on PATH after a shell restart; fall back to known install dirs) ---
function Get-Rclone {
  $c = Get-Command rclone -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  $cands = if ((Test-ToolIsWindows) -and -not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    @((Join-Path $env:LOCALAPPDATA 'Microsoft/WinGet/Links/rclone.exe')) +
      @(Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Microsoft/WinGet/Packages/Rclone.Rclone*/*/rclone.exe') -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
  } else { @() }
  foreach ($p in $cands) { if ($p -and (Test-Path $p)) { return $p } }
  return $null
}

# Drive free bytes via `rclone about` (null if unavailable).
function Get-RcloneFreeBytes($rc,[string]$remote){
  try { $j = (& $rc about "$remote`:" --json) | ConvertFrom-Json; return [int64]$j.free } catch { return $null }
}

# Verify everything that would block a transfer: rclone present, remote configured, token actually
# works (reachable/authorized, not just declared). Prints a checklist; returns $true/$false.
function Test-Prereqs([string]$remote){
  $rc = Get-Rclone
  if (-not $rc){ Write-Host "  [FAIL] rclone not found. Install: winget install Rclone.Rclone  (then open a fresh shell)"; return $false }
  $ver = (& $rc version 2>$null | Select-Object -First 1)
  Write-Host "  [ ok ] rclone: $rc  ($ver)"
  $remotes = @(& $rc listremotes 2>$null)
  if ($remotes -notcontains "$remote`:"){
    Write-Host "  [FAIL] rclone remote '$remote`:' not configured. Run 'rclone config' (new remote named '$remote', type 'drive', finish browser OAuth)."
    if ($remotes){ Write-Host "         configured remotes: $($remotes -join ' ')" }
    return $false
  }
  Write-Host "  [ ok ] remote '$remote`:' configured"
  $about = & $rc about "$remote`:" --json
  if ($LASTEXITCODE -ne 0){
    Write-Host "  [FAIL] remote '$remote`:' is configured but NOT reachable/authorized (token expired or offline)."
    Write-Host "         Reconnect with: rclone config reconnect $remote`:"
    return $false
  }
  try { $free=[int64](($about | ConvertFrom-Json).free); Write-Host "  [ ok ] authorized; Drive free ~$([math]::Round($free/1GB,1)) GB" } catch { Write-Host "  [ ok ] authorized" }
  return $true
}

$ProjectsBase = Join-Path $env:USERPROFILE '.claude/projects'
$SkillDir     = $PSScriptRoot                      # this skill's own folder (for self-propagation)

# Encode an absolute path the way Claude Code names its project dir: ':' '\' '/' -> '-'.
function ConvertTo-ProjectDir([string]$absPath){ return ($absPath -replace '[:\\/]','-') }

# Find the project dir that actually contains <sid>.jsonl (robust to drive-letter case etc.).
function Resolve-ProjectDirForSession([string]$sid){
  $hit = Get-ChildItem $ProjectsBase -Directory -ErrorAction SilentlyContinue |
         Where-Object { Test-Path (Join-Path $_.FullName "$sid.jsonl") } | Select-Object -First 1
  if ($hit){ return $hit.FullName }
  return $null
}

# ============================== PREFLIGHT ==============================
if ($Mode -eq 'preflight') {
  Write-Host "[transfer-session] preflight (remote: $Remote)"
  $ok = Test-Prereqs $Remote
  $sid = if ($SessionId) { $SessionId } else { $env:CLAUDE_CODE_SESSION_ID }
  if ($sid) {
    $pd = Resolve-ProjectDirForSession $sid
    if ($pd) { Write-Host "  [ ok ] current session $sid found ($pd)" }
    else     { Write-Host "  [warn] session $sid .jsonl not found under $ProjectsBase (push needs it)" }
  } else { Write-Host "  [warn] CLAUDE_CODE_SESSION_ID unset - pass -SessionId for push" }
  if (Get-Command Compress-Archive -ErrorAction SilentlyContinue) { Write-Host "  [ ok ] Compress-Archive available (PowerShell $($PSVersionTable.PSVersion))" }
  else { Write-Host "  [FAIL] Compress-Archive missing (need PowerShell 5+)"; $ok = $false }
  if ($ok) { Write-Host "[transfer-session] PREFLIGHT OK - ready to push/pull."; exit 0 }
  else     { Write-Host "[transfer-session] PREFLIGHT FAILED - fix the [FAIL] item(s) above."; exit 1 }
}

# ============================== PUSH ==============================
if ($Mode -eq 'push') {
  if (-not $SessionId) { $SessionId = $env:CLAUDE_CODE_SESSION_ID }
  if (-not $SessionId) { Die "No SessionId and CLAUDE_CODE_SESSION_ID is unset. Pass -SessionId." }
  Write-Host "[transfer-session] preflight:"
  if (-not (Test-Prereqs $Remote)) { Die "preflight failed - fix the [FAIL] item(s) above and retry (or run -Mode preflight)." }
  $rclone = Get-Rclone

  $projDir = Resolve-ProjectDirForSession $SessionId
  if (-not $projDir) { Die "Could not find $SessionId.jsonl under $ProjectsBase." }
  $repoAbs = (Resolve-Path $RepoRoot).Path

  $stage = Join-Path ([IO.Path]::GetTempPath()) "transfer-session-$SessionId"
  if (Test-Path $stage){ Remove-Item $stage -Recurse -Force }
  $stageSession = Join-Path $stage 'session'
  $stageMemory = Join-Path $stage 'memory'
  $stageAssets = Join-Path $stage 'assets'
  $stageSkill = Join-Path $stage 'skill'
  New-Item -ItemType Directory -Force -Path $stageSession, $stageMemory, $stageAssets, $stageSkill | Out-Null

  Info "session  : $SessionId"
  Info "projDir  : $projDir"
  Copy-Item (Join-Path $projDir "$SessionId.jsonl") $stageSession -Force
  if (Test-Path (Join-Path $projDir $SessionId)) { Copy-Item (Join-Path $projDir $SessionId) (Join-Path $stageSession $SessionId) -Recurse -Force }
  if (Test-Path (Join-Path $projDir 'memory')) { Copy-Item (Join-Path $projDir 'memory/*') $stageMemory -Recurse -Force -ErrorAction SilentlyContinue }
  Copy-Item (Join-Path $SkillDir '*') $stageSkill -Recurse -Force -ErrorAction SilentlyContinue

  # local-only assets from manifest: lines `SRC` or `SRC => DEST` (# comments). SRC repo-relative or absolute.
  # DEST (restore target) repo-relative or absolute; env vars like %USERPROFILE% are expanded on pull.
  $assetMap = @()
  $manifest = Join-Path $repoAbs '.claude/transfer-session.assets'
  if (Test-Path $manifest) {
    Get-Content $manifest | ForEach-Object {
      $line = $_.Trim(); if (-not $line -or $line.StartsWith('#')) { return }
      $parts = $line -split '\s*=>\s*', 2
      $src = $parts[0].Trim(); $dest = if ($parts.Count -gt 1) { $parts[1].Trim() } else { $src }
      $srcAbs = if ([System.IO.Path]::IsPathRooted($src)) { $src } else { Join-Path $repoAbs $src }
      if (-not (Test-Path $srcAbs)) { Info "  asset MISSING (skipped): $src"; return }
      $name = Split-Path $srcAbs -Leaf
      $stageRel = "assets/$name"
      Copy-Item $srcAbs (Join-Path $stage $stageRel) -Recurse -Force
      $assetMap += [pscustomobject]@{ stage = $stageRel; dest = $dest }
      Info "  asset    : $src -> $dest"
    }
  } else { Info "no assets manifest at $manifest (session+memory only)" }

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
  } | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $stage 'meta.json') -Encoding UTF8

  $zip = Join-Path ([IO.Path]::GetTempPath()) "transfer-session-$SessionId.zip"
  if (Test-Path $zip){ Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -CompressionLevel Optimal
  $zipLen = (Get-Item $zip).Length
  $mb = [math]::Round($zipLen/1MB,2)
  Info "bundle   : $zip ($mb MB)"

  $free = Get-RcloneFreeBytes $rclone $Remote
  if (($null -ne $free) -and ($zipLen -gt $free)) {
    Die "bundle ($mb MB) exceeds Drive free space (~$([math]::Round($free/1GB,2)) GB). Free up Drive or use a remote with space."
  }

  $dst = "$Remote`:$DriveRoot/$SessionId/"
  Info "uploading -> $dst"
  & $rclone copy $zip $dst
  if ($LASTEXITCODE -ne 0) { Die "rclone upload failed (exit $LASTEXITCODE)." }
  & $rclone ls $dst

  Info "DONE. To acquire on the TARGET machine, run from the repo root there:"
  Info "  pwsh <path>\transfer-session.ps1 -Mode pull -SessionId $SessionId"
  Info "(or -SessionId latest). Then: claude --resume $SessionId"
  exit 0
}

# ============================== PULL ==============================
if ($Mode -eq 'pull') {
  $repoAbs = (Resolve-Path $RepoRoot).Path
  $work = Join-Path ([IO.Path]::GetTempPath()) "transfer-session-pull-$([guid]::NewGuid().ToString('N').Substring(0,8))"
  New-Item -ItemType Directory -Force -Path $work | Out-Null

  if ($BundleZip) {
    if (-not (Test-Path $BundleZip)) { Die "BundleZip not found: $BundleZip" }
    Copy-Item $BundleZip (Join-Path $work 'bundle.zip') -Force
  } else {
    Write-Host "[transfer-session] preflight:"
    if (-not (Test-Prereqs $Remote)) { Die "preflight failed - fix the [FAIL] item(s) above, or pass -BundleZip <downloaded.zip> to skip rclone." }
    $rclone = Get-Rclone
    if (-not $SessionId -or $SessionId -eq 'latest') {
      Info "resolving latest session under $Remote`:$DriveRoot/ ..."
      $dirs = & $rclone lsf "$Remote`:$DriveRoot/" --dirs-only 2>$null
      if (-not $dirs) { Die "No sessions found under $Remote`:$DriveRoot/." }
      $latest = ($dirs | ForEach-Object { $n=$_.TrimEnd('/'); $t=(& $rclone lsl "$Remote`:$DriveRoot/$n/" 2>$null | Select-Object -First 1); [pscustomobject]@{n=$n; t=$t} } | Sort-Object t -Descending | Select-Object -First 1).n
      $SessionId = $latest
      Info "latest = $SessionId"
    }
    $probe = @(& $rclone lsf "$Remote`:$DriveRoot/$SessionId/" 2>$null)
    if (-not ($probe | Where-Object { $_ -match '\.zip$' })) {
      $have = (@(& $rclone lsf "$Remote`:$DriveRoot/" --dirs-only 2>$null) | ForEach-Object { $_.TrimEnd('/') }) -join ', '
      Die "No bundle at $Remote`:$DriveRoot/$SessionId/. Push from the source first, or use -SessionId latest. (Sessions present: $have)"
    }
    Info "downloading $Remote`:$DriveRoot/$SessionId/ ..."
    & $rclone copy "$Remote`:$DriveRoot/$SessionId/" $work
    if ($LASTEXITCODE -ne 0) { Die "rclone download failed (exit $LASTEXITCODE)." }
    $z = Get-ChildItem (Join-Path $work '*.zip') | Select-Object -First 1
    if (-not $z) { Die "No .zip downloaded." }
    Move-Item $z.FullName (Join-Path $work 'bundle.zip') -Force
  }

  $ext = Join-Path $work 'extract'
  Expand-Archive (Join-Path $work 'bundle.zip') $ext -Force
  $meta = Get-Content (Join-Path $ext 'meta.json') -Raw | ConvertFrom-Json
  $sid  = $meta.sessionId
  Info "restoring session $sid (from repo $($meta.sourceRepoPath), git $($meta.gitCommit))"

  # Target project dir name(s). Claude Code derives it from the repo's absolute path, but the
  # drive-letter case can vary (a machine may have both 'e--' and 'E--'). Restore to every plausible
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
    Copy-Item (Join-Path $ext "session/$sid.jsonl") $destProj -Force
    if (Test-Path (Join-Path $ext "session/$sid")) { Copy-Item (Join-Path $ext "session/$sid") (Join-Path $destProj $sid) -Recurse -Force }
    if (Test-Path (Join-Path $ext 'memory')) { Copy-Item (Join-Path $ext 'memory/*') (Join-Path $destProj 'memory') -Recurse -Force -ErrorAction SilentlyContinue }
    Info "  restored transcript+memory -> $destProj"
  }

  foreach ($a in $meta.assets) {
    $srcA = Join-Path $ext ([string]$a.stage)
    if (-not (Test-Path $srcA)) { Info "  asset missing in bundle: $($a.stage)"; continue }
    $dest = [Environment]::ExpandEnvironmentVariables($a.dest)
    if (-not [System.IO.Path]::IsPathRooted($dest)) { $dest = Join-Path $repoAbs $dest }
    $parent = Split-Path $dest -Parent; if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item $srcA $dest -Recurse -Force
    Info "  asset -> $dest"
  }

  if (Test-Path (Join-Path $ext 'skill/transfer-session.ps1')) {
    $skillDest = Join-Path $env:USERPROFILE '.claude/skills/transfer-session'
    New-Item -ItemType Directory -Force -Path $skillDest | Out-Null
    Copy-Item (Join-Path $ext 'skill/*') $skillDest -Recurse -Force
    Info "  skill installed -> $skillDest"
  }

  Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
  Info "DONE. Next:"
  Info "  1) ensure the repo is present/updated:  git -C `"$repoAbs`" pull   (remote: $($meta.gitRemote))"
  Info "  2) resume the conversation:             claude --resume $sid"
  if ($meta.sourceRepoPath -and ($meta.sourceRepoPath -ne $repoAbs)) { Info "  NOTE: source repo path was $($meta.sourceRepoPath); restored under this path's project dir(s): $($cands -join ', ')" }
  exit 0
}
