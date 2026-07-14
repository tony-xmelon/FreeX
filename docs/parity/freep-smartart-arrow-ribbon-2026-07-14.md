# FreeP SmartArt Arrow Ribbon Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `arrowRibbon` diagrams into FreeP's bounded
shared SmartArt live-layout path.

## Scope

- `PptxPackageReader` marks `arrowRibbon` as live-layout supported while
  keeping it in the broad process-family SmartArt model.
- `SmartArtLayoutEngine` emits ordered shared ribbon segment shapes plus
  connector ops between adjacent stages.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic left-to-right ribbon stages for parsed nodes,
not exact PowerPoint folded-ribbon contours, arrow tails, effects, 3-D depth, or
authored pixel spacing. Process-family siblings outside the bounded reader
allow-list still use cached `dsp:drawing` fallback until their geometry is
modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers ribbon segment geometry, connector count,
  left-to-right ordering, frame bounds, and shared compositor output over cached
  fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `arrowRibbon` and that composed output uses shared live shape ops.
- `MainWindowHeadlessTests` verifies the Avalonia host consumes the same shared
  live arrow-ribbon segment and connector draw ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
