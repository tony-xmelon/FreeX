# FreeP SmartArt Basic Cycle - 2026-07-06

## Scope

This slice admits PowerPoint `basicCycle` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Cycle`; this change keeps that
classification and enables the existing shared cycle-family circular box and
connector planner for the common basic-cycle variant. Unsupported cycle-family
siblings remain disabled for live planning and continue to use cached drawing
fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `basicCycle` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing cycle layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `basicCycle` produces circular live boxes and
  connectors, prefers live layout over cached fallback, and keeps unsupported
  cycle siblings on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for `basicCycle`
  while disabling an unsupported cycle-family sibling, and that composed PPTX
  input emits shared live shape ops.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, authoring and
editing workflows, and PowerPoint-authoritative visual baselines remain deferred.
