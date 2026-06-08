# Formula Auditing Residual Parity - 2026-06-08

## Scope

Focused residual pass for the Formulas tab outside formula bar/name box, with emphasis on Formula Auditing and Calculation commands. This slice intentionally avoids grid, chart, review, titlebar/QAT, draw, data import/refresh, and formula bar/name box files.

## Excel References

- Microsoft Support documents that Trace Precedents first displays arrows to cells that directly provide data to the active formula, and clicking Trace Precedents again identifies the next level of precedent cells.
- Microsoft Support documents the matching Trace Dependents behavior: the first click shows cells dependent on the active cell, and repeated clicks identify the next dependent level.
- Microsoft Support documents Calculation Options entries for Automatic, Automatic except for data tables, and Manual, plus Calculate Now and Calculate Sheet commands.

Sources:

- https://support.microsoft.com/en-us/office/display-the-relationships-between-formulas-and-cells-a59bef2b-3701-46bf-8ff1-d3518771d507
- https://support.microsoft.com/en-gb/office/change-formula-recalculation-iteration-or-precision-in-excel-73fc7dac-91cf-4d36-86e8-67124f6bcce4

## Findings

### Addressed: Trace commands expanded too much on first click

FreeX previously drew the full transitive precedent/dependent chain on the first Trace Precedents or Trace Dependents click and replaced existing trace arrows of that kind. Excel expands tracing one level at a time: the first click shows direct relationships, and repeated clicks add the next level until no additional traceable cells remain.

FreeX now computes the next trace frontier and appends only newly discovered arrows. When no additional arrows are available, the command reports either that the selected cell has no direct relationships or that there are no more cells to trace.

## Remaining Formula-Tab Gaps

- Calculation Options now exposes a distinct "Automatic Except for Data Tables" mode and persists the workbook calculation setting. Full Excel what-if data-table formula/model semantics remain documented in the broader Data Table residual rather than approximated here.
- Remove Arrows split-menu parity is owned by the parent Remove Arrows work and was not changed here.
- Show Formulas visual toggle state, formula/value rendering parity, and trace arrow color/error styling remain broader UI/rendering work.
- Evaluate Formula remains bounded to FreeX's summary dialog and does not yet reproduce every Excel Step In/Step Out edge case for external references and unsupported functions.
- Watch Window is implemented, but docked-window parity and Excel's full column set remain broader UX work.
