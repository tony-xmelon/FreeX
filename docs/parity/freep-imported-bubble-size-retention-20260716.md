# FreeP Imported Bubble Size Retention - 2026-07-16

## Scope

PowerPoint COM parity for the bubble chart in `18-chart-types.pptx`, slide 4.

## Finding

The chart part contains `c:xVal` and `c:yVal` data but no `c:bubbleSize`
element. PowerPoint keeps the chart axes and legend visible while rendering no
bubbles. FreeP previously synthesized a fallback radius for every point,
creating five visible bubbles that were absent from the PowerPoint baseline.

## Change

`ChartRenderPlanner.BuildBubblePrimitivePlan` now requires an authored bubble
size for a visible bubble primitive. Missing size data remains an empty bubble
series while the chart frame, axes, and legend continue to render.

## Evidence

Fresh `1280x720` PowerPoint COM comparison for `18-chart-types.pptx`:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 4 | `1.4018%` | `1.0824%` |
| Avalonia slide 4 | `0.2019%` | `0.1953%` |
| WPF deck average | `1.0696%` | `0.9897%` |
| Avalonia deck average | `0.2773%` | `0.2757%` |

The remaining imported bubble residual is legend/text layout, which is outside
this data-retention fix.

## Verification

- Focused presentation tests: `184/184` passed.
- RenderCompare build: `0` warnings, `0` errors.
- PowerPoint exported all `4/4` slides successfully.
