# FreeP SmartArt Basic Block List - 2026-07-06

## Scope

This slice admits PowerPoint `basicBlockList` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `List`; this change keeps that
classification and enables the existing shared list-family vertical box planner
for the specific common basic-block-list variant. Unsupported list-family
siblings remain disabled for live planning and continue to use cached drawing
fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `basicBlockList` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes through
  the existing list layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `basicBlockList` produces vertical live list
  boxes without connectors, prefers live layout over cached fallback, and keeps
  unsupported list siblings on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `basicBlockList` while disabling an unsupported list-family sibling.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, authoring and
editing workflows, and PowerPoint-authoritative visual baselines remain deferred.
