# FreeP chart gapDepth retention - 2026-07-13

## Scope

This slice preserves PowerPoint-authored `c:gapDepth/@val` metadata for bar and column chart families through the FreeP chart model and PPTX reader/writer path.

## Implementation

- `ChartShape.BarGapDepthPercent` stores the nullable modeled value next to `BarGapWidthPercent` and `BarOverlapPercent`.
- `PptxChartReader` reads `c:gapDepth/@val` from `barChart` and `bar3DChart` groups and clamps it to the same conservative `0..500` range used for bar gap width metadata.
- `PptxChartWriter` emits a `c:bar3DChart` group when modeled `c:gapDepth` exists, placing `c:gapDepth` after `c:gapWidth` and before chart axis ids. Normal 2-D `c:barChart` gap-width/overlap output remains unchanged.
- `SlideCloner` carries the metadata through slide duplication and undo snapshots.
- `ChartRenderPlanner` now exposes the authored metadata through a renderer-neutral `ChartBarDepthPlan` on planned bar/column rectangle primitives. When `BarGapDepthPercent` is present, the shared planner clamps it to `0..500`, derives a bounded diagonal depth offset from the category band, applies that offset to the planned primitive bounds, and tags the primitive with the gap-depth/orientation/stacking contract.
- WPF and Avalonia both continue to draw chart bar/column rectangles from `ChartRenderPlanner.BuildColumnPrimitives` / `BuildBarPrimitives` and `primitive.Bounds`, so the same modeled gap-depth plan is consumed by both renderers without duplicating depth math in either canvas.
- Focused tests cover default model state, clone retention, generated package/model round-trip, imported `bar3DChart` clamp behavior, shared gap-depth render-plan clamping, bar/column offset semantics, and WPF/Avalonia renderer-neutral primitive consumption.

## Limits

This remains a no-COM slice. The render improvement is a bounded shared 2-D depth-offset plan for authored 3-D bar/column gap depth metadata; it does not claim full PowerPoint 3-D scene, lighting, perspective, wall/floor, or camera parity.
