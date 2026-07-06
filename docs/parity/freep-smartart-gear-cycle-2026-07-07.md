# FreeP SmartArt Gear Cycle - 2026-07-07

## Scope

This slice admits PowerPoint `gearCycle` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Cycle`; this change keeps that
classification and enables the existing shared cycle-family circular box and
connector planner for the common gear-cycle variant. Other unsupported
cycle-family siblings remain disabled for live planning and continue to use
cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `gearCycle` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing cycle layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.

## Evidence

- `SmartArtLayoutTests` proves `gearCycle` produces circular live boxes and
  connectors, prefers live layout over cached fallback, and keeps another
  unsupported cycle sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for `gearCycle`
  while disabling another unsupported cycle-family sibling, and that composed
  PPTX input emits shared live shape ops.

## Residual Limitations

This is an approximation, not true PowerPoint gear geometry. The shared planner
represents the diagram as renderer-neutral rounded boxes plus connector ops, not
interlocking gear-tooth shapes. PowerPoint-authoritative gear-cycle pixel
baselines, richer SmartArt geometry, authoring and editing workflows remain
deferred.
