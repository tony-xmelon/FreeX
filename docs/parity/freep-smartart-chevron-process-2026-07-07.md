# FreeP SmartArt Chevron Process Live Layout Evidence - 2026-07-07

This slice admits PowerPoint `chevronProcess` diagrams into the bounded FreeP
SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `chevronProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume ordinary shared slide shape and connector draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`chevronProcess` is represented by the existing shared process-family planner:
ordered stage text becomes left-to-right rounded boxes with connector ops. This is
credible for live shared layout and host parity, but it does not claim exact
PowerPoint chevron polygon geometry. Unsupported process-family variants still
fall back to cached drawing until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` proves `chevronProcess` produces live process boxes and
  connectors, and that cached drawing is bypassed only for the supported layout.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `chevronProcess`, keeps another process sibling on cached fallback, and emits
  shared connector draw ops consumed by both hosts.
