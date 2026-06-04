# PivotTable New Worksheet Destination Design

## Goal

Close the Insert PivotTable destination gap where the dialog exposes "New worksheet" but the host currently stops with an informational message.

## Scope

- Add an undoable core command that creates a new worksheet and places a worksheet-range PivotTable on it.
- Wire the Insert PivotTable dialog's New Worksheet choice to that command.
- Select the created sheet after insertion and open the field list when requested.
- Update parity and architecture documentation.

## Constraints

- Keep external/OLAP/data-model PivotTables excluded.
- Reuse the existing `AddPivotTableCommand` and `PivotTableRefreshService` behavior for authored PivotTables.
- Respect workbook structure protection.
- Avoid native Excel sheet naming magic beyond deterministic, unique FreeX names.

## Decision

New worksheet PivotTables will be created on a unique sheet named `PivotTable`, `PivotTable 2`, etc. The initial report anchor is `A3`, matching Excel's common new-worksheet placement and leaving room for future report-filter rows.
