# Foreground Capture Harness - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-foreground-harness-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-foreground-harness-20260610`
- Base: local `main` at `8e40a19dd` after merging `origin/main` into the UX evidence commits.

## Remaining Slice Count

The remaining UX parity closeout is tracked as 7 open umbrella slices after S8 closed:

| Slice | Status after this pass |
|---|---|
| S1 Excel/FreeX paired main ribbon capture matrix | Open. |
| S2 Popup, dropdown, and gallery captures | Four-surface opened-state pairing closed for AutoFilter, Home Borders, Home Number Format, and worksheet context menu. Broader popup/gallery breadth remains open. See `docs/parity/worker-popup-evidence-pairing-s2s7-2026-06-10.md`. |
| S3 Native Open/Save/Background/export dialogs | Advanced: Excel Open, FreeX Open, and FreeX Save As foreground dialog-open proof is retained; Excel Save As is blocked by Office `NUIDialog`, and Background/export/native print proof remains open. See `docs/parity/ux-s3-native-dialogs-backstage-export-2026-06-10.md`. |
| S4 Grid pointer mechanics | Partially advanced: foreground grid/header drag selection proof is retained, but precise cell-range drag and other pointer mechanics remain open. See `docs/parity/foreground-pointer-harness-2026-06-10.md`. |
| S5 Sheet-tab pointer mechanics | Partially advanced: foreground sheet-tab right-click context-menu proof is retained; double-click rename, drag reorder, modifier grouping, overflow arrows, and Excel pairing remain open. |
| S6 Status/footer pointer mechanics | Advanced: foreground status Zoom In/Out clicks, physical zoom slider drag, native UIA RangeValue set, and Ctrl+wheel-over-grid zoom proof are retained; footer view shortcut physical clicks, zoom percentage/dialog physical click proof, Shift/ordinary wheel distinctions, min/max breadth, Ctrl+Alt+=/-, and Excel pairing remain open. |
| S7 Excel-paired popup/dialog captures | Four-surface opened-state pairing closed for AutoFilter, Home Borders, Home Number Format, and worksheet context menu; broader Excel-paired popup/dialog breadth remains open. |

Closed but no longer counted as remaining: S8 non-visual model-depth tail closed by `38d05898c` with focused tests/docs for cross-target matrix, locale/accounting, accessibility/formula/watch breadth, and native persistence warnings.

S8 is fully closed. The remaining umbrella slices still have open sub-scenarios, but the harness and pairing docs converted several previously foreground-blocked sub-scenarios into retained evidence.

## Harness Added

- `tools/FreeX.ForegroundCapture/FreeX.ForegroundCapture.csproj`
- `tools/FreeX.ForegroundCapture/Program.cs`
- `tools/Invoke-ForegroundCapture.ps1`

The harness uses guarded foreground activation with `AttachThreadInput`, `SetForegroundWindow`, `BringWindowToTop`, and process/title validation before sending input or capturing screen pixels. Excel scenarios are launched through COM and cleaned up by the harness-owned PID. FreeX scenarios launch the Release host executable from the active worktree.

## Captures Retained

| Scenario | Result | Evidence |
|---|---|---|
| `excel-autofilter` | Complete | `tools/foreground-captures/excel-autofilter/excel-autofilter_20260610_151710.png`, `excel-autofilter_manifest.json` |
| `excel-open-dialog` | Complete | `tools/foreground-captures/excel-open-dialog/excel-open-dialog_20260610_142513.png`, `excel-open-dialog_manifest.json` |
| `excel-borders` | Complete | `tools/foreground-captures/excel-borders/excel-borders_20260610_141515.png`, `excel-borders_manifest.json` |
| `excel-number-format` | Complete | `tools/foreground-captures/excel-number-format/excel-number-format_20260610_143114.png`, `excel-number-format_manifest.json` |
| `excel-context-menu` | Complete | `tools/foreground-captures/excel-context-menu/excel-context-menu_20260610_143257.png`, `excel-context-menu_manifest.json` |
| `freex-open-dialog` | Complete | `tools/foreground-captures/freex-open-dialog/freex-open-dialog_20260610_142532.png`, `freex-open-dialog_manifest.json` |
| `freex-save-as-dialog` | Complete | `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_20260610_142550.png`, `freex-save-as-dialog_manifest.json` |
| `freex-status-zoom-in-click` | Complete | `tools/foreground-captures/freex-status-zoom-in-click/freex-status-zoom-in-click_20260610_170919.png`, `freex-status-zoom-in-click_manifest.json` |
| `freex-status-zoom-out-click` | Complete | `tools/foreground-captures/freex-status-zoom-out-click/freex-status-zoom-out-click_20260610_170615.png`, `freex-status-zoom-out-click_manifest.json` |
| `freex-status-zoom-slider-drag` | Complete | `tools/foreground-captures/freex-status-zoom-slider-drag/freex-status-zoom-slider-drag_20260610_170816.png`, `freex-status-zoom-slider-drag_manifest.json` |
| `freex-status-zoom-slider-rangevalue-set` | Complete | `tools/foreground-captures/freex-status-zoom-slider-rangevalue-set/freex-status-zoom-slider-rangevalue-set_20260610_170649.png`, `freex-status-zoom-slider-rangevalue-set_manifest.json` |
| `freex-status-ctrl-wheel-grid-zoom` | Complete | `tools/foreground-captures/freex-status-ctrl-wheel-grid-zoom/freex-status-ctrl-wheel-grid-zoom_20260610_170732.png`, `freex-status-ctrl-wheel-grid-zoom_manifest.json` |
| `freex-sheet-tab-context-menu` | Complete | `tools/foreground-captures/freex-sheet-tab-context-menu/freex-sheet-tab-context-menu_20260610_160955.png`, `freex-sheet-tab-context-menu_manifest.json` |
| `freex-grid-drag-select` | Partial | `tools/foreground-captures/freex-grid-drag-select/freex-grid-drag-select_20260610_161353.png`, `freex-grid-drag-select_manifest.json` |

## Blocked or Needs Harness Follow-Up

| Scenario | Current result |
|---|---|
| `excel-save-as-dialog` | Foreground acquisition succeeds and F12 exposes an Office `NUIDialog`, but that helper window is not a capturable native Save As file dialog in this Office state. Needs the Office backstage Save As path or another visible dialog trigger. |
| `freex-grid-drag-select` | Retained foreground proof shows a header-style selected span after physical drag input, not the intended cell-range drag. Needs WPF-aware target-coordinate refinement before it can close cell-range drag selection. |

## Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` passed.
- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors after adding the UIA Number Format and guarded right-click context-menu paths.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` passed with 0 warnings and 0 errors.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- First `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-foreground-harness.trx"` had one transient timing-only perf failure in `FormulaEvaluatorPerformanceTests.RepeatedBooleanCoercionFormulaTextEvaluation_AvoidsCoercedNumberChurn`.
- Focused rerun of that perf test passed.
- Full rerun `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-foreground-harness-rerun.trx"` passed with 0 failures.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --list-slices` originally reported 8 umbrella slices; after the S8 closeout, the foreground harness reports 7 open umbrella slices.
