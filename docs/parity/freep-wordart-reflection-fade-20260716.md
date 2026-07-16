# FreeP WordArt Reflection Fade Parity

Date: 2026-07-16

## Change

WordArt text reflections now use a vertical opacity mask in both renderers.
The mirrored glyph remains at the authored reflection alpha near the source
text and fades to transparent across the reflected extent, matching the
PowerPoint `a:reflection` treatment more closely than a uniform-opacity copy.

## COM evidence

RenderCompare at 1280x720 with a fresh PowerPoint export of `13-wordart.pptx`:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint | 1.8866% | 1.7724% |
| WPF vs Avalonia | 1.8174% | 1.7121% |
| Avalonia vs PowerPoint | 1.7055% | 1.5077% |

The effects control `08-effects.pptx` also completed successfully after the
change: WPF vs PowerPoint `1.5290%`, WPF vs Avalonia `0.4487%`, and Avalonia
vs PowerPoint `1.4956%`.

## Verification

- `WordArtTests`: 28 passed.
- RenderCompare build: 0 warnings, 0 errors.
- COM-backed WordArt and effects renders completed successfully.
