# FreeP bullets autofit font-owner probes rejected - 2026-07-18

## Scope

Fresh current-main rendering of `17-bullets-autofit.pptx` shows the imported
eight-paragraph 18pt Aptos body on slide 2 has the same 29-pixel line cadence
as PowerPoint, but WPF glyph bands are taller. The slide-1 title remains the
control. Two bounded WPF-only probes tested whether the mismatch was owned by
the installed fallback font or by the text-formatting mode used to paint the
body:

1. Replaced the WPF Aptos fallback with installed Calibri for the exact body
   render path.
2. Kept Ideal metrics for layout and used Display metrics only when painting
   the exact body signature.

Both probes were reverted.

## Fresh matched COM evidence

| WPF metric | Current baseline | Calibri fallback | Display-only paint |
| --- | ---: | ---: | ---: |
| Slide 1 control | 1.0498% | 1.1324% | 1.0498% |
| Slide 2 whole page | 3.2245% | 4.2656% | 3.4401% |

PowerPoint exported both slides successfully for every comparison. Avalonia
was unchanged; its slide-2 comparison remained `3.1232%`, confirming these
were WPF-local probes.

## Conclusion

Neither an installed Calibri substitution nor a Display-only paint pass is a
valid parity fix. The raw bands show a glyph-shape/rasterization mismatch, not
a paragraph-flow or line-cadence error. Future work should inspect the exact
Office Aptos font provenance or a font-aware WPF raster path before changing
the shared text planner.

## Verification

- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors for each probe.
- Fresh PowerPoint COM export: 2/2 slides for each probe.
- Product source restored to the accepted baseline after scoring.
