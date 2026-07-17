# FreeP stock fallback line weight

## Scope

The imported depth corpus contains a `stockChart` without `c:hiLowLines`. PowerPoint renders this as four ordinary category line series, with stronger line and marker raster coverage than FreeP's generic line defaults.

## Change

`ChartRenderPlanner.BuildStockFallbackLineSeriesPrimitives` now uses stock-specific defaults:

- line stroke thickness: `2.0`
- marker radius: `4.0`
- marker symbols remain diamond, square, triangle, and X in series order

The values are isolated to the stock fallback and do not change authored line charts or true high-low stock charts.

## COM evidence

Fixture: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

Fresh pre-change WPF comparison:

- whole deck: `2.6873%`
- stock ROI: `5.2754%`

Post-change rerun:

- whole deck WPF: `2.6933%`
- whole deck Avalonia: `1.0990%` WPF-vs-Avalonia: `2.3715%` Avalonia-vs-PowerPoint
- stock ROI: `4.5897%`

The full-deck value is effectively stable across repeated COM exports; the stock ROI is the decision metric for this scoped change. The remaining stock residual is concentrated in the axis/title raster, not the series weight.

## Verification

Focused planner test: `BuildScenePlan_StockLineFallback_UsesPowerPointStrokeAndMarkerDefaults` passed.
