# FreeP SmartArt Basic Venn Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `basicVenn` diagrams into FreeP's bounded shared
SmartArt live-layout path.

## Scope

- `PptxPackageReader` classifies Venn layouts as relationship-family SmartArt
  and marks `basicVenn` as live-layout supported.
- `SmartArtLayoutEngine` emits overlapping translucent ellipse shapes for two
  to four parsed nodes, using shared renderer-neutral autoshape geometry.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic overlapping ellipse placement for parsed
nodes, not exact PowerPoint blend math, intersection coloring, effects, or text
offsets. Relationship/Venn siblings outside `basicVenn`, and diagrams with
more than four parsed nodes, continue to use cached `dsp:drawing` fallback until
their geometry is modeled explicitly.

## Evidence

- `SmartArtLayoutTests` covers ellipse count, text preservation,
  translucency, overlap, in-frame placement, no connector emission, bounded
  fallback, and live layout preference over cached drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `basicVenn`, preserves unsupported relationship siblings as cached fallback,
  and composes shared live ellipse ops.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
