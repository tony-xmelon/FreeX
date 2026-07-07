# FreeP SmartArt Radial Cycle - 2026-07-07

## Scope

This slice admits PowerPoint `radialCycle` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Cycle`; this change keeps that
classification and enables the existing shared cycle-family circular box and
connector planner for the common radial-cycle variant. Other unsupported
cycle-family siblings remain disabled for live planning and continue to use
cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `radialCycle` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing cycle layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `radialCycle` produces circular live boxes and
  connectors, prefers live layout over cached fallback, and keeps another
  unsupported cycle sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for `radialCycle`
  while disabling another unsupported cycle-family sibling, and that composed
  PPTX input emits shared live shape ops.

## Residual Limitations

This is not full SmartArt parity. The radial-cycle layout reuses the shared
cycle-family approximation; PowerPoint-authoritative radial-cycle pixel
baselines, richer SmartArt geometry, authoring and editing workflows remain
deferred.
