# Insert Table/Pivot Residual - 2026-06-08

## Scope

- Insert > Table / Format as Table source-range defaults.
- Insert > PivotTable and Insert > Recommended PivotTables source-range defaults.
- Create/source range dialog planner and command-source tests already present in the tree.

## Findings

- FreeX already exposes range boxes, range-picker buttons, keyboard focus/select-all behavior, and owned invalid-range warnings for Create Table, Create PivotTable, and Change PivotTable Data Source dialogs.
- Recommended PivotTables intentionally routes to the normal PivotTable workflow; Excel's recommendation heuristics remain excluded in parity docs because they depend on proprietary Microsoft data-pattern logic.
- The common Excel workflow of clicking one cell inside a contiguous table-like list, then choosing Insert > Table or Insert > PivotTable, is covered in this aggregate branch through `CreateTableSourceRangePlanner` and `PivotTableSourceRangePlanner`.
- Explicit multi-cell selections remain explicit, and collapsed dialog range-pickers continue to use literal selected ranges.

## Current Aggregate Coverage

- `CreateTableSourceRangePlannerTests.Create_ExpandsSingleCellSelectionToCurrentRegion` proves Insert > Table / Format as Table expands a single selected data cell to the current region.
- `PivotTableSourceRangePlannerTests.Create_ExpandsSingleCellSelectionToCurrentRegion` proves Insert > PivotTable uses the current region for the same workflow.
- `PivotTableSourceRangePlannerTests.CreatePlan_ExpandsSingleColumnSelectionToWiderCurrentRegion` proves one-dimensional selected slices expand to the full current region before PivotTable source validation.

## Remaining Gaps

- Recommended PivotTables still does not implement Excel's proprietary recommendation dialog/cards; it remains an excluded heuristic surface while normal PivotTable creation stays in scope.
- Live UI evidence against a loaded representative workbook was not run in this slice; coverage is focused planner/source tests.
