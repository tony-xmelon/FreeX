# FreeP Imported 100%-Stacked Data-Label Wrapping

Date: 2026-07-17

## Scope

Match PowerPoint's imported `ColumnStacked100` data-label text boxes in
`22-chart-baseline-depth.pptx`. PowerPoint keeps the shorter `Actual` labels
on one line and wraps the longer `Forecast` labels after the category name.

## Change

Imported percent-stacked labels now use a measured 92 px label box and opt
into a two-line render route. Other chart data labels retain their one-line
behavior.

## Verification

- `ChartBaselineCorpusTests`: `23 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- `22-chart-baseline-depth.pptx` WPF mean channel diff: `3.1353%`, down from
  `3.1393%` at the start of this slice.
- Final render size: `1280x720`; PowerPoint and FreeP dimensions match.
