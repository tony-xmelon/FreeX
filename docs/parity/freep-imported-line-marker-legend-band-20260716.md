# FreeP imported line-marker legend band parity

## Scope

This slice matches the right-side plot reservation for the imported
`06-charts.pptx` LineMarkers chart. PowerPoint gives that chart a narrower
legend band than the adjacent imported style-2 column chart, which moves the
four category positions and the legend rightward.

## COM Evidence

Fresh PowerPoint exports and FreeP WPF renders were captured at 1280x720.

| Comparison | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint, deck 06 average | 1.1874% | 1.1823% |
| WPF vs PowerPoint, deck 06 line slide | 1.7984% | 1.7780% |

The column, stock, and bar control slides were unchanged. The imported chart
types control `18-chart-types.pptx` also remained unchanged at an average of
`0.8568%` with slide residuals `0.6172%`, `0.7999%`, `1.2423%`, and `0.7679%`.

## Verification

- `ChartRenderPlannerTests` and `ChartBaselineCorpusTests`: 188 passed.
- `FreeP.RenderCompare` build: 0 warnings, 0 errors.
- Avalonia deck 06 comparison: `1.1116%` average versus PowerPoint.
