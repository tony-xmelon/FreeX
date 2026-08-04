# FreeP Wave 137 SmartArt process1 import depth

Date: 2026-08-04
Branch: `codex/avalonia-parity-wave137-freep-residual-20260804`

## Selected layout

This slice admits one strict imported `process1` cache grammar from the
deterministic `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`
fixture, slide 1. The package contains one five-node ordered data chain and an
interleaved cached drawing of five `roundRect` node boxes plus four empty line
connectors.

## Admission boundary

The reader promotes the cache only when the node tree is exactly one five-stage
chain, all node text is non-empty and distinct, cached node text is in data
order, all five node boxes and four line roles are in the expected order, and
the local EMU slots exactly match the shared `LayoutProcess` plan for the
8,229,600 x 5,744,800 EMU frame. Shape and drawing effects are rejected.

Changed geometry, reordered or mismatched text, extra roles, pictures, effects,
missing cache parts, and other process variants remain on the preserved cached
drawing path. Authoring-only `process1` data without a cached drawing keeps the
existing live layout behavior.

## Shared renderer evidence

The shared `SmartArtLayoutEngine` remains the geometry source and
`SlideCompositor` supplies the same node and connector operations to WPF and
Avalonia. Direct reader tests cover the positive corpus package and geometry,
order/text, effect, richer-role, and picture near-misses. Fixture XML and both
renderer source contracts cover the package and renderer-neutral boundaries.

The deterministic SmartArt corpus keeps its 10-slide shape count while extending
the existing process slide with its audited cached drawing. The generated FreeP
workflow inventory increases from 108 to 109 rows.

This is bounded WPF/Avalonia functional-depth evidence. It does not claim
PowerPoint pixel identity, exact Office text fitting, connector arrow styling,
effects, or broader imported process-family coverage.
