# FreeP SmartArt Descending Block List Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `descendingBlockList` diagrams into FreeP's
bounded shared SmartArt live-layout path with variant-aware list geometry.

## Scope

- `PptxPackageReader` marks `descendingBlockList` as live-layout supported
  while keeping it in the broad list-family SmartArt model.
- `SmartArtLayoutEngine` emits top-to-bottom rounded-rectangle blocks that
  narrow toward the bottom with a shared right edge.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic descending-block placement for parsed nodes,
not exact PowerPoint spacing, effects, theme style nuance, or pixel baselines.
Other list-family siblings still use cached `dsp:drawing` fallback until their
geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers live layout admission, descending width
  geometry, right-edge alignment, in-frame placement, no connector emission,
  and live layout preference over cached drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `descendingBlockList` and that composed output uses shared live shape ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
