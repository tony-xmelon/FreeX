# FreeP SmartArt Funnel Process Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `funnelProcess` diagrams into FreeP's bounded
shared SmartArt live-layout path.

## Scope

- `PptxPackageReader` marks `funnelProcess` as live-layout supported.
- `SmartArtLayoutEngine` emits ordered stages as top-to-bottom trapezoid
  segments that narrow toward the bottom, plus centered connector ops between
  adjacent stages.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic funnel-stage placement for parsed nodes, not
exact PowerPoint funnel contours, overlap, bevels, effects, or authored pixel
spacing. Unsupported process-family siblings outside the bounded reader
allow-list still use cached `dsp:drawing` fallback until their geometry is
modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers funnel segment count, trapezoid shape kind,
  connector count, in-frame placement, top-to-bottom order, narrowing geometry,
  and live layout preference over cached drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `funnelProcess` and that composed output uses shared live shape ops.
- `MainWindowHeadlessTests` verifies the Avalonia host consumes the same shared
  live funnel segment and connector draw ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
