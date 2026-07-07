# FreeP SmartArt Vertical Bullet List - 2026-07-07

## Scope

This slice admits PowerPoint `verticalBulletList` diagrams into the bounded
FreeP SmartArt live-layout allow-list.

The reader already classifies the layout as `Hierarchy`; this change keeps that
classification and enables the existing shared hierarchy-family root/child box
and connector planner for a simple vertical-bullet-list tree. Other unsupported
hierarchy-family siblings remain disabled for live planning and continue to use
cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `verticalBulletList` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing hierarchy tree layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `verticalBulletList` produces live hierarchy
  boxes and connectors, prefers live layout over cached fallback, and keeps an
  unsupported hierarchy sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `verticalBulletList` while disabling an unsupported hierarchy-family sibling,
  and that composed PPTX input emits shared live shape ops.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, authoring and
editing workflows, PowerPoint-authored org-chart nuance, exact bullet styling,
and PowerPoint-authoritative visual baselines remain deferred.
