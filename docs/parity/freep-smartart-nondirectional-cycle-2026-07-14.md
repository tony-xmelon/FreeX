# FreeP SmartArt Non-Directional Cycle - 2026-07-14

Scope: bounded FreeP SmartArt `nonDirectionalCycle` live-layout evidence. This
adds one cycle-family layout to the shared no-COM SmartArt path and does not
claim exact PowerPoint visual geometry or SmartArt authoring/editor parity.

## Coverage

- `PptxPackageReader` now admits `nonDirectionalCycle` in the bounded
  cycle-family SmartArt live-layout allow-list.
- `SmartArtLayoutEngine` reuses the shared cycle-family planner for parsed
  non-directional cycle nodes, emitting ordinary rounded-rectangle boxes and
  line connector `SlideShape` objects.
- WPF and Avalonia consume the same shared compositor draw operations; no
  renderer-local SmartArt policy is added.
- Cycle-family siblings still outside the allow-list, such as
  `continuousCycle`, remain on cached `dsp:drawing` fallback.

## Evidence

- `SmartArtLayoutTests` proves `nonDirectionalCycle` produces live circular
  boxes and connectors, and that the compositor prefers those shared live
  operations over cached fallback shapes.
- `SmartArtTests` proves the no-COM PPTX reader classifies
  `nonDirectionalCycle` as a cycle-family SmartArt and enables live layout,
  while another cycle-family sibling remains on cached fallback.

## Remaining Work

This is not full SmartArt parity. The non-directional cycle layout currently
uses the renderer-neutral shared cycle approximation, not exact PowerPoint
non-directional cycle segment placement, spacing, arrow treatment, or effects.
PowerPoint-authoritative visual baselines, richer cycle geometry, remaining
SmartArt layouts, and SmartArt authoring/editing workflows remain deferred.
