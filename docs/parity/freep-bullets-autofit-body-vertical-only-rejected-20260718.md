# FreeP bullets autofit body vertical-only raster probe rejected - 2026-07-18

## Scope

The WPF `17-bullets-autofit.pptx` slide 2 body contains eight fixed 18pt
Aptos paragraphs in an `a:noAutofit` text box. A WPF-only probe applied a
0.86 vertical raster scale, with no translation, to that exact eight-line
signature. The existing horizontal Aptos fit and title calibration were
unchanged; Avalonia was untouched.

## Matched COM evidence

Fresh PowerPoint COM export and current Release render at 1280x720:

| Backend / ROI | Before | Candidate |
| --- | ---: | ---: |
| WPF slide 1 whole-page control | 1.0498% | 1.0498% |
| WPF slide 2 whole page | 3.2806% | 3.8637% |
| WPF two-slide average | 2.1652% | 2.4567% |
| Avalonia slide 2 vs PowerPoint | 3.1232% | 3.1232% |

The candidate was rejected because the isolated body raster adjustment
worsened the complete affected slide, despite the raw ink-band mismatch
looking like a glyph-height problem. The title/control slide remained stable,
confirming that the signature guard was isolated. The product change was
reverted; future work needs a layout-aware or font-raster explanation rather
than a draw-time vertical scale.

## Verification

- Focused compiling WPF renderer build: 0 warnings, 0 errors.
- `BulletsAutofitTests`: 47 passed, 0 failed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 2/2 slides exported successfully.
- Candidate and control renders used the rebuilt current Release artifact.
