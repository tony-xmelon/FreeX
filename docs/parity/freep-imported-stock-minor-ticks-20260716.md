# FreeP imported stock-chart minor ticks - 2026-07-16

## Scope

The imported stock chart in `22-chart-baseline-depth.pptx` exposes PowerPoint
minor ticks on both Cartesian axes. FreeP previously emitted only the three
category-center ticks and the ten two-unit value ticks. The imported stock
fallback now adds four category-boundary ticks and value-axis ticks at `0.4`
unit intervals between the major ticks.

## Evidence

PowerPoint COM reported a value-axis range of `0..18`, major unit `2`, minor
unit `0.4`, with both major and minor tick marks enabled. The exported slide
also shows the category-boundary marks between the three category centers.

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | 3.8661% | 3.8627% |
| Avalonia | 3.8085% | 3.8050% |

The comparison used the local PowerPoint COM export at 1280x720. The planner
test asserts seven category ticks and 46 value ticks for the imported corpus
chart.

## Verification

- `ChartBaselineCorpusTests` asserts the imported stock minor-tick geometry.
- WPF and Avalonia renders were compared against the PowerPoint COM export.
