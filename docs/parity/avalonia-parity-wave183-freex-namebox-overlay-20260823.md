# FreeX Wave 183 Name Box Overlay Parity

Date: 2026-08-23
Worktree: `parity-wave183-freex-overlay`
Branch: `codex/parity-wave183-freex-overlay`

## Scope

This note records the bounded FreeX correction for the remaining Linux Name Box dropdown failure from Wave 182. The Wave 183 integration note and the cross-app dashboard were intentionally left unchanged.

## Product correction

The Name Box dropdown no longer depends on an Avalonia `PopupRoot` overlay surface on Linux. The production window now owns an in-window client overlay canvas and a fixed 208 x 136 surface. The surface is positioned from the real Name Box button with `TranslatePoint`, is attached to the normal visual tree, and uses the standard `ListBox` as its sole renderer, focus owner, and pointer/keyboard selection target.

The final zero-item cause was startup lifecycle ordering, not row rasterization. `MainWindow` seeds optional physical fixtures while it is constructed with deferred startup-file opening, then `App.CompleteStartupAsync` opens the supplied CSV and replaces that session. `OpenStartupFileAsync` now invokes a production no-op partial hook only after a successful startup-specific session replacement. The opt-in physical evidence implementation uses that hook to reseed the requested fixture into the loaded workbook, refresh the shell, and initialize fresh evidence. Normal user file opens do not invoke the hook.

This is normal user-visible behavior. No screenshot, native-input shortcut, evidence threshold relaxation, or shipping-boundary change was added. `FreeXPhysicalEvidence` remains opt-in and the authoritative physical evidence path remains separate from the product build.

## Metrics

Wave 182 baseline:

- Popup event: `overlay-layer`, `x=64`, `y=214`, `width=208`, `height=136`.
- `name-box-dropdown-parity`: `0/1`.
- `name-box-dropdown`: `0/8`.
- Root crop contained the popup frame but no dropdown labels and no usable selection input.

Exact commit `9537c46c86eb1ff95cf337a826c94e738cc8f290` verification before the lifecycle correction:

- Session `20260822T223200313Z`, port 6110: `name-box-dropdown-parity` returned `0/1`. The exact 208 x 136 root crop at `64,214` contained only the white frame because the startup CSV session had zero parity items.
- Session `20260822T223549484Z`, port 6111: `name-box-dropdown` returned `0/8`. Every object probe stopped at `popup-opened`; the active workbook contained none of the requested fixture entries.

Final amended-source evidence after the lifecycle correction:

- Session `20260822T225845860Z`, port 6113: `name-box-dropdown-parity` passed `1/1` (`passed=1`, `failed=0`, `total=1`). The authoritative unscaled crop is exactly 208 x 136 at `64,214`, provenance `x11-root-crop-overlay-layer`, and visibly contains the five expected labels once each.
- Session `20260822T230112664Z`, port 6114: `name-box-dropdown` passed `8/8` (`passed=8`, `failed=0`, `total=8`). Keyboard and pointer table selection both produced `North/120`; the defined name produced `Region`; table navigation produced `North/120`; and Chart, Picture, Shape, and TextBox selections produced their exact expected object kinds, IDs, Name Box text, and active cells.
- The four object identities were Chart `67000000-0000-0000-0000-000000000004`, Picture `67000000-0000-0000-0000-000000000002`, Shape `67000000-0000-0000-0000-000000000001`, and TextBox `67000000-0000-0000-0000-000000000003`.

There is no remaining Name Box physical blocker in these selectors.

## Verification

- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~AvaloniaMainWindowNameBoxStage2Tests ...`: passed, 17/17.
- `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.Batch5.csproj -c Release --filter FullyQualifiedName~NameBoxDropdownParityCaptureSourceTests ...`: passed, 4/4.
- Docker `name-box-dropdown-parity`: final `1/1`, session `20260822T225845860Z`.
- Docker `name-box-dropdown`: final `8/8`, session `20260822T230112664Z`.

The focused managed test verifies the production overlay is attached, has the expected 208 x 136 bounds, is hit-testable, renders five standard-list rows, and focuses its real list. The source guard verifies the successful startup-session replacement hook, post-open physical reseed/refresh, client-tree placement, coordinate translation, physical event provenance, and the unchanged authoritative crop rules.

## Cleanup

Only the assigned worktree was changed. The physical runners stopped their 6110 through 6114 containers, assigned-container status was checked, and `dotnet build-server shutdown` was run before the amended commit. No machine-wide process termination was used.
