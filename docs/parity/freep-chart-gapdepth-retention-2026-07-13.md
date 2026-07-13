# FreeP chart gapDepth retention - 2026-07-13

## Scope

This slice preserves PowerPoint-authored `c:gapDepth/@val` metadata for bar and column chart families through the FreeP chart model and PPTX reader/writer path.

## Implementation

- `ChartShape.BarGapDepthPercent` stores the nullable modeled value next to `BarGapWidthPercent` and `BarOverlapPercent`.
- `PptxChartReader` reads `c:gapDepth/@val` from `barChart` and `bar3DChart` groups and clamps it to the same conservative `0..500` range used for bar gap width metadata.
- `PptxChartWriter` emits a `c:bar3DChart` group when modeled `c:gapDepth` exists, placing `c:gapDepth` after `c:gapWidth` and before chart axis ids. Normal 2-D `c:barChart` gap-width/overlap output remains unchanged.
- `SlideCloner` carries the metadata through slide duplication and undo snapshots.
- Focused tests cover default model state, clone retention, generated package/model round-trip, and imported `bar3DChart` clamp behavior.

## Limits

This is a no-COM metadata retention slice. It does not claim PowerPoint visual parity, 3-D bar/column rendering parity, or new chart rendering behavior.
