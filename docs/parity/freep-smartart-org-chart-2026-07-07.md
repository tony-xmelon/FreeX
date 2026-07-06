# FreeP SmartArt Org Chart - 2026-07-07

## Scope

This slice admits PowerPoint `orgChart` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Hierarchy`; this change keeps that
classification and enables the existing shared hierarchy-family tree box and
connector planner for parsed root/child organization charts. Other unsupported
hierarchy-family siblings remain disabled for live planning and continue to use
cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `orgChart` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing hierarchy tree layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `orgChart` produces live hierarchy boxes and
  connectors, prefers live layout over cached fallback, and keeps another
  hierarchy-family sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for `orgChart`
  while disabling another unsupported hierarchy-family sibling, and that
  composed PPTX input emits shared live shape ops.

## Residual Limitations

This is an approximation, not full PowerPoint org-chart parity. The shared
planner represents `orgChart` as a renderer-neutral hierarchy tree. Assistant
placement, assistant-specific connector routing, special org-chart branch
styling, authoring and editing workflows, and PowerPoint-authoritative visual
baselines remain deferred.
