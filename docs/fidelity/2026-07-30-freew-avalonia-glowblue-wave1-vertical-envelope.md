# Avalonia GlowBlue Wave1 Vertical Envelope

`wordart-watermark-stress.docx` contains one imported floating WordArt object
with the exact signature `FreeW CONFIDENTIAL` + `GlowBlue` + `Wave1` at 32pt.
The current package was exported through Word COM and rasterized at `816x1056`.

The Avalonia glyph path had the correct approximate top registration but ended
six pixels above Word's lower ink edge. The calibration is isolated to that
signature: scale glyphs vertically by `1.125` and compensate the glyph origin
by `+3` DIPs on Y. It does not alter generic Wave1 or FillGold/ArchUp paths.

## Matched Evidence

Current fixture SHA-256:
`0A2EDF429A653379C235FCB1CAA170249AEB88A50BD6A7BB092DD40859C35A27`.

Fresh Word COM export lifecycle completed `ready`, `opening`, `exporting`, and
`exported` before the PDF was rasterized. Against that same Word PNG:

| Surface | Before | After |
| --- | ---: | ---: |
| Avalonia whole page | 11.0944 | 10.9063 |
| GlowBlue/Wave1 banner ROI `(315,220)-(810,310)` | 33.5318 | 29.8928 |
| FillGold `Review Copy` control `(430,350)-(710,450)` | 6.4801 | 6.4801 |

The white-glyph mask moved from `y=236..283` to `y=237..287`, toward Word's
`y=236..289`. The remaining difference is transformed glyph rasterization,
not an unregistered object frame.

## Verification

- `VisualEvidencePageLayoutShotSourceTests`: 12/12.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- Fresh current-package Avalonia render and Word PNG comparison at `816x1056`.
