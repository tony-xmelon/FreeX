# Grid Pointer Mechanics Parity Slice - 2026-06-07

Scope owned by this subagent: row/column resize pointer mechanics and ordinary mouse-wheel scrolling. Excluded areas stayed untouched: autofill, Page Layout margin guides, split dividers beyond existing wheel routing, Ctrl-wheel/status zoom, ribbon, context menus, and sheet tabs.

## Findings

- Resize hit testing already uses header-only hit bands, nearest visible header edge selection, and bounded scans over visible `RowMetric`/`ColMetric` lists. Existing `GridResizeHitPlannerTests` cover the main header edges, overlap tie-breaking, and early scan exits.
- Mouse-wheel behavior did not require a code change in this slice. `SheetGrid_MouseWheel` normalizes raw WPF deltas, uses Shift for horizontal scrolling, resolves split-pane wheel targets from the pointer position before deciding scrollability, and delegates range extension/clamping to `ViewportScrollCalculator`.
- Row/column drag resize had a parity gap: `GridView.Input` clamped live resize and commit sizes to `5px`, while the command layer already treats `0` row height / column width as the Excel-style hide operation. Dragging a header border fully closed therefore could not hide rows or columns.

## Fixes

- Added `GridResizeSizePlanner` to centralize pointer-resize clamping:
  - columns: `0..2040px`, matching the current host `/ 8.0` column-width bridge for Excel's `0..255` modeled width range;
  - rows: `0..409.5px`, matching Excel's row-height command limit.
- Routed column and row live preview plus mouse-up commit through that planner, so pointer drags can now emit `0` and existing host commands hide selected rows/columns.
- Added focused tests proving:
  - UI clamp permits `0` instead of forcing a minimum visual size;
  - UI clamp caps at current Excel command limits;
  - GridView drag code uses the planner for preview and commit;
  - host commit of `0` hides selected column/row spans and clears explicit size overrides.

## Remaining Gaps

- 2026-06-08 follow-up: hidden row/column boundary unhide by dragging the collapsed double-line is now covered. The grid receives hidden row/column metadata, the resize hit planner prefers collapsed hidden boundaries over neighboring visible resize edges, and host resize routing expands the contiguous hidden span instead of the visible selection.
- Exact column pixel-to-character parity is still approximate. The resize commit path divides dragged pixels by `8.0`, while rendering uses the workbook column-width-to-pixels conversion. This slice preserved that bridge and only bounded it to valid command input.
- Wheel behavior is covered by focused calculator/source tests, but exact hardware parity for high-resolution touchpads should still be manually validated.

## Verification

- `dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter "FullyQualifiedName~GridResize" --logger "trx;LogFileName=grid-resize-ui.trx"` - passed 16/16.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowMouseResizeTests" --logger "trx;LogFileName=grid-resize-host.trx"` - passed 10/10.
- `dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Debug --no-restore --filter "FullyQualifiedName~GridResizeHitPlannerTests|FullyQualifiedName~GridResizeSizePlannerTests|FullyQualifiedName~GridViewPointerCursorTests|FullyQualifiedName~GridViewContextMenuTests|FullyQualifiedName~GridViewAutofillTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed 85/85.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Debug --no-restore --filter "FullyQualifiedName~MainWindowMouseResizeTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed 12/12 after clearing a stale timed-out VSTest child that locked `FreeX.App.Host.resources.dll`.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ViewportScrollCalculatorTests" --logger "trx;LogFileName=viewport-scroll-calculator.trx"` - passed 14/14.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - first run failed one unrelated formula performance threshold on the busy shared machine (`RepeatedBooleanCoercionFormulaTextEvaluation_AvoidsCoercedNumberChurn`, 2147 ms vs 2000 ms).
- `dotnet test tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~FormulaEvaluatorPerformanceTests.RepeatedBooleanCoercionFormulaTextEvaluation_AvoidsCoercedNumberChurn" --logger "trx;LogFileName=formula-boolean-coercion-rerun.trx"` - passed 1/1 at 959 ms.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-rerun.trx"` - passed on rerun.

After a later sync from `main`, the post-merge verification was repeated:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~GridResize"` - passed 16/16.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~MainWindowMouseResizeTests"` - passed 10/10.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ViewportScrollCalculatorTests"` - passed 14/14.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-final.trx"` - failed one unrelated model performance threshold (`GetMergeRegion_DoesNotExpandTallMergedRegionsPerCell`, 216 ms vs 200 ms); isolated rerun passed 1/1.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-final-rerun.trx"` - failed one unrelated formula performance threshold (`RepeatedBooleanCoercionFormulaTextEvaluation_AvoidsCoercedNumberChurn`, 4595 ms vs 2000 ms); isolated rerun passed 1/1 at 951 ms.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build -m:1 --logger "trx;LogFileName=default-tests-serial.trx"` - passed serial diagnostic run across the default projects.
