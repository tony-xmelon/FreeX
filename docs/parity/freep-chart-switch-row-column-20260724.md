# FreeP Chart Switch Row/Column - 2026-07-24

FreeP chart data editing now supports PowerPoint's Switch Row/Column workflow in both
WPF and Avalonia. The operation is performed on the dialog's private shared grid before
commit: old series names become category labels, old category labels become series names,
and the nullable values matrix is transposed without turning gaps into zeroes.

The dialog then commits through the existing `ReplaceChartDataCommand`, so the complete
orientation change is one undoable edit and the normal PPTX chart workbook regeneration
path remains authoritative on save.

## Verification

- Shared chart-data planner: 19/19 focused tests
- WPF ChartDataDialog: 12/12 focused tests
- Avalonia ChartDataDialog: 1/1 headless test, including the transposed commit plan
