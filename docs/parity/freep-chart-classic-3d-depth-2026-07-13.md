# FreeP classic 3-D chart depth planning - 2026-07-13

## Scope

This slice preserves classic PowerPoint chart-type depth decisions for `pie3DChart`,
`line3DChart`, and `area3DChart` without adding renderer-specific policy.

## Implementation

- `ChartShape.ThreeDStyle` stores the authored classic 3-D chart group when the visible chart family still maps to FreeP's existing `Pie`, `Line`/`LineMarkers`, or `Area` model families.
- `PptxChartReader` imports `pie3DChart`, `line3DChart`, and `area3DChart` into the shared model, and `PptxChartWriter` emits those same chart-type elements when the modeled style is present.
- `ChartRenderPlanner` exposes a bounded renderer-neutral 3-D pie contract through `ChartPieSlicePrimitive`: a top-face vertical scale, Y radii, and depth metadata. WPF and Avalonia both consume the planned Y radii rather than duplicating pie-depth decisions.

## Limits

This is a bounded no-COM parity slice. It does not claim full PowerPoint 3-D scene, camera,
lighting, bevel, wall/floor, or side-wall extrusion fidelity; it preserves the chart-type
decision and gives shared renderers a deterministic first-depth contract for classic 3-D pie.
