# FreeP SmartArt Basic Pyramid Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `basicPyramid` diagrams into FreeP's bounded
shared SmartArt live-layout path.

## Scope

- `PptxPackageReader` marks `basicPyramid` as live-layout supported while
  keeping it in the broad list-family SmartArt model.
- `SmartArtLayoutEngine` emits centered top-to-bottom pyramid segments that
  widen toward the base, using shared triangle/trapezoid autoshape geometry.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic segment placement for parsed nodes, not exact
PowerPoint merged contours, bevels, effects, 3-D depth, or authored pixel
spacing. Other pyramid/list-family siblings still use cached `dsp:drawing`
fallback until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers segment count, shape kinds, in-frame placement,
  widening geometry, no connector emission, and live layout preference over
  cached drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `basicPyramid` and that composed output uses shared live shape ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
