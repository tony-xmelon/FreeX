# FreeW Primary Wave1 Outline-Geometry Probe Rejected

## Scope

The manual Microsoft Word PDF baseline for `wordart-watermark-stress.docx`
shows that the primary `FreeW CONFIDENTIAL` WordArt still differs materially
from FreeW. The exact DrawingML signature is `GlowBlue`, `textWave1`, and
32pt. FreeW's WPF renderer currently paints that signature as per-character
`TextBlock` elements on an imported flat baseline.

This probe replaced only the final foreground glyph layer with one
`FormattedText.BuildGeometry` WPF `Path` per character. The measured floating
frame, rectangular material/glow layers, shared placements, and every other
WordArt signature were left unchanged.

## Matched Evidence

The candidate and control both used a rebuilt Release `FreeW.FidelityRender`
artifact, the exact `wordart-watermark-stress.docx` input, WPF composite
rendering, and the same 816x1056 manual Word PDF raster.

| Region | Control mean RGB delta | Outline-geometry candidate | Change |
| --- | ---: | ---: | ---: |
| Whole page | 17.3305 | 17.3538 | +0.0232 |
| Primary panel `(315,220)-(805,310)` | 42.4224 | 42.8762 | +0.4538 |
| Primary glyph crop `(330,230)-(795,300)` | 43.8344 | 44.3942 | +0.5598 |
| `Review Copy` control `(430,365)-(690,435)` | 13.3871 | 13.3871 | stable |

Candidate-versus-control changed 3,082 pixels, all in the target banner;
the independent `Review Copy` crop changed zero pixels. The candidate was
therefore active and correctly isolated, but it regressed both target regions
and the whole page.

## Conclusion

Do not replace the exact primary Wave1 `TextBlock` raster with plain WPF glyph
outlines as a standalone calibration. The remaining gap is a DrawingML
text-envelope deformation and contour-effect composition model, not merely a
choice between text and `BuildGeometry` painting. Any future probe must model
the source `textWave1` geometry and its glyph-contour glow together, then gate
the primary panel, glyph crop, whole page, and independent WordArt controls.
