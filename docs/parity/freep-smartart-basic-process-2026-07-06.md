# FreeP SmartArt Basic Process - 2026-07-06

## Scope

This slice admits PowerPoint `basicProcess` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Process`; this change keeps that
classification and enables the existing shared process planner for the common
basic-process variant. Unsupported process-family variants remain disabled for
live planning and continue to use cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `basicProcess` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing process layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw ops.

## Evidence

- `SmartArtLayoutTests` proves `basicProcess` produces live boxes and
  connectors, prefers live layout over cached fallback, and keeps unsupported
  process variants on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for `basicProcess`
  while disabling an unsupported process variant, and that composed PPTX input
  emits shared live shape ops.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, authoring and
editing workflows, and PowerPoint-authoritative visual baselines remain deferred.
