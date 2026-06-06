# Multiplatform Port Plan: macOS First

**Last updated:** 2026-06-06

FreeX v1 is intentionally a native Windows desktop app built on WPF. ADR-001 accepted that WPF is Windows-only and deferred cross-platform delivery, while preserving optionality by keeping the workbook model, formula engine, command layer, calculation layer, and file adapters UI-independent.

This plan records the preparation path for a future multiplatform port, starting with macOS.

## Current State

- `Core.Model`, `Core.Formula`, `Core.Calc`, `Core.Commands`, and `Core.IO` target plain `net10.0`.
- `App.Host`, `App.UI`, UI tests, and several interop tools target `net10.0-windows` and use WPF.
- The documented architecture already keeps core projects from referencing app projects.
- `FreeX.DefaultTests.slnx` contains the non-UI test lane and is the first practical macOS validation target.
- Excel COM smoke/fidelity tools remain Windows-only and should stay in Windows lanes.

## GitHub Actions macOS Validation

GitHub-hosted macOS runners can be used even without a local Mac. The first macOS lane should prove portable engine readiness, not package a macOS app:

```yaml
runs-on: macos-latest
```

The CI job should:

1. Checkout the repository.
2. Install `.NET 10` through `actions/setup-dotnet`.
3. Build `FreeX.DefaultTests.slnx` in Release.
4. Test `FreeX.DefaultTests.slnx` in Release with `--no-build`.

This lane is intentionally limited to portable projects. It must not build `FreeX.slnx`, `FreeX.UiTests.slnx`, `App.Host`, `App.UI`, or WPF/COM tools.

## Preparation Work

1. **Keep the core portable.** Add or maintain source guards that prevent `System.Windows`, `Microsoft.Win32`, WinRT, COM, and WPF package references from entering `Core.*`.
2. **Introduce an app-service boundary.** Define platform-service interfaces for file dialogs, clipboard, drag/drop, hyperlink launch, app data paths, dispatching, window management, sharing, printing/export, crash reporting, and accessibility metadata.
3. **Move reusable app logic out of WPF.** Extract workbook session orchestration, command routing, menu/ribbon command models, dialog planners, options, localization, and non-visual state into a shared app layer.
4. **Separate rendering models from renderers.** Keep viewport, chart, print, icon, and drawing-object layout decisions platform-neutral, then provide WPF and macOS renderers separately.
5. **Choose the macOS UI stack by spike.** Avalonia is the most natural first candidate because it is desktop-first, XAML/C# friendly, and targets macOS, Windows, and Linux. MAUI remains a possible alternative, but its macOS path is Mac Catalyst and should be evaluated against spreadsheet-grid fidelity before committing.
6. **Keep Windows fidelity lanes.** Desktop Excel COM open/save/reopen, chart interop comparison, WPF UI automation, PDF/XPS export through WPF, and tester-release packaging remain Windows validation lanes until equivalent macOS-specific tools exist.

## First Port Milestones

1. **Portable CI gate:** macOS GitHub Actions builds and tests `FreeX.DefaultTests.slnx`.
2. **Portable app shell spike:** add a small macOS-targeting shell that starts, loads a workbook through `Core.IO`, and renders a read-only viewport from `IViewportService`. The initial shell lives in `src/FreeX.App.Avalonia` and references only portable `Core.*` projects.
3. **Grid renderer spike:** prove scrolling, selection, cell text, row/column headers, freeze panes, and basic drawing-object bounds in the candidate UI stack.
4. **Service abstraction pass:** replace direct WPF/Windows calls in reusable host logic with platform-service interfaces. `src/FreeX.App.Services` now holds the shared adapter catalog, default workbook factory, startup workbook loader, portable workbook open/save services, workbook session orchestration, active-sheet and selected-range state, selected-range status statistics calculation/formatting, cell-entry parsing, single-cell edit orchestration with Undo/Redo history, selected-range clipboard text copy/cut, internal normal paste with formula/style payloads and non-overlapping cut-source clearing, plain-text external paste orchestration, selected-range Clear Contents, Bold/Italic/Underline/Double Underline/Strikethrough formatting orchestration, selected-range font-size grow/shrink with fitting row-height updates, selected-range horizontal/vertical alignment, wrap text, indent increase/decrease, and number-format/decimal-place orchestration, formula scanning, and text-import open normalization used by the Avalonia shell and WPF host adapters.
5. **macOS packaging spike:** once the shell exists, add GitHub Actions publish jobs for `osx-arm64` and `osx-x64` artifacts.

## Initial macOS App Artifact

The `macOS App Preview` GitHub Actions workflow builds `src/FreeX.App.Avalonia` on `macos-latest`, publishes separate self-contained `osx-arm64` and `osx-x64` outputs, wraps each output in a `FreeX.app` bundle with a tracked `FreeX.icns` app icon, ad-hoc signs the bundle by default, optionally imports a Developer ID Application certificate from GitHub Secrets for hardened-runtime signing, optionally submits the zipped app to Apple's notary service and staples the accepted ticket, verifies the zipped artifact after extraction, runs a native-architecture packaged .NET host plus an open/display/navigate/edit/save/reopen workbook smoke when the runner can execute that runtime, registers the unzipped app with LaunchServices, launches it by bundle id with a workbook file and runtime report hook, and uploads zipped artifacts, SHA-256 checksums, bundle evidence, packaging-smoke transcripts, LaunchServices smoke reports, and notarization logs.

Developer ID signing is intentionally disabled for `pull_request` runs. Non-PR runs can use `MACOS_CODESIGN_CERTIFICATE_P12`, `MACOS_CODESIGN_CERTIFICATE_PASSWORD`, and `MACOS_DEVELOPER_ID_APPLICATION` for signing, plus `MACOS_NOTARY_APPLE_ID`, `MACOS_NOTARY_TEAM_ID`, and `MACOS_NOTARY_PASSWORD` for notarization.

The preview shell can open startup-argument workbooks, handle macOS file-activation events for local workbook files when Avalonia reports them, use in-app and native File menu Open commands for local workbook files, save through the native File menu Save and Save As commands, expose native Edit menu and toolbar Undo/Redo/Cut/Copy/Paste/Clear Contents plus native Format menu and toolbar Bold/Italic/Underline/Double Underline/Strikethrough/Increase Font Size/Decrease Font Size/Accounting Number Format/Percent Style/Comma Style/Increase Decimal Places/Decrease Decimal Places/Top Align/Middle Align/Bottom Align/Wrap Text/Decrease Indent/Increase Indent/Left Align/Center Align/Right Align for shared command-bus cell edits and platform clipboard text, Shift-click select visible ranges, display selected-range Average/Count/Numerical Count/Sum/Min/Max stats from the portable service layer without overwriting transient status messages, copy and cut selected ranges as spreadsheet-compatible text, paste FreeX-owned copied/cut cells through the internal command path with formula rebasing, style payloads, and non-overlapping cut-source clearing, paste changed external clipboard text as plain text, clear selected cell contents through the Delete key and native Edit menu while preserving selection and undo, apply selected-range Bold through Cmd+B/Ctrl+B, Italic through Cmd+I/Ctrl+I, Underline through Cmd+U/Ctrl+U/Ctrl+4, Double Underline through the toolbar/native Format menu, Strikethrough through Ctrl+5, and font-size changes, number formats, decimal place adjustments, horizontal/vertical alignment, wrap text, and indent increase/decrease through the toolbar/native Format menu while preserving selection and undo, accept dropped local workbook files in the app window, size the workbook viewport from the visible app surface, move the active cell with keyboard navigation, pan the workbook viewport from selection movement or mouse-wheel gestures, move the viewport with visible manual worksheet scrollbars backed by portable frozen-pane-aware scroll planning, edit the active cell through the formula box, double-click/F2 edit entry, direct typed entry, and Tab/Shift+Tab commit movement, commit pending formula-box edits before save/open/sheet/cell navigation/clipboard actions, and render noninteractive placeholder bounds for visible drawing shapes, pictures, and text boxes exposed by the shared viewport. The next recommended parity slice is Fill Color / Font Color quick apply because Avalonia already renders resolved fill and font colors while the shared session still needs selected-range color setters and command routing. The app bundle now advertises Finder document types for `.fxl` plus common spreadsheet formats; the GitHub-hosted LaunchServices smoke exercises bundle-id open-with activation and captures window/session/menu evidence including File, Edit, and Format menu items, while live human Finder double-click evidence on macOS is still pending.

The file-activation route depends on Avalonia's macOS app delegate and `IActivatableLifetime`; do not set `DisableAvaloniaAppDelegate` while Finder-open support is part of the preview artifact.

`tools/Test-MacOsAppReadiness.ps1` is wired into repository preflight and gives Windows agents a static readiness guard for the Avalonia app project, macOS `Info.plist`, hosted bundle workflow, bundled `.icns` icon, LaunchServices smoke markers, packaging smoke wiring, `.fxl` native workbook identity, and portable source hygiene. It does not replace hosted macOS runner evidence for `plutil`, apphost architecture, signing, notarization, LaunchServices activation, or runtime smoke.

This is a preview artifact, not a release channel. Public distribution still needs actual Developer ID/notarization secret configuration and successful hosted evidence, checksum instructions for testers, full drawing-object rendering and interaction parity beyond placeholder bounds, full WPF clipboard parity beyond selected-range normal cut/copy/paste (multi-range copy, Paste Special modes, image paste, comments/validation/column widths/links), and a broader macOS UI/accessibility test plan.

## Non-Goals For The First macOS Lane

- Building the current WPF app on macOS.
- Running WPF UI tests on macOS.
- Replacing Windows tester releases.
- Replacing Excel COM fidelity evidence.
- Claiming a user-ready macOS application before an actual macOS UI host exists.

## Success Criteria

- `FreeX.DefaultTests.slnx` passes on macOS Actions.
- The Windows default and UI lanes continue to pass.
- New shared app code can be exercised without WPF.
- The first macOS shell can open, display, navigate worksheets, edit, and save representative workbooks without duplicating workbook-engine logic.
- Any macOS packaging workflow is tied to a real macOS UI project, not to the current WPF host.
