# Avalonia parity Wave118: FreeP cycle2 effect boundary

## Selection

Wave118 follows Wave116's dedicated `hierarchy1` geometry and Wave117's bounded
`cycle2` import admission. The real repository package
`tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx` proves the positive
cycle2 contract: five ordered data nodes, five editable ellipse nodes, five
empty right-arrow transitions, and no authored effect payload in the drawing
cache.

The shared cycle2 planner emits the same renderer-neutral `SlideShape` grammar
for WPF and Avalonia, but it does not reproduce SmartArt node or transition
effects. Before this slice, a cache with the proven role/count/text shape set
could still enter that live path after the reader had parsed an effect.

## Implementation

Cycle2 import admission now rejects any fallback shape with a supported
`ShapeEffects` payload, including shadow, glow, soft edge, bevel, extrusion,
contour, and scene metadata. It also checks the preserved raw `dsp:drawing`
part for any non-empty DrawingML `a:effectLst`, covering effect subtypes the
bounded model does not yet parse. A malformed preserved drawing is conservatively
kept on the cached path.

The existing cached compositor remains authoritative for rejected imports. Its
parsed effects and raw SmartArt parts remain available to the WPF/Avalonia
consumers and the writer. The proven effect-free corpus continues to use the
existing live cycle2 geometry.

## Verification

- `FreeP.App.Host.Tests` SmartArt and package-reader source filter: 255 passed.
- Paired package regressions use the same otherwise admissible ellipse-and-arrow
  cache grammar. The effect-free package is admitted live; adding a DrawingML
  outer shadow rejects admission, preserves cached composition, and retains the
  effect through save/reopen.
- `FreeP.slnx` Release build completed with no warnings or errors.

## Limitations

This is an import-admission and data-preservation slice, not a claim of
PowerPoint-pixel-identical SmartArt effects or cycle2 geometry. Effect-bearing
cycle2 caches remain editable only through the existing cached/fallback
semantics until shared effect projection and matching PowerPoint evidence are
available. The raw-effect scan is intentionally conservative for richer or
future DrawingML effect payloads.
