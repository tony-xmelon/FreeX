# FreeP SmartArt Alternating Process Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `alternatingProcess` diagrams into FreeP's bounded
shared SmartArt live-layout path.

## Scope

- `PptxPackageReader` marks `alternatingProcess` as live-layout supported.
- `SmartArtLayoutEngine` places ordered stage nodes on alternating upper/lower
  process tracks with shared connector ops between adjacent stages.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic alternating-track geometry for parsed nodes,
not exact PowerPoint polygon contours, effects, or visual spacing. Unsupported
process-family siblings outside the bounded reader allow-list still use cached
`dsp:drawing` fallback until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers alternating upper/lower geometry, connector
  count, in-frame placement, and shared compositor output over cached fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `alternatingProcess` and that composed output uses shared live shape ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
