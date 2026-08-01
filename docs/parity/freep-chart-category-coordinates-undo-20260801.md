# FreeP Chart Category Coordinate Undo - 2026-08-01

`AddChartCategoryCommand` and `RemoveChartCategoryCommand` now keep Scatter X-values and Bubble sizes aligned with category edits, including exact undo restoration. Intentionally absent coordinate payloads remain absent; the command does not invent coordinate metadata merely because the chart type is scatter-like.

Verification: `ChartDataCommandTests` passed 74/74, including Bubble add/undo and Scatter remove/undo coverage.
