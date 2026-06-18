---
name: transfer-session
description: Use when the user wants to move/transfer/migrate the current Claude Code session to another machine, hand off a session, back it up to the cloud, or acquire/resume a session that was transferred from another computer. Packages transcript + memory + local-only assets and moves them via Google Drive (rclone).
---

# transfer-session

## Overview
One-step transfer of a Claude Code session between machines. Bundles the **conversation transcript + subagent logs + memory files + local-only assets** into a zip and moves it through Google Drive using **rclone** (bytes flow disk↔Drive directly — no size limit, nothing routed through the model). Two modes: **push** (source) and **pull** (target).

Code itself travels via git; this skill moves the things git does NOT carry (the session transcript, the `~/.claude` memory, and gitignored/large local assets).

## When invoked (what Claude should do)
Parse the args after `/transfer-session`:
- **`push`** (or no args) → bundle + upload the current session. (Auto-runs preflight first.)
- **`pull [<sessionId>|latest]`** → download + restore (default `latest`). (Auto-runs preflight first.)
- **`preflight`** / **`check`** → verify rclone is installed, the remote is configured AND authorized, the session is locatable, and zip support exists — i.e. anything that would block a transfer. Run this when the user wants to confirm setup, or first on a new machine.
- **`status`** → `rclone ls gdrive:transfer-session/` to list transferred sessions.

Then RUN it yourself via the PowerShell tool (don't make the user run anything) and report the result + next step (`claude --resume <id>` for pull). The script's preflight gives actionable `[FAIL]` messages — if it reports rclone/remote not set up, walk the user through the one-time `rclone config` (the OAuth is theirs to click). Pass the script path `~/.claude/skills/transfer-session/transfer-session.ps1` (resolve `~` to `$env:USERPROFILE`). Refresh PATH first: `$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')+';'+[Environment]::GetEnvironmentVariable('Path','User')`.

## Prerequisites
- **rclone** installed and a remote configured (default name `gdrive`): `winget install Rclone.Rclone`, then `rclone config` → new remote `gdrive` → Google Drive → finish the browser OAuth. The user must do the OAuth (it's their Google login); you cannot.
- Run from the **repo root** (used to locate the project dir and resolve repo-relative assets).

## Push (source machine) — package + upload, one step
```
pwsh ~/.claude/skills/transfer-session/transfer-session.ps1 -Mode push
```
- Session is auto-detected from `$env:CLAUDE_CODE_SESSION_ID`. Override with `-SessionId <id>`.
- Bundles: `<sid>.jsonl` + `<sid>/subagents/`, the project's `memory/`, this skill (so the target can self-install), and any assets listed in the manifest.
- Uploads to `gdrive:transfer-session/<sid>/bundle.zip` and prints the exact **pull** command.

## Pull (target machine) — acquire + restore, one step
Run from the repo root on the target (clone/pull the repo first):
```
pwsh <path>/transfer-session.ps1 -Mode pull -SessionId <id>      # or: -SessionId latest
```
- Downloads + extracts the bundle, then restores under **this** machine's project dir (re-derived from the target's repo path, so `claude --resume` finds it locally), self-installs this skill, and restores assets.
- No rclone on the target? Download the zip from Drive manually and pass `-BundleZip <path-to.zip>`.
- Finish with: `claude --resume <sid>` (and `git pull` to get the code).

## Assets manifest (what local-only files to include)
Optional per-repo file `.claude/transfer-session.assets` (gitignored is fine — the push reads it and bakes the resolved list into the bundle's `meta.json`, so the target doesn't need it). One entry per line; `#` comments:
```
# SRC[ => DEST]   SRC: repo-relative or absolute. DEST (restore target): repo-relative or absolute; %ENV% expanded on pull.
test-corpus/public/contextures => test-corpus/public/contextures
E:\Users\anton\Downloads\ExcelExamples1.xlsx => %USERPROFILE%\Downloads\ExcelExamples1.xlsx
```
No manifest → session + memory only.

## Notes / gotchas
- **Path-sensitivity of resume:** Claude Code derives the project-dir name from the repo's absolute path. Pull re-derives it for the target, so resume works even if the repo lives at a different path than on the source.
- **OAuth is the user's step** — never enter their Google credentials; rclone's browser flow handles it.
- `-Remote`/`-DriveRoot` override the rclone remote name and the Drive parent folder.
- Verify an upload landed: `rclone ls gdrive:transfer-session/<sid>/`.
