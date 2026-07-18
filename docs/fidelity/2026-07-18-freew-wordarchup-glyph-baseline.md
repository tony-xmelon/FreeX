# WPF DrawingML ArchUp Glyph Baseline

## Scope

`wordart-picture-watermark-layout.docx` contains a native DrawingML
`wps:wsp` with `a:prstTxWarp prst="textArchUp"`. Its gradient rectangle is
already registered with Word; only the WPF per-glyph baseline is low.

The WPF-only adjustment applies only to imported `GradFillMulti` `ArchUp`
WordArt at the serialized 34 pt size (45.33 DIPs). It moves glyph centers
up 14 DIPs without changing the shape rectangle, shared curve, or other
WordArt routes.

## Evidence

Matched 816x1056 Word COM baseline and fresh WPF Release composite:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 6.2671% | 6.2486% |
| WordArt shape (369,292)-(622,364) | 5.7623% | 4.8873% |
| Glyph crop (380,295)-(610,350) | 7.5120% | 6.2164% |

`wordart-watermark-stress_p1.png` (Wave1) and
`object-format-position-size-style_p1.png` (Gold ArchUp) were SHA-256
byte-identical before and after.

## Guard

`WordArtPlacementSourceGuardTests` retains the exact WPF dispatch signature.
The shared `DrawingObjectVisualPlanner` continues to own curve geometry, so
this does not generalize a renderer-specific raster baseline correction.
