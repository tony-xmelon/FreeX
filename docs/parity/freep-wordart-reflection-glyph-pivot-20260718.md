# FreeP WordArt Reflection Glyph Pivot

Date: 2026-07-17

## Change

The WPF WordArt reflection pass now pivots from the rendered glyph geometry
bounds instead of the full formatted-run bounds. PowerPoint begins the
reflection directly below the visible `ARCH UP TEXT` glyph block; using the
larger run box left the FreeP mirror visibly too low.

## COM evidence

RenderCompare at 1280x720 with a fresh PowerPoint export of
`13-wordart.pptx`:

| Metric | Before glyph pivot | After glyph pivot |
| --- | ---: | ---: |
| WPF vs PowerPoint | 1.7158% | 1.7121% |
| WPF vs Avalonia | 1.6553% | 1.6550% |
| Avalonia vs PowerPoint | 1.5077% | 1.5077% |

Pixel inspection of the reflection under the magenta `ARCH UP TEXT` panel
showed the first non-white reflection row moving from approximately `y=307`
to `y=288`, matching PowerPoint's start row. The remaining difference is the
fade profile below that start and is outside this geometry correction.

The `08-effects.pptx` control remained stable in the same fresh COM run:
WPF vs PowerPoint `1.5290%`, FreeP Avalonia vs PowerPoint `1.4956%`.

## Verification

- `WordArtTests`: 29 passed.
- RenderCompare build: 0 warnings, 0 errors.
- Fresh COM-backed WordArt and effects renders completed successfully.
