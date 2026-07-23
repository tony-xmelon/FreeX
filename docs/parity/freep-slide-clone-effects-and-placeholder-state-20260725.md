# FreeP Slide Clone Effects and Placeholder State

## Scope

`SlideCloner.CloneShape` now preserves the serialized shape-level effect payload and
the explicit zero-extent transform marker. Effects are deep-cloned through the
existing presentation-model helper, so cloned shapes retain authored shadows/glows
and hidden placeholder semantics without sharing mutable effect state.

## Evidence

- Focused clone contract: `SlideCloner_CloneShape_PreservesShapeEffectsAndZeroExtentFlag`, 1/1 compiled and no-build.
- Existing clone contract family: 13/13.
- Release `FreeP.RenderCompare` build: 0 warnings, 0 errors.
- Fresh PowerPoint export for `14-smartart-live.pptx`: 4/4 slides.
- Matched current visual baseline for the effect-bearing SmartArt corpus remained stable:
  - WPF average: `1.0757%` mean RGB delta.
  - Avalonia average: `1.0817%` mean RGB delta.
  - Per-slide WPF: `1.3477%`, `1.2114%`, `0.4024%`, `1.3412%`.
  - Per-slide Avalonia: `1.1571%`, `1.0676%`, `0.2923%`, `1.8098%`.

The unchanged raster result is expected for the current corpus: the fix protects
clone-time model/function parity and does not alter already-rendered source shapes.
