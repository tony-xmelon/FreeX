# FreeP Chart Type Editing - 2026-07-24

FreeP's existing chart-data dialog now changes the selected chart type in both WPF and
Avalonia. The selected type is held in the dialog working copy and committed together
with categories, series names, and nullable values through one undoable
`ReplaceChartDataCommand`.

Scatter and Bubble transitions also receive valid coordinate payloads: category charts
get deterministic one-based X values, Bubble charts get default size values, and undo
restores the original X values, Bubble sizes, chart type, and scatter style.

## Verification

- Shared chart dialog and command tests: 63/63 focused tests
- WPF chart-data dialog tests: 12/12
- Avalonia chart-data dialog headless test: 1/1
- Changed chart type written to PPTX and read back as `LineMarkers`
- Scatter/Bubble transition and undo preserve coordinate payloads
