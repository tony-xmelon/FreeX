# FreeP chart series ordering - 2026-07-27

FreeP chart data editing now supports PowerPoint-style series ordering in both WPF and
Avalonia. The chart data dialog tracks the active series from its header or value cell and
exposes Move Series Up/Down actions. The shared working-copy planner moves the series name,
values, scatter X coordinates, and bubble sizes together before the dialog commits its one
undoable `ReplaceChartData` batch.

The presentation model also exposes `EditingSession.MoveChartSeries`, backed by the shared
`MoveChartSeriesCommand`. That direct command reorders the existing `ChartSeries` instance, so
authored fill, point colors, labels, trendlines, error bars, and other series-owned settings
stay attached to the series. Undo restores the original order and workbook regeneration is
marked consistently.

Focused coverage:

- presentation planner and command tests cover order, undo, formatting, and scatter coordinates;
- WPF chart-data dialog tests pass 37/37;
- Avalonia chart-data dialog/headless tests cover the reorder path;
- the existing PPTX writer/reader path consumes the reordered series list on save/reopen.

This is function/package parity. It does not claim a new PowerPoint raster baseline; chart
visual fidelity remains governed by the existing renderer evidence lane.
