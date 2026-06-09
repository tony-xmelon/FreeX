# Chart Data Source Residual - 2026-06-08

## Scope

This slice covered chart insertion and Select Data source behavior from normal worksheet ranges, single-cell selections inside data regions, table-like/structured-table ranges, filtered or hidden source rows/columns, and chart command guards for protected sheets and PivotChart object targets.

Out of scope for this slice: contextual chart tab affordances, AutoFilter flyout UI, PageLayout/status/footer, Insert table/pivot, Formula, Draw UI, titlebar/QAT, data import, protected-sheet command-matrix breadth, and paste residuals.

## Findings

- Explicit multi-cell chart insertion already used the selected range and remains unchanged.
- Single-cell chart insertion used the literal one-cell selection, so a normal Excel-style "current region" insertion could be rejected before a chart was created.
- Structured table metadata existed, but chart insertion did not prefer the table range when the active single cell was inside a table.
- Filtered/hidden rows and columns are represented on the sheet. Chart authoring should preserve the full source range while leaving `ShowDataInHiddenRowsAndColumns` false by default so writer metadata emits Excel's visible-cells-only default.
- Select Data preview accepted absolute and sheet-qualified references, but the command handler reparsed with a simpler parser. Existing other-sheet ranges could be rejected as invalid UI input instead of reaching the chart same-sheet command guard.
- `ChangeChartSourceCommand` already had the right protected-sheet and PivotChart guard path; this slice added focused tests for it.

## Changes

- Added `ChartDataSourcePlanner.ResolveInsertionRange`:
  - keeps explicit multi-cell selections unchanged;
  - expands single-cell selections to the current region;
  - prefers a containing `StructuredTableModel.Range` for single-cell selections inside a structured table;
  - preserves filtered/hidden row and column state without mutation.
- Routed embedded chart and chart-sheet insertion through the planner.
- Switched chart data-range parsing to `WorkbookRangeTextCodec` while still requiring a range expression. Absolute A1 and R1C1 ranges now parse, and sheet-qualified existing ranges can reach the model command guard.
- Passed `ResolveSheetIdByName` into Select Data validation and handler parsing.

## Verification

- Synced from `main` immediately before verification, then ran `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartInputParserTests|FullyQualifiedName~ChartCommandSourceTests|FullyQualifiedName~ChartDialogTests.SelectDataSource|FullyQualifiedName~RibbonChartButtons_RouteThroughRenderableChartInsertionCommandPath"` - passed, 47/47.
- Ran `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~ChartDataSourcePlannerTests|FullyQualifiedName~AddChartCommand_PreservesHiddenFilteredSourceRangeAndDefaultsToPlotVisibleCellsOnly|FullyQualifiedName~ChangeChartSourceCommand_RejectsProtectedSheetWithoutEditObjectsPermission|FullyQualifiedName~ChangeChartSourceCommand_AllowsProtectedSheetWithEditObjectsPermission|FullyQualifiedName~ChangeChartSourceCommand_RejectsPivotCharts"` - passed, 8/8.
- `git diff --check` - passed with only Git line-ending normalization warnings for touched text files.

## Remaining Gaps

- Cross-sheet chart data sources remain a model limitation: existing other-sheet ranges now parse, then `ChangeChartSourceCommand` rejects them with the same-sheet chart data-range guard.
- The Select Data dialog still exposes preview/add/edit affordances at a light model level; full Excel series editing and live render evidence remains broader chart UI scope.
