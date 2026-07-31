# FreeX Avalonia parity Wave 86: PivotTable formula-point references

Date: 2026-07-31

## Concrete divergence

WPF's formula-point selection path checks the persisted `GenerateGetPivotData` option when a
single selected cell is inside a PivotTable. With the option enabled, WPF inserts the existing
shared `GetPivotDataFormulaPlanner` result; with it disabled, or for an ordinary cell, it inserts
the normal A1 reference. Avalonia always used the normal range-reference path, so clicking a
PivotTable value cell while entering a formula produced `=F4` instead of WPF's
`=GETPIVOTDATA("Sum of Amount",E2,"Region","West")`.

## Change and evidence

Avalonia now reads the shared persisted option through the same write-time-cached options pattern
used by its other formula-entry settings. Its single-cell formula-point path invokes the shared
planner with the original formula sheet and active PivotTable sheet, while ordinary ranges and
non-PivotTable cells retain the existing range-reference behavior.

Paired runtime evidence:

- WPF `R92_PivotClickGetPivotDataToggleTests`: 3/3 passed.
- Avalonia `R92_PivotClickGetPivotDataToggleAvaloniaTests`: 3/3 passed.
- Nearby Avalonia formula-point/edit regression set: 37/37 passed.

The slice does not change the shared planner or WPF implementation. The existing options dialog
surface remains outside this slice; this change consumes the persisted option already shared by
the application services and matches the WPF runtime contract.
