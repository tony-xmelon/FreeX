# FreeP SmartArt Target List Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `targetList` diagrams into FreeP's bounded shared
SmartArt live-layout path.

## Scope

- `PptxPackageReader` classifies `targetList` as relationship-family SmartArt
  and marks only that layout ID as live-layout supported in this slice.
- `SmartArtLayoutEngine` emits one live concentric translucent ellipse per parsed
  node using shared renderer-neutral autoshape geometry; larger node sets no
  longer fall back solely because of node count.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic nested ellipse placement for parsed nodes, not
exact PowerPoint ring clipping, label offsets, effects, or ring-specific text
placement. Relationship siblings outside the explicit allow-list continue to use
cached `dsp:drawing` fallback until their geometry is modeled explicitly. The
target-list node-count gate is removed, but the geometry remains intentionally
renderer-neutral.

## Evidence

- `SmartArtLayoutTests` covers ellipse count and text preservation for six and
  twelve nodes, translucency, concentric shrinking geometry, and in-frame
  placement.
- `SmartArtTests` builds no-COM PPTX fixtures proving the reader admits
  `targetList` and composes all six shared live ellipse ops consumed by both hosts.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
