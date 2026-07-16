# FreeP imported clustered-bar geometry

Date: 2026-07-16

## Scope

PowerPoint's COM export of `06-charts.pptx` shows the imported style-2
clustered bar plot starting slightly farther left and higher, with a narrower
plot band than FreeP's prior frame. The calibration is limited to imported
bar charts using Office text metrics, so charts with data labels and other
chart families keep their existing layout paths.

The planner constants now apply a left offset of `-6.5`, upward offset of
`5.5`, and width reduction of `20.0` at the 960x540 planner coordinate used by
the chart corpus tests. The resulting bar plot is `(73.5, 14.5, 307.2, 220.25)`
for the corpus contract.

## COM comparison

At 1280x720, the deck 06 comparison improved as follows:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 4 | 1.5290% | 1.2926% |
| Avalonia vs PowerPoint slide 4 | 1.5365% | 1.3086% |
| Avalonia vs PowerPoint deck average | 1.2599% | 1.2030% |

The controls remained unchanged:

- `18-chart-types.pptx` average: `1.0513%`;
- `19-chart-labels.pptx` average: `1.5870%`.

Comparison artifacts are in:

`artifacts/freep-chart06-bar-candidate-20260716`

## Verification

The focused chart corpus and planner tests cover the imported bar frame and
axis range. The explicit RenderCompare project build and `git diff --check`
also pass on the parity branch.
