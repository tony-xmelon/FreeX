# FreeP classic 3-D line and area depth planning - 2026-07-14

## Scope

This slice extends the existing classic 3-D chart work from preserved chart-type
metadata into shared render planning for `line3DChart` and `area3DChart`.

## Implementation

- `ChartRenderPlanner` now emits `ChartClassicThreeDDepthPlan` for classic 3-D
  line and area charts. The plan carries the renderer-neutral offset and alpha
  policy used for the rear depth pass.
- WPF and Avalonia slide canvases consume the same depth plan before drawing the
  existing foreground line or area geometry, avoiding platform-specific depth
  decisions.
- Focused planner tests cover the 3-D line and 3-D area contracts while keeping
  ordinary 2-D line charts free of depth metadata.

## Limits

This is a bounded no-COM parity slice. It does not claim PowerPoint-authoritative
3-D scene, camera, lighting, bevel, wall, floor, or perspective fidelity. It gives
both FreeP renderers the same first-depth visual contract for classic 3-D line and
area charts after the chart type has already been imported.
