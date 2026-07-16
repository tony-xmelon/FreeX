# FreeW and Word scatter marker palette

## Observation

The live Word COM baseline for `chart-smartart-complex.docx` renders the marker-only scatter chart with four blue marker fills, even though the authored chart carries the `colorful1` FreeW color-scheme extension and `c:dPt` fills of blue, orange, grey, and yellow.

The package retains those authored point fills for round-trip preservation, but Word's marker-only renderer ignores them when no explicit `c:marker` shape properties are present and falls back to its built-in blue progression.

## Implementation

`ChartSmartArtVisualPlanner.BuildChartScene` keeps `ChartVisualPlan.PaletteHex` unchanged for model semantics and uses Word's observed `mono-blue` progression for scatter scene markers and legends. The marker shapes remain the Word-style diamond, square, triangle, and cross cycle.

## Regression coverage

`ChartSmartArtVisualPlannerTests` verifies the marker colors for both the default scatter chart and a scatter chart authored with `colorful1`.
