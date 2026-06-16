# FreeX Release Prep — File Associations & Self-Update

**Date:** 2026-06-16
**Branch context:** release prep for FreeX 0.x tester channel
**Status:** Design — approved scope, pending spec review

## Goal

Make FreeX installable and self-maintaining for a public/tester release:

1. **File associations** — let users open supported files with FreeX from Explorer/Finder, without stealing Office's defaults.
2. **Self-update** — the app keeps itself current from GitHub Releases, with a deliberately discreet update affordance.

Distribution moves from a bare portable `.exe` to a [Velopack](https://velopack.io)-based release that produces **both** an installer and a portable build from one pack step.

## Why Velopack

- Free, MIT-licensed, actively maintained (successor to Squirrel.Windows, same author).
- Cross-platform: Windows, macOS, Linux — covers both the WPF (`FreeX.App.Host`) and Avalonia (`FreeX.App.Avalonia`) apps from one framework.
- Delta updates (users download only the diff), per-user install (no admin / UAC — matches the existing `asInvoker` app manifest), GitHub Releases as the update feed.
- A single `vpk pack` run emits the installer **and** a portable zip; the Velopack runtime is baked into both, so the portable build also auto-updates (in place, inside its extracted folder).

## Non-goals

- No Microsoft Store / MSIX rework in this effort (existing MSIX path left as-is).
- No stealing of `.xlsx` / `.xls` default associations from Excel.
- No silent/forced auto-update; updates are user-acknowledged via a discreet indicator.
- Linux packaging (Velopack supports it, but out of scope here).

---

## Distribution model

`vpk pack` (run after `dotnet publish`) produces, per platform, into GitHub Releases:

- **Windows:** `FreeX-win-Setup.exe` (per-user installer → `%LocalAppData%\FreeX`, Start-menu shortcut, registers file associations) + `FreeX-win-Portable.zip` + full/delta `.nupkg` + `RELEASES` manifest.
- **macOS:** `FreeX-osx.app` bundle packaged as `FreeX-osx-Setup` + portable zip + nupkg + RELEASES (Phase C).

Both Windows artifacts auto-update from the same feed. The portable build does **not** touch the registry (no file associations); portable users use "Open with" instead. Version stays sourced from `src/FreeX.App.Host/FreeX.App.Host.csproj` `<Version>`; the release channel continues to come from `release/progress.json` `channel`.

---

## File associations (native + neutral only)

Policy:

| Extension | Behavior |
|---|---|
| `.fxl` (FreeX native) | **Default handler.** FreeX owns it; nobody else claims it. |
| `.csv`, `.tsv`, `.tab`, `.txt`, `.xml` | Registered ProgId + added to **"Open with"** list. Existing default handler is **not** overwritten. User opts in via Explorer/Finder. |
| `.xlsx`, `.xls` | "Open with" only. Excel keeps the default. |

### Windows (Phase B)

- Per-user registry under `HKCU\Software\Classes`. For each owned/offered type: a ProgId (e.g. `FreeX.Workbook.fxl`) with friendly name, `DefaultIcon`, and `shell\open\command = "<path>\FreeX.App.Host.exe" "%1"`; and an `OpenWithProgids` entry under the extension key.
- Default-handler assignment only for `.fxl`. Neutral/Office types get `OpenWithProgids` only (never the `(Default)` of the extension key).
- Registration runs in the Velopack **install hook**; unregistration (clean removal of all FreeX ProgIds and OpenWith entries) runs in the **uninstall hook**. `SHChangeNotify(SHCNE_ASSOCCHANGED)` is called so Explorer refreshes.
- Each ProgId references a per-type icon resource.

### macOS (Phase C)

- Declared statically in `Info.plist`: `CFBundleDocumentTypes` (with `LSHandlerRank` = `Owner` for `.fxl`, `Alternate` for neutral/Office types) and `UTExportedTypeDeclarations` for the FreeX UTI.
- No runtime registration needed; Launch Services picks it up when the `.app` is installed. The shared `IFileAssociationService` on macOS is mostly a no-op / status query.

### Launch handling

Already works: Explorer/Finder launches the executable with the file path as an argument; `App.xaml.cs` startup arg handling (and the Avalonia equivalent) opens it. No change required to the open path.

---

## Self-update (notify + discreet indicator)

### Behavior

- **On startup**, after the main window is shown, off the UI thread: check the GitHub Releases feed for the app's channel (`release/progress.json` `channel`, e.g. `test`). Network/feed failures are caught, logged via Serilog, and otherwise ignored — never block launch or surface an error.
- **If an update is found:** download it in the background. When ready, reveal the discreet indicator.
- **Manual check:** the existing "Check for Updates" menu item (`MainWindow.ReviewCommands.cs`) is rewired from "open browser" to invoke `IUpdateService` directly. Forces a check; if none, shows a brief "You're up to date" affordance.

### Discreet update indicator

- **Normally hidden.** Lives at the **right edge of the status bar** (`StatusBarRoot`, `MainWindow.xaml:1189`) in WPF; in the Avalonia window chrome for macOS.
- When an update is downloaded and ready, it fades in as a subtle muted glyph + short text ("↻ Update ready"), styled to match status-bar text (not a banner, not a toast, not modal).
- Click → small flyout: version + a **Restart & Update** button (Velopack `ApplyUpdatesAndRestart`). Dismissing leaves the update to apply on the next natural restart.

### Fallback

If the Velopack `UpdateManager` is unavailable (e.g. running from a dev/debug build that wasn't packed), `IUpdateService` degrades to the current behavior: the indicator/menu opens the GitHub releases page. No crash, no error.

---

## Bootstrap requirement

`VelopackApp.Build().Run()` MUST be the first thing executed in the app's `Main`/startup, before any UI. Velopack uses this to service its install/update/uninstall hook invocations and exit fast. The install/uninstall hooks (`WithAfterInstallFastCallback` / `WithBeforeUninstallFastCallback`) call into `IFileAssociationService`.

---

## Components, isolation & testing

| Unit | Responsibility | Depends on |
|---|---|---|
| `IFileAssociationService` (abstraction) | register / unregister / query associations | — |
| `WindowsFileAssociationService` | HKCU ProgId + OpenWith registry read/write; `SHChangeNotify` | registry (Win32) |
| `MacFileAssociationService` | query Launch Services status; register is declarative (Info.plist) | macOS APIs (minimal) |
| `IUpdateService` (abstraction) | check / download / apply; channel selection; up-to-date vs available decision | — |
| `VelopackUpdateService` | wraps Velopack `UpdateManager` against the GitHub feed | Velopack |
| Velopack bootstrap + install/uninstall hooks | `VelopackApp.Build().Run()`; call association service on (un)install | `IFileAssociationService` |
| Update indicator (WPF status bar / Avalonia chrome) | reveal-on-ready, flyout with Restart & Update | `IUpdateService` |

### Testing strategy

- `WindowsFileAssociationService`: unit-tested against a redirected/test registry hive — register → assert ProgId + `OpenWithProgids` entries + that neutral-type `(Default)` is untouched → unregister → assert clean. Verifies the "don't steal defaults" invariant explicitly.
- `IUpdateService` decision logic: unit-tested with the Velopack manager faked behind the interface — no-network, up-to-date, and update-available paths each produce the correct state and never throw.
- Install hook, real `vpk pack` output, and live Launch Services / Explorer integration: verified manually on real machines via a documented checklist (touches the live registry/installer/OS association DB).
- Existing test gates apply: `dotnet build FreeX.slnx -c Release` + `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` (per build/verification policy). UIE2E is not a merge gate.

### Error-handling principle

Every association and update operation is best-effort and logged. A failure in either subsystem never blocks app launch, file opening, or normal use.

---

## Phasing (parallelizable)

- **Phase A — shared core (must land first):** `IUpdateService` + `IFileAssociationService` abstractions in the services layer; Velopack NuGet + `VelopackApp.Build().Run()` bootstrap; `VelopackUpdateService` + update-decision unit tests. Platform-agnostic.
- **Phase B — Windows (WPF):** `WindowsFileAssociationService` + tests, install/uninstall hooks, status-bar update indicator, `vpk pack` Windows mode in `tools/Publish-UserTestBuild.ps1`, `tester-release.yml` wiring → Setup.exe + Portable.zip uploaded.
- **Phase C — macOS (Avalonia):** `Info.plist` document-type / exported-UTI declarations, `MacFileAssociationService` (status/query), Velopack mac packaging, discreet indicator in Avalonia chrome, `macos-app.yml` wiring.

Phases B and C are independent once A lands and target disjoint files/platforms → suitable for parallel subagents. A is the prerequisite for both.

---

## Open questions / risks

- **Code signing:** unsigned is acceptable for the tester channel; signing (Windows cert via the existing `MsixCertificatePath`/env mechanism, macOS notarization) is wired as optional and resolved before a public/stable promotion.
- **Existing portable users:** users on the old bare-exe won't auto-migrate to the Velopack-managed install; release notes must point them to the new Setup.exe once. One-time migration messaging is a documentation task, not code.
- **macOS notarization** is required for Gatekeeper-clean distribution and may gate Phase C's public release (not its implementation).
