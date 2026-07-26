# Imported Column Native Legend Registration

## Scope

The imported `chart-smartart-complex.docx` style-7 `mono-blue` column chart uses a
Word compact category legend. FreeW had laid its four entries across the plot width,
while Word centers 35-DIP entries below the chart surface.

## Measured Word Geometry

At the 400x224-DIP chart frame, Word's legend keys are anchored at local X positions
136, 171, 206, and 241 with Y=200. The FreeW planner now uses that compact layout only
for imported native style-7 `mono-blue` single-series column charts with a legend.

## Matched WPF Composite Results

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 1.7033% | 1.6904% |
| Column chart ROI | 4.1373% | 4.0285% |
| Legend ROI | 5.2700% | 4.9660% |
| Scatter control ROI | 5.7109% | 5.7109% |
| Page 2 control | 0.3728% | 0.3728% |

The page-2 PNG SHA-256 is byte-identical before and after.

## Verification

- `ChartSmartArtVisualPlannerTests`: 46/46 compile and 46/46 `--no-build`
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
