# FreeP Wave 144 SmartArt authored Basic Matrix depth

Date: 2026-08-04
Branch: `codex/avalonia-parity-wave144-freep-20260804`

## Selected layout

This slice fixes the authored `basicMatrix` SmartArt topology. The insertion
factory previously encoded every preset as one root node with child nodes. The
shared Basic Matrix planner, however, interprets its components as flat
top-level nodes so it can place them in the four quadrant roles around the
shared whole diamond. As a result, an authored Basic Matrix rendered only the
root component as a quadrant even though its native layout identity was
correct.

## Implementation and evidence

Basic Matrix authoring now emits sibling `dgm:pt` nodes with no `parOf`
connections, and the in-memory model uses matching level-zero nodes. The
existing shared `SmartArtLayoutEngine.LayoutBasicMatrix` and
`SmartArtEditingPlanner` regenerate the same live plan: one whole diamond plus
one rounded quadrant per authored component. A focused insertion test verifies
the live shape plan before and after `PptxPackageWriter`/`PptxPackageReader`
round-trip, including the native layout identity and flat editable model.

The WPF and Avalonia renderer contract tests confirm both thin hosts continue
to consume this shared plan through `SlideCompositor`; no host-local SmartArt
geometry was added.

## Boundary

This slice covers authored Basic Matrix topology and non-COM PPTX round-trip
semantics. It does not claim PowerPoint-pixel-identical matrix spacing, native
effects, richer imported cache grammars, or broader matrix-family import
admission. Existing cached-drawing fallback behavior remains authoritative for
unproven imported variants.
