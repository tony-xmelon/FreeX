# FreeP SmartArt Closed Chevron Process Live Layout Evidence - 2026-07-13

This slice admits PowerPoint `closedChevronProcess` diagrams into the bounded
FreeP SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `closedChevronProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume the same shared Chevron slide-shape draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`closedChevronProcess` uses the same shared `Chevron` preset geometry as the
other two admitted variants. The checked-in corpus provides no authoritative
geometry that justifies a distinct closed overlap, so this slice intentionally
does not invent one. WPF and Avalonia consume the same shared shape plan without
renderer-local policy. Unsupported, malformed, or out-of-bound input still
falls back to cached drawing.

This does not claim exact PowerPoint closed-chevron metrics, effects, or
pixel-level spacing. A PowerPoint-authored visual baseline remains deferred
because COM capture is unavailable in this environment.

The shared planner uses the DrawingML 0..100000 `adj` scale and the 24% notch
already defined by the shared Chevron geometry builder. No distinct
basic/closed geometry is claimed without a PowerPoint-authored baseline.

## Evidence

- `SmartArtLayoutTests` proves `closedChevronProcess` produces live process
  boxes and connectors, and that cached drawing is bypassed only for admitted
  layouts.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `closedChevronProcess` and emits shared connector draw ops consumed by both
  hosts.
- PowerPoint COM visual-baseline capture remains unavailable on this machine, so
  this note records deterministic no-COM model/import/compositor evidence rather
  than a PowerPoint-authored pixel baseline.
