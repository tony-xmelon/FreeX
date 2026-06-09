# Data Sort Outline Scenarios Parity Notes

## Fixed Or Already Covered In This Slice

- Advanced Filter defaults the list range to the current region when opened from a single active cell inside a data list. Explicit multi-cell selections are preserved.
- Forecast Sheet promotes a single active cell to its surrounding current region when that region is a command-usable two-column forecast source.
- Scenario Manager now defaults new scenarios to "Prevent changes", matching Excel's Add Scenario default.

## Inspected Without Code Changes

- Text to Columns remains an explicit single-column selection workflow. A single selected cell converts that cell, which is consistent with the command's current wizard and overwrite checks.
- Consolidate remains an explicit reference/destination workflow. Its dialog already exposes the Excel-style all-references list and range pickers.
- Outline grouping remains direct row/column grouping based on row/column selections. A fuller Excel-style ambiguous selection prompt would need additional dialog surface beyond this bounded slice.

## Remaining Follow-Up

- Quick Sort has focused range-planner coverage for current-region and header handling in this parent branch, but the Sort Ascending/Descending ribbon buttons still need a future wiring pass through `MainWindow.DataFilterCommands.cs`.
- Data Validation command wiring also lives in `MainWindow.DataFilterCommands.cs`; it was inspected during this slice and left to the existing filter/data-validation owner.
