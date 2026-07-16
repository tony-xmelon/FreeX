# FreeP Imported Combo Axis Strokes

## Scope

PowerPoint COM parity for the imported combo chart in `19-chart-labels.pptx`, slide 3 (`column + line on a secondary axis`).

## Finding

PowerPoint renders the combo chart's major gridlines, primary-axis ticks, and secondary-axis ticks with the same dark gray `#898989` stroke. FreeP used black for the combo grid and ticks, which made the axis system visibly heavier than the PowerPoint baseline.

## Change

`ChartRenderPlanner` now uses `#898989` for imported combo gridlines and axis ticks while retaining the existing classic style and generic imported-chart defaults for other chart families. The corpus regression asserts the updated combo stroke plan and preserves the existing generic chart expectations.

## Verification

- Focused chart tests: `181/181` passed.
- RenderCompare build: `0` warnings, `0` errors.
- WPF slide 3: `2.5050%` -> `2.2671%` mean channel diff.
- Avalonia slide 3: `2.5649%` -> `2.3570%` mean channel diff.
- Final renders and heatmaps: `artifacts/freep-chart-stroke-final-20260716/`.
