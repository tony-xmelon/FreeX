# FreeP SmartArt Basic Chevron Process Live Layout Evidence - 2026-07-13

This slice admits PowerPoint `basicChevronProcess` diagrams into the bounded
FreeP SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `basicChevronProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume ordinary shared slide shape and connector draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`basicChevronProcess` is represented by the existing shared process-family
planner: ordered stage text becomes left-to-right rounded boxes with connector
ops. This improves shared live-layout fidelity for a common process variant, but
it does not claim exact PowerPoint chevron polygon geometry or spacing.
Unsupported process-family siblings such as `closedChevronProcess` still fall
back to cached drawing until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` proves `basicChevronProcess` produces live process boxes
  and connectors, and that cached drawing is bypassed only for admitted layouts.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `basicChevronProcess` and emits shared connector draw ops consumed by both
  hosts.
- PowerPoint COM visual-baseline capture remains unavailable on this machine, so
  this note records deterministic no-COM model/import/compositor evidence rather
  than a PowerPoint-authored pixel baseline.
