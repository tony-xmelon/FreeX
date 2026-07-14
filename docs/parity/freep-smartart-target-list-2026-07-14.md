# FreeP SmartArt Target List Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `targetList` diagrams into FreeP's bounded shared
SmartArt live-layout path.

## Scope

- `PptxPackageReader` classifies `targetList` as relationship-family SmartArt
  and marks only that layout ID as live-layout supported in this slice.
- `SmartArtLayoutEngine` emits one to five parsed nodes as concentric
  translucent ellipse shapes using shared renderer-neutral autoshape geometry.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic nested ellipse placement for parsed nodes, not
exact PowerPoint ring clipping, label offsets, effects, or ring-specific text
placement. Relationship siblings outside the explicit allow-list, and
`targetList` diagrams with more than five parsed nodes, continue to use cached
`dsp:drawing` fallback until their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers ellipse count, text preservation,
  translucency, concentric shrinking geometry, in-frame placement, no connector
  emission, and bounded fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `targetList` and composes shared live ellipse ops consumed by both hosts.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
