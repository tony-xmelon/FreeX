# FreeP Imported Scatter Axis Intervals

## Scope

PowerPoint COM parity for the imported scatter chart in `22-chart-baseline-depth.pptx`, slide 1 (`Scatter: smooth and straight series`).

## Finding

PowerPoint selects six intervals for the imported scatter X axis, producing labels `0, 20, 40, 60, 80, 100, 120`. FreeP's generic automatic range selected five intervals and rendered `0, 25, 50, 75, 100, 125`, shifting the X grid and point mapping away from the reference.

## Change

When imported chart text metrics are present, the scatter X-axis range now uses the six-interval PowerPoint heuristic. Other scatter ranges and authored axis bounds retain their existing behavior.

## Verification

- Focused chart tests: `181/181` passed.
- RenderCompare build: `0` warnings, `0` errors.
- WPF slide 1: `4.4396%` -> `4.4334%` mean channel diff.
- Avalonia slide 1: `4.4217%` -> `4.4125%` mean channel diff.
- Final renders and heatmaps: `artifacts/freep-scatter-axis-candidate-20260716/`.
