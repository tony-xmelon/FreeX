<#
.SYNOPSIS
  Install the transfer-session skill into the Claude Code user skills dir so it is invocable
  as /transfer-session. Just installs the skill - does NOT pull a session.
  Run from anywhere:  pwsh <path>\install.ps1
#>
$ErrorActionPreference = 'Stop'
$src  = $PSScriptRoot
$dest = Join-Path $env:USERPROFILE '.claude/skills/transfer-session'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
foreach ($f in 'SKILL.md','transfer-session.ps1') {
  $p = Join-Path $src $f
  if (-not (Test-Path $p)) { Write-Error "missing $f next to install.ps1"; exit 1 }
  Copy-Item $p $dest -Force
}
Write-Host "[transfer-session] installed -> $dest"
Write-Host "[transfer-session] Restart Claude Code, then use:  /transfer-session preflight | push | pull"
