# FidelityRender Floating Image Effect Footprint

## Scope

Direct floating images were composited through a WPF `VisualBrush` with
`Stretch.Fill`. That includes the image's shadow, glow, reflection, and
artistic-effect footprint in the source visual, then scales the whole footprint
back into the authored rectangle. Word preserves the effect footprint outside
the image core.

## Change

Direct `InlineImage` overlays now use `Stretch.None`, matching the existing
direct-shape path. WordArt, charts, SmartArt, drawing groups, and other visual
roots retain `Stretch.Fill`.

## Matched Word Evidence

Fresh Release WPF renders at 816x1056 against the persisted Word COM PNG:

| Fixture / Region | Before | After |
| --- | ---: | ---: |
| `drawing-objects-complex` whole page | 7.1413% | 7.0861% |
| Direct image effect footprint `(296,240)-(464,429)` | 21.5243% | 20.0244% |
| Tight image core `(310,250)-(450,420)` | 20.3768% | 19.6607% |

`object-format-position-size-style` and `f2-01-float-wrap` controls were
byte-stable. The candidate changed only the direct floating image footprint in
the affected fixture.

## Verification

- `FidelityRender_DirectFloatingImagesPreserveTheirEffectFootprint`: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors

The wider `VisualEvidenceFidelityRenderSourceTests` class has one unrelated
current-main source-token failure: it expects the obsolete string
`thisPixW - 2 * ins`.
