# Multiplatform Port Plan: Linux

**Last updated:** 2026-08-08

FreeX v1 is a native Windows desktop app built on WPF (ADR-001). The macOS port
([multiplatform-macos-port.md](multiplatform-macos-port.md)) established a portable
core plus a shared app-service layer behind a cross-platform Avalonia shell
(`src/FreeX.App.Avalonia`). Avalonia already targets Linux, so the Linux port reuses
that same shell and shared services almost entirely; the Linux-specific work is build
configuration, freedesktop/XDG packaging and desktop integration, a hosted CI lane, and
readiness tooling. This plan records that path and the current Linux preview-app status.

## Current State

Since this plan's port-foundation work landed, the shared Avalonia shell has advanced far
beyond the initial preview: FreeX's generated cross-app parity dashboard
([avalonia-wpf-cross-app-dashboard.md](../parity/avalonia-wpf-cross-app-dashboard.md), refreshed
continuously from `docs/parity/*.json`) currently reports 546 FreeX functional commands with 0
Avalonia-missing entries and all 57 inventoried dialog routes captured on both WPF and Avalonia.
A dedicated Linux-Docker interactive-validation harness (`tools/LinuxInteractiveDocker/`)
independently exercises the built app inside a Linux container; its most recent full-context
catalog run, recorded in
[avalonia-parity-wave162-integration-20260806.md](../parity/avalonia-parity-wave162-integration-20260806.md)
(2026-08-06), passed **13,801 of 13,958 checks (157 skipped, 0 failed)** at `1280x820`, 96 DPI.
Feature work continues under the numbered `avalonia-parity-wave*` records in `docs/parity/`
(the highest-numbered as of this update is wave166, 2026-08-06); consult the newest
`avalonia-parity-wave*` file there for the current slice rather than treating this plan as a
live tracker of individual gaps.

- `Core.Model`, `Core.Formula`, `Core.Calc`, `Core.Commands`, and `Core.IO` target plain
  `net10.0` and already build and run on Linux.
- `FreeX.App.Services` is the shared, portable app layer (workbook session orchestration,
  command-bus editing/formatting, clipboard/Paste Special planning, dialog planners,
  export/print planning). Some previously-`FreeX.App.Services` pieces (recent-file store,
  app-data-path providers, share-action planning) have since moved into the cross-app
  `shared/Free.Shared.AppServices` tier as part of the shared-tier extraction — see
  [shared-tier-extraction.md](shared-tier-extraction.md). Either way it's the same shared
  layer the macOS lane uses; no Linux fork is required.
- `src/FreeX.App.Avalonia` is the cross-platform preview shell. It publishes self-contained
  for `linux-x64` and `linux-arm64` with a native ELF apphost (`FreeX`) and the bundled
  SkiaSharp/HarfBuzz/ICU native libraries — no system .NET is needed. Avalonia renders on
  Linux through the X11 backend (and Wayland where available); `Avalonia.FreeDesktop` provides
  AT-SPI accessibility and platform integration.
- The launch-smoke harness in `src/FreeX.App.Avalonia/MacOsLaunchSmoke.cs` is
  platform-neutral in mechanism (it inspects the Avalonia control/menu/dialog tree). It now
  exposes platform-neutral CLI aliases (`--launch-smoke`, `--launch-smoke-diagnostics-dir`,
  …) so the Linux lane drives the same headless smoke without a macOS-specific flag. The
  macOS spellings are unchanged for the existing hosted macOS lane.
- The `Linux App Preview` workflow (`.github/workflows/linux-app.yml`) builds, packages,
  and smoke-tests `osx`-free Linux artifacts on hosted Ubuntu runners.
- Windows fidelity lanes (Excel COM, WPF UI automation, WPF/XPS export, tester releases)
  remain Windows-only and unaffected.

## GitHub Actions Linux Validation

The `Linux App Preview` workflow runs on `pull_request` to `main` and on
`workflow_dispatch`. Matrix:

| runtime | arch | runner |
| --- | --- | --- |
| `linux-x64` | `x86_64` | `ubuntu-latest` |
| `linux-arm64` | `aarch64` | `ubuntu-24.04-arm` |

Each matrix leg:

1. Installs desktop runtime dependencies (`xvfb`, `libfontconfig1`, X11/EGL/GL libs,
   `desktop-file-utils`, `shared-mime-info`).
2. Runs the portable + Linux app-service test slices in `FreeX.App.Services.Tests` plus
   `ExportPathPlannerTests`, including the new `LinuxPackagingMetadataTests`,
   `LinuxAppReadinessPreflightTests`, and `LinuxPlatformPathTests`.
3. Builds and publishes the self-contained app for the runtime.
4. Validates the desktop entry (`desktop-file-validate`), MIME definition, and icon, then
   packages a relocatable `.tar.gz` (with `install.sh`/`uninstall.sh`) and, on non-PR
   dispatch, an `.AppImage`. Both carry SHA-256 checksums.
5. **Hard gate:** runs the headless `--packaging-smoke` (no display) twice and asserts the
   workbook open/edit/save/reopen, drawing-object preview, and `format_cells_style_roundtrip`
   markers.
6. **Hard gate:** runs the GUI launch smoke under `xvfb-run` with software rendering
   (`LIBGL_ALWAYS_SOFTWARE=1`, `--launch-smoke`) and asserts the cross-platform shell
   evidence (window shown, opened file, viewport rows/columns, native File/Edit/Data/Format/
   View/Sheet/Help menus, Open Recent population, Find/Replace/Go To/Format Cells dialogs,
   accessibility automation metadata) plus diagnostics `events.jsonl`.
7. Writes per-runtime evidence, tester instructions, checksums, and an always-on diagnostics
   artifact (preserved on failure).

An aggregate `linux-preview-readiness` job downloads the per-runtime app artifacts and runs
`tools/Test-LinuxPublicPreviewReadiness.ps1`, which re-checks the evidence contract,
recomputes and compares the tarball SHA-256, and publishes
`linux-preview-readiness-manifest.json`.

This lane deliberately contains no `codesign`/`notarytool`/`lsregister`/`spctl` machinery;
Linux has no Gatekeeper/notarization equivalent and trust is established by checksum (and,
per channel, AppImage signature or distro package signing). A source guard enforces this.

## Packaging And Desktop Integration

`src/FreeX.App.Avalonia/Packaging/linux/` holds the freedesktop assets, mirroring the macOS
bundle's identity and document-type associations:

- `io.github.tony-xmelon.freex.desktop` — launcher entry with `Exec=freex %F`,
  `Icon=io.github.tony-xmelon.freex`, `Categories=Office;Spreadsheet;`, and `MimeType`
  associations for the native `application/vnd.freex.workbook+json` plus xlsx/xlsm/xltx/xltm/
  xls/xlsb/csv/tsv types.
- `io.github.tony-xmelon.freex.xml` — `shared-mime-info` definition for
  `application/vnd.freex.workbook+json` (`*.fxl`, sub-class of `application/json`).
- `io.github.tony-xmelon.freex.svg` — scalable hicolor application icon.
- `package-linux-app.sh` — assembles a relocatable tarball with a `bin/freex` wrapper,
  `lib/freex/` payload, hicolor icon, MIME package, and `install.sh`/`uninstall.sh` that
  register into a per-user (`~/.local`) or system prefix and refresh the desktop/MIME/icon
  caches.
- `build-appimage.sh` — builds a single-file `.AppImage` (CI fetches the architecture-matched
  `appimagetool`).

Identity: app id `io.github.tony-xmelon.freex`, apphost `FreeX`, native type `*.fxl`.

## Platform Service Notes (Linux deltas)

Most P0/P1 capabilities are already shared (see
[macos-platform-service-inventory.md](macos-platform-service-inventory.md)). Linux-specific
behavior:

- **App data / options / diagnostics paths.** The injectable path providers fall through to
  the .NET XDG mappings on non-macOS Unix: options under
  `$XDG_CONFIG_HOME`/`~/.config/FreeX/options.json` and diagnostics under
  `$XDG_DATA_HOME`/`~/.local/share/FreeX/Diagnostics`. `LinuxPlatformPathTests` locks this in
  (and asserts no `~/Library` leakage).
- **Open / save / dialogs / clipboard / drag-drop.** Handled by Avalonia's Linux backend
  (`StorageProvider`, `IClipboard`, file drop) using the same shared open/save pipeline and
  compact dialogs as macOS. The GTK file-chooser portal is used where present.
- **External links / help / hyperlinks.** Avalonia `TopLevel.Launcher` (xdg-open). Internal
  `PlaceInThisDocument` workbook hyperlinks navigate via `WorkbookSession`; external workbook
  hyperlinks stay unsupported pending a safe platform-launch adapter, identical to macOS.
- **Share.** No native share sheet on Linux. The shared `WorkbookShareActionPlanner` fallback
  applies: saved workbooks reveal/open the containing folder; unsaved/missing/invalid/cloud
  paths route through Save As first. The macOS AppKit share-sheet adapter stays gated to the
  `net10.0-macos` TFM.
- **Print / PDF.** The portable PDF exporter is the Linux export route (ASCII + WinAnsi).
  WPF/XPS export, native print panels, and embedded-font Unicode PDF remain Windows-only or
  deferred, as on macOS.

## Readiness Tooling

- `tools/Test-LinuxAppReadiness.ps1` — Windows-runnable static preflight for the Avalonia
  project, Linux packaging assets, the `linux-app.yml` markers, the neutral launch-smoke
  alias, and the no-macOS-signing source guard.
- `tools/Test-LinuxPublicPreviewReadiness.ps1` — artifact-level validator for produced Linux
  artifacts (evidence contract, smoke status, checksum integrity, run-id agreement) that also
  emits the readiness manifest. Used by the hosted aggregate job and runnable from Windows.

## First Port Milestones

1. **Portable build/run on Linux:** self-contained `linux-x64`/`linux-arm64` publish with a
   native apphost. *(done — proven locally and in the publish step.)*
2. **Packaging + desktop integration:** `.desktop`, MIME, icon, tarball/installer, AppImage.
   *(done.)*
3. **Hosted CI lane:** build, portable tests, package, headless packaging smoke, and Xvfb GUI
   launch smoke as hard gates, plus aggregate readiness. *(done; awaiting first hosted run for
   live evidence.)*
4. **Readiness tooling + guards:** static preflight, artifact validator, packaging/path/source
   guard tests. *(done.)*
5. **Release/checklist docs:** this plan plus
   [release/linux-public-preview-checklist.md](../release/linux-public-preview-checklist.md).
   *(done.)*

## Non-Goals For The First Linux Lane

- Building the WPF app or running WPF UI tests on Linux.
- Replacing Windows tester releases or Excel COM fidelity evidence.
- Distro packaging (`.deb`/`.rpm`/Flatpak/Snap) — deferred until the tarball/AppImage preview
  is validated.
- Claiming a user-ready Linux application before human Linux validation (X11 and Wayland,
  keyboard-only, screen reader via AT-SPI/Orca) and accessibility evidence are complete.

## Success Criteria

- The Linux app workflow builds, tests, packages, and smoke-tests both runtimes on hosted
  Ubuntu runners.
- The Windows default and UI lanes and the macOS lane continue to pass unchanged.
- The Avalonia shell opens, displays, navigates, edits, and saves representative workbooks on
  Linux without duplicating workbook-engine logic.
- Produced artifacts pass `tools/Test-LinuxPublicPreviewReadiness.ps1` with intact checksums.
