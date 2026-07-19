# FreeP imported combo grid raster probes rejected - 2026-07-18

## Scope

Fresh current-main PowerPoint COM output for `19-chart-labels.pptx`, slide 3,
showed the imported combo grid using exact one-pixel `#898989` bands in
PowerPoint while WPF and Avalonia anti-aliased the same planned one-DIP lines
across adjacent rows. Two renderer-local probes were run against that same
current Release baseline:

- Replaced imported-combo grid lines with filled one-pixel rectangles.
- Shifted imported-combo horizontal/vertical grid lines by 0.5 DIP before the
  WPF draw call.

Both probes were restricted to the imported combo signature. Chart geometry,
labels, legends, secondary-axis ticks, other chart families, and the two
control slides were unchanged.

## Matched COM evidence

Baseline and candidate captures used the same 1280x720 PowerPoint export and
rebuilt Release artifacts:

| Metric | Baseline | Rectangle | Half-pixel |
| --- | ---: | ---: | ---: |
| WPF slide 3 whole page | 1.9488% | 2.2243% | 2.2243% |
| Avalonia vs PowerPoint slide 3 | 1.7742% | 1.7742% | 1.7742% |
| WPF vs Avalonia slide 3 | 0.8043% | 1.1401% | 1.1401% |
| WPF slide 1 control | 1.5195% | 1.5195% | 1.5195% |
| WPF slide 2 control | 0.6895% | 0.6895% | 0.6895% |

Both candidates were rejected. Exact-color agreement at an isolated raster
sample was insufficient: the filled and shifted lines increased the full
affected-slide error and widened the cross-host difference. The product
changes and test-only guards were reverted.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 198/198.
- Presentation focused build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 3/3 slides exported successfully for each
  candidate comparison.

Process rule: distinguish source stroke color, host anti-aliasing, and chart
geometry before changing raster ownership; a raw one-pixel color match is not
acceptance evidence without whole-page and cross-host gates.
