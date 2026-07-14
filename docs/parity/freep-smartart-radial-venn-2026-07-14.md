# FreeP SmartArt Radial Venn Live Layout Evidence - 2026-07-14

This slice admits PowerPoint `radialVenn` diagrams into FreeP's bounded shared
SmartArt live-layout path.

## Scope

- `PptxPackageReader` classifies `radialVenn` as relationship-family SmartArt
  and marks that exact layout id as live-layout supported.
- `SmartArtLayoutEngine` emits three to five translucent ellipse shapes around
  a shared center, using shared renderer-neutral autoshape geometry.
- WPF and Avalonia consume ordinary shared compositor draw ops; no
  renderer-local SmartArt policy is added.

## Honesty Bound

The planner models deterministic radial ellipse placement for parsed nodes, not
exact PowerPoint intersection blending, effects, text offsets, or Venn-region
labeling. Relationship/Venn siblings outside `basicVenn`, `radialVenn`, and
`targetList`, plus `radialVenn` diagrams outside the three-to-five node bound,
continue to use cached `dsp:drawing` fallback until their geometry is modeled
explicitly.

## Evidence

- `SmartArtLayoutTests` covers radial ellipse count, text preservation,
  translucency, in-frame placement, radial center distribution, bounded
  fallback, no connector emission, and live layout preference over cached
  drawing fallback.
- `SmartArtTests` builds a no-COM PPTX fixture proving the reader admits
  `radialVenn`, keeps it in the relationship family, and composes shared live
  ellipse ops.
- `MainWindowHeadlessTests` proves the Avalonia host consumes the same shared
  radial Venn draw ops through the existing compositor path.
- PowerPoint COM visual-baseline capture was not run in this lane, so this note
  records deterministic no-COM model/import/compositor evidence rather than a
  PowerPoint-authored pixel baseline.
