# FreeP Wave 113: SmartArt Segmented Process

## Scope

Wave 113 closes the admitted `segmentedProcess` SmartArt generic-geometry gap.
The reader allow-list and gallery admission are unchanged; this slice gives the
already-admitted process preset its own shared geometry.

## Shared implementation

- `SmartArtLayoutEngine` emits a vertical stack of broad editable rectangular
  segments in authored order.
- Each adjacent pair receives a centered downward relationship with a triangle
  end marker. Segment and relationship names are stable and encode their order.
- `SlideCompositor` remains the single live-layout route consumed by WPF and
  Avalonia, and the existing segmented-process gallery command still rewrites
  the native layout part through the shared authoring planner.
- `SmartArtEditingPlanner` regenerates the `dsp:drawing` cache from the same
  plan. The cache preserves ordered roles, text, and relationship markers.

## Verification

- `SmartArtLayoutTests` covers vertical bounds, rectangular segment roles,
  authored text order, stable relationship names, and arrow-end metadata.
- `SmartArtEditingPlannerTests` covers regenerated cache shape roles, XML shape
  count, cached text, and serialized relationship markers.
- `PptxRepairCorpusValidityTests` applies the layout to the live SmartArt
  corpus, regenerates the cache, writes and rereads PPTX, validates the package
  schema, and verifies the live layout ID and cached text.
- WPF and Avalonia host tests cover shared vertical composition; Avalonia also
  covers gallery command routing and native layout-part persistence.

## Remaining gaps

This is renderer-neutral editable geometry, not a PowerPoint-authoritative
pixel baseline. Exact segment contours, native effects, typography metrics, and
broader unsupported SmartArt layout variants remain deferred.
