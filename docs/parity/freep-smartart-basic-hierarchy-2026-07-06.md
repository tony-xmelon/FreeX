# FreeP SmartArt Basic Hierarchy - 2026-07-06

## Scope

This slice admits PowerPoint `basicHierarchy` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Hierarchy`; this change keeps that
classification and enables the existing shared hierarchy-family tree box and
connector planner for the common basic-hierarchy variant. Unsupported
hierarchy-family siblings remain disabled for live planning and continue to use
cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `basicHierarchy` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing hierarchy tree layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `basicHierarchy` produces live hierarchy boxes
  and connectors, prefers live layout over cached fallback, and keeps an
  unsupported hierarchy sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `basicHierarchy` while disabling an unsupported hierarchy-family sibling, and
  that composed PPTX input emits shared live shape ops.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, authoring and
editing workflows, PowerPoint-authored assistant/org-chart nuance, and
PowerPoint-authoritative visual baselines remain deferred.
