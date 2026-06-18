# transfer-session (skill source)

Versioned copy of the `transfer-session` Claude Code skill. It packages a session
(transcript + subagent logs + memory + local-only assets) into a zip and moves it between
machines via Google Drive using **rclone** — bytes flow disk↔Drive directly (no size limit).

Claude Code discovers skills from `~/.claude/skills/` (which is gitignored), so this repo copy is
the **source of truth / backup**; install it by copying into the skills dir:

```powershell
Copy-Item -Recurse -Force tools\transfer-session "$env:USERPROFILE\.claude\skills\transfer-session"
```

(The skill's own `pull` mode also self-installs it on a target machine from the transferred bundle,
so a machine that *acquires* a session gets the skill automatically.)

## Usage
- **Push (source):** `pwsh ~/.claude/skills/transfer-session/transfer-session.ps1 -Mode push`
- **Pull (target):** `pwsh <path>/transfer-session.ps1 -Mode pull -SessionId <id>` (or `-SessionId latest`)

Prereq: `winget install Rclone.Rclone` then `rclone config` a `gdrive` Google Drive remote (one-time
browser OAuth, done by the user). See `SKILL.md` for the asset-manifest format and full details.
