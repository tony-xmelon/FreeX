# Foreground Capture Harness - 2026-06-10

Branch/worktree:

- Branch: `codex/ux-parity-foreground-harness-20260610`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-foreground-harness-20260610`
- Base: local `main` at `8e40a19dd` after merging `origin/main` into the UX evidence commits.

## Remaining Slice Count

The remaining UX parity closeout is tracked as 8 umbrella slices:

| Slice | Status after this pass |
|---|---|
| S1 Excel/FreeX paired main ribbon capture matrix | Open. |
| S2 Popup, dropdown, and gallery captures | Partially advanced: Excel Home Borders, Number Format, and worksheet context-menu foreground captures succeeded. |
| S3 Native Open/Save/Background/export dialogs | Partially advanced: Excel Open, FreeX Open, and FreeX Save As foreground captures succeeded. |
| S4 Grid pointer mechanics | Open. |
| S5 Sheet-tab pointer mechanics | Open. |
| S6 Status/footer pointer mechanics | Open. |
| S7 Excel-paired popup/dialog captures | Partially advanced: Excel Open, Borders, Number Format, and worksheet context-menu captures now have retained foreground evidence. |
| S8 Non-visual model-depth tail | Open. |

No umbrella slice is fully closed yet because each still has remaining sub-scenarios, but the new harness converted several previously foreground-blocked sub-scenarios into retained evidence.

## Harness Added

- `tools/FreeX.ForegroundCapture/FreeX.ForegroundCapture.csproj`
- `tools/FreeX.ForegroundCapture/Program.cs`
- `tools/Invoke-ForegroundCapture.ps1`

The harness uses guarded foreground activation with `AttachThreadInput`, `SetForegroundWindow`, `BringWindowToTop`, and process/title validation before sending input or capturing screen pixels. Excel scenarios are launched through COM and cleaned up by the harness-owned PID. FreeX scenarios launch the Release host executable from the active worktree.

## Captures Retained

| Scenario | Result | Evidence |
|---|---|---|
| `excel-open-dialog` | Complete | `tools/foreground-captures/excel-open-dialog/excel-open-dialog_20260610_142513.png`, `excel-open-dialog_manifest.json` |
| `excel-borders` | Complete | `tools/foreground-captures/excel-borders/excel-borders_20260610_141515.png`, `excel-borders_manifest.json` |
| `excel-number-format` | Complete | `tools/foreground-captures/excel-number-format/excel-number-format_20260610_143114.png`, `excel-number-format_manifest.json` |
| `excel-context-menu` | Complete | `tools/foreground-captures/excel-context-menu/excel-context-menu_20260610_143257.png`, `excel-context-menu_manifest.json` |
| `freex-open-dialog` | Complete | `tools/foreground-captures/freex-open-dialog/freex-open-dialog_20260610_142532.png`, `freex-open-dialog_manifest.json` |
| `freex-save-as-dialog` | Complete | `tools/foreground-captures/freex-save-as-dialog/freex-save-as-dialog_20260610_142550.png`, `freex-save-as-dialog_manifest.json` |

## Blocked or Needs Harness Follow-Up

| Scenario | Current result |
|---|---|
| `excel-autofilter` | Foreground acquisition now succeeds, but the header-arrow trigger misses the filter button in this desktop/DPI layout. The old PowerShell script still cannot acquire foreground while Word owns focus, so the next step is porting or improving a UIA/coordinate-specific AutoFilter trigger. |
| `excel-save-as-dialog` | Foreground acquisition succeeds, but F12 did not expose the expected dialog in this Office state. Needs the Office backstage Save As path or NUIDialog detection broadening. |

## Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` passed.
- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors after adding the UIA Number Format and guarded right-click context-menu paths.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` passed with 0 warnings and 0 errors.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- First `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-foreground-harness.trx"` had one transient timing-only perf failure in `FormulaEvaluatorPerformanceTests.RepeatedBooleanCoercionFormulaTextEvaluation_AvoidsCoercedNumberChurn`.
- Focused rerun of that perf test passed.
- Full rerun `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-foreground-harness-rerun.trx"` passed with 0 failures.
- `dotnet run --project tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release -- --list-slices` reported 8 remaining umbrella slices.
