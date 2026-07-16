# FreeP imported style-2 Cartesian geometry

Date: 2026-07-16

## Scope

PowerPoint's COM export of `06-charts.pptx` uses a wider plot band for the
style-2 clustered column and line charts than the generic imported chart frame.
At the 960x540 planner coordinate used by the chart corpus tests, the matching
plot is `(70, 69, 775.4, 419)`.

FreeP applies this geometry only when the chart is an imported style-2 column
or line chart with Office text metrics, no combo secondary axis, and no visible
data labels. The data-label case in `19-chart-labels.pptx` and the imported
combo chart remain on their established layout paths.

## COM comparison

At 1280x720, the deck 06 comparison improved as follows:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 1 | 2.3378% | 1.0142% |
| Avalonia vs PowerPoint slide 1 | 2.3854% | 1.0545% |
| Avalonia vs PowerPoint deck average | 1.6038% | 1.2599% |

The deck 19 control remained unchanged:

- slide 1: `1.6266%`;
- slide 2: `0.8095%`;
- slide 3: `2.3249%`.

Final comparison artifacts are in:

`artifacts/freep-chart06-geometry-scoped-final-20260716`

## Verification

Focused chart corpus and planner tests cover the two imported frame contracts,
the visible-data-label exclusion, and the existing axis-stroke expectations.
