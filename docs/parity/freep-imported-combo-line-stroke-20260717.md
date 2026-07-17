# FreeP imported combo line stroke

Date: 2026-07-17

## Scope

The imported clustered-column plus secondary-axis line chart in
`19-chart-labels.pptx`, slide 3, uses a PowerPoint three-point overlay line.

## Change

The shared planner now represents that imported overlay as a `4.0` DIP stroke.
At 96 DPI this preserves the authored three-point width while avoiding the
under-sized raster produced by the previous `3.0` DIP value.

## Fresh COM comparison

At `1280x720` against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF slide 3 | 1.8217% | 1.8167% |
| Avalonia slide 3 | 0.8578% | 0.8590% |

The WPF overlay's exact orange pixels moved from `1,491` to `2,170`, toward
PowerPoint's `2,486`, while slides 1 and 2 remained unchanged.

## Verification

- `193` focused chart planner/baseline tests passed.
- `FreeP.RenderCompare` built with `0` warnings and `0` errors.
- `git diff --check` passed.
