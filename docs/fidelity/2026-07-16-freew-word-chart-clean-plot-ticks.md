# FreeW and Word chart clean plot/tick parity

## Observation

The live Word COM raster for `chart-smartart-complex.docx` shows no horizontal gridlines in either the filled column chart (`Style 7`, `Quick Layout 9`) or the marker-only scatter chart (`Style 4`). Word keeps the black value/category axes and adds midpoint category ticks between the four column categories.

## Implementation

`ChartSmartArtVisualPlanner.BuildChartScene` keeps the authored `ChartVisualPlan.ShowGridlines` value intact, while applying Word's effective clean-plot behavior at scene-render time for those two gallery combinations. Column scenes add the four category-center ticks and three midpoint minor ticks.

## Evidence

- Word: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/word-png-production-final/chart-smartart-complex_p1.png`
- FreeW: `freew-fidelity-corpus/runs/smartart-hierarchy-next-20260716/freew-column-cleanplot-final/chart-smartart-complex_p1.png`

## Verification

- `ChartSmartArtVisualPlannerTests`: 44/44
- `ChartRenderingTests`: 19/19
