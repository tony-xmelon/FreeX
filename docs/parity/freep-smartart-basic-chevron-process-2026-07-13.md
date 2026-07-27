# FreeP SmartArt Basic Chevron Process Live Layout Evidence - 2026-07-13

This slice admits PowerPoint `basicChevronProcess` diagrams into the bounded
FreeP SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `basicChevronProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume the same shared Chevron slide-shape draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`basicChevronProcess` shares the bounded chevron-process planner with
`chevronProcess`: ordered stage text becomes left-to-right `Chevron` preset
shapes using the shared 24% notch and 76% interlocking step, with no
renderer-local connector policy.
Unsupported, malformed, or out-of-bound input still falls back to cached
drawing.

This improves the live geometry, but does not claim exact PowerPoint chevron
metrics, effects, or pixel-level spacing. A PowerPoint-authored visual baseline
remains deferred because COM capture is unavailable in this environment.

## Evidence

- `SmartArtLayoutTests` proves `basicChevronProcess` produces live process boxes
  and connectors, and that cached drawing is bypassed only for admitted layouts.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `basicChevronProcess` and emits shared connector draw ops consumed by both
  hosts.
- PowerPoint COM visual-baseline capture remains unavailable on this machine, so
  this note records deterministic no-COM model/import/compositor evidence rather
  than a PowerPoint-authored pixel baseline.
