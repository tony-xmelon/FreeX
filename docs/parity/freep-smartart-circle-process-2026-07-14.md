# FreeP SmartArt Circle Process Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `circleProcess` diagrams into FreeP's bounded
shared SmartArt live-layout path.

## Scope

- `PptxPackageReader` marks `circleProcess` as live-layout supported while
  keeping it in the broad process-family SmartArt model.
- `SmartArtLayoutEngine` places ordered stage nodes clockwise around an ellipse
  and emits shared connector ops that close the process loop.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic circular placement for parsed nodes, not exact
PowerPoint circular-arrow artwork, segment contours, effects, 3-D depth, or
authored pixel spacing. Process-family siblings outside the bounded reader
allow-list still use cached `dsp:drawing` fallback until their geometry is
modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers circular stage placement, connector count,
  clockwise ordering, and shared compositor output over cached fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `circleProcess` and that composed output uses shared live shape ops.
- `MainWindowHeadlessTests` verifies the Avalonia host consumes the same shared
  live circle-process box and connector draw ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
