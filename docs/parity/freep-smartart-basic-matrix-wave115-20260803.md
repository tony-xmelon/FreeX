# FreeP Wave 115: SmartArt Basic Matrix

## Scope

Basic Matrix now has a dedicated shared live-layout plan. It is not an alias
of Grid Matrix: Basic Matrix expresses four components as quadrants belonging
to one whole, while Grid Matrix emphasizes placement along two axes. The
implementation admits `basicMatrix` only; no `matrix1` fixture or package
evidence was found, so that sibling remains on cached fallback.

## Shared behavior

- The planner selects the first four model top-level nodes (`Level == 0`) in
  parsed display order. This is the model's zero-based representation of
  PowerPoint Level 1.
- The plan emits a neutral, textless `SmartArt_BasicMatrix_Whole` diamond
  first, followed by up to four rounded quadrants in stable row-major order:
  `TopLeft`, `TopRight`, `BottomLeft`, `BottomRight`.
- Later Level-1 nodes and all Level-2 nodes stay in the shared editable model
  and data part, but are intentionally omitted from this four-idea layout.
- No connector operations are emitted. WPF and Avalonia consume the same
  shared `SlideShape` plan through the existing compositor.
- Cache regeneration writes the same five-shape-or-fewer plan to
  `dsp:drawing`, while the data part continues to preserve all editable nodes.

## Evidence

Focused presentation, WPF host/package, and Avalonia headless tests cover
geometry, node selection, names/order, no-connector policy, cache regeneration,
PPTX save/reopen, and shared host consumption. Microsoft documents Basic Matrix
as a four-quadrant relationship of components to a whole and publishes a Basic
Matrix preview with a central whole marker; the whole diamond is the
renderer-neutral approximation of that native whole role. The [Microsoft
SmartArt graphics description](https://support.microsoft.com/en-us/office/graphics-visuals/all-smartart-graphics-described)
is the semantic reference, and the generated-package test proves that the
whole is serialized as an actual `diamond` preset rather than inferred by a
renderer-only alias. No native PowerPoint Basic Matrix package or
PowerPoint-authoritative pixel baseline is present in the current corpus, so
exact native diamond metrics are not claimed.

## Residual limitations

PowerPoint-authoritative geometry/effects, richer matrix siblings, exact theme
style fidelity, and broader SmartArt authoring/editing remain deferred.
