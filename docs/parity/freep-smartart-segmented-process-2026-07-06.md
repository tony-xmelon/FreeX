# FreeP SmartArt Segmented Process - 2026-07-06

## Scope

This slice admits PowerPoint `segmentedProcess` diagrams into the bounded FreeP
SmartArt live-layout allow-list.

The reader already classifies the layout as `Process`; this change keeps that
classification and enables the existing shared process planner for ordered-stage
segmented-process diagrams. Chevron-style and other process-family variants
remain disabled for live planning and continue to use cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `segmentedProcess` as live-layout supported.
- `SmartArtLayoutEngine` emits ordinary shared rounded-rectangle boxes and line
  connectors through the existing process layout path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw ops.

## Evidence

- `SmartArtLayoutTests` proves `segmentedProcess` produces live boxes and
  connectors, prefers live layout over cached fallback, and keeps an unsupported
  process sibling on cached drawing.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `segmentedProcess` while disabling an unsupported process variant, and that
  composed PPTX input emits shared live shape/connector ops.

## Residual Limitations

This is not full SmartArt parity. The shared process planner approximates
segmented-process diagrams as ordered boxes with connectors; exact PowerPoint
segment/chevron geometry, broader SmartArt layouts, authoring/editing workflows,
and PowerPoint-authoritative visual baselines remain deferred.
