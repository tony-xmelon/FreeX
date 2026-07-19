# FreeP bullets autofit display-metrics probe rejected - 2026-07-18

## Scope

The imported eight-paragraph Aptos `a:noAutofit` body on
`17-bullets-autofit.pptx` slide 2 has taller WPF raw ink bands than
PowerPoint. A bounded WPF probe changed only that semantic body signature from
Ideal to Display text metrics for both measurement and painting. It did not
change the existing horizontal Aptos fit or the title/control slide.

## Matched COM evidence

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| WPF slide 2 whole page | 3.2806% | 3.3828% |
| WPF slide 1 control | 1.0498% | 1.0498% |
| Avalonia vs PowerPoint slide 2 | 3.1232% | 3.1232% |

The candidate was rejected and reverted. The raw height mismatch is not fixed
by swapping WPF text-formatting modes; the next probe needs a font-raster or
layout-aware explanation rather than a draw-time metric toggle.

## Verification

- Focused compiling `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 2/2 slides.

Process rule: an isolated text-band improvement hypothesis is insufficient
when the complete affected page worsens; retain the prior accepted path until
font substitution/raster provenance is proven.
