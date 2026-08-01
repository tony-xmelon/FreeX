# FreeP Chart Add-Series Coordinates - 2026-08-01

`AddChartSeriesCommand` now seeds Scatter X-values and Bubble sizes alongside the new series' value slots. This keeps a newly added series structurally valid for PowerPoint's scatter and bubble chart editors while preserving the existing undo/reference path.

Verification: `ChartDataCommandTests` passed 75/75, including Bubble add-series coordinate coverage.
