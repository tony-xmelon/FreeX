# FreeP imported combo plot baseline - 2026-07-16

## Scope

The imported column-plus-line chart in `19-chart-labels.pptx`, slide 3, was
placing its plot one pixel too high at the 1280x720 comparison size. PowerPoint
grid rows were at `94, 148, 202, ..., 633`; both FreeP renderers began at
`93, 147, 201, ..., 633`.

## Change

The imported combo plot now moves down by one layout unit and reduces its
height by the same amount, retaining the bottom edge. This aligns the major
gridlines, columns, secondary-axis line, and data labels as one plot system.

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 3 | 2.2654% | 2.0985% |
| Avalonia slide 3 | 2.2512% | 2.0889% |
| WPF deck average | 1.5563% | 1.5007% |
| Avalonia deck average | 0.6150% | 0.6093% |

The comparison used a fresh PowerPoint COM export at 1280x720. Slides 1 and 2
were unchanged.

## Verification

- `ChartBaselineCorpusTests` and `ChartRenderPlannerTests`: `183/183` passed.
- The RenderCompare WPF/Avalonia build completed with `0` warnings and `0`
  errors.
- The combo chart was rendered and compared against the PowerPoint COM export.
