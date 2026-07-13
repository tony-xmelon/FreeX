# FreeP SmartArt Bending Process Live Layout Evidence - 2026-07-13

This slice admits PowerPoint `bendingProcess` diagrams into the bounded FreeP
SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `bendingProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume ordinary shared slide shape and connector draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`bendingProcess` is represented by the existing shared process-family planner:
ordered stage text becomes left-to-right rounded boxes with connector ops. This
improves shared live-layout coverage for a common process variant, but it does
not claim exact PowerPoint bending/turning geometry, polygon contours, overlap,
or spacing.

Other unsupported process-family siblings, such as `alternatingProcess`, still
fall back to cached drawing until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` proves `bendingProcess` produces live process boxes and
  connectors, and that cached drawing is still used for an unsupported process
  sibling.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `bendingProcess` and emits shared connector draw ops consumed by both hosts.
- PowerPoint COM visual-baseline capture remains unavailable on this machine, so
  this note records deterministic no-COM model/import/compositor evidence rather
  than a PowerPoint-authored pixel baseline.
