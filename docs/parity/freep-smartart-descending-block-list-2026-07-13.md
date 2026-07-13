# FreeP SmartArt Descending Block List - 2026-07-13

## Scope

This slice admits PowerPoint `descendingBlockList` diagrams into the bounded
FreeP SmartArt live-layout allow-list.

The reader already classifies the layout as `List`; this change keeps that
classification and enables the existing shared list-family planner for parsed
descending-block-list nodes. Other unsupported list siblings remain on cached
drawing fallback.

## Shared Behavior

- `PptxPackageReader` marks `descendingBlockList` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes through
  the existing list-family layout path.
- WPF and Avalonia consume the same shared compositor draw ops; no
  renderer-local SmartArt policy is introduced.

## Evidence

- `SmartArtLayoutTests` covers live list geometry, no connector emission, and
  live layout preference over cached drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `descendingBlockList` and that composed output uses shared live shape ops.

## Residual Limitations

The planner represents descending block SmartArt as renderer-neutral vertical
list boxes, not exact PowerPoint descending block sizing or depth effects.
PowerPoint-authoritative visual baselines remain deferred because local
PowerPoint COM is not available in this lane; richer list-family geometry and
SmartArt authoring/editing also remain deferred.
