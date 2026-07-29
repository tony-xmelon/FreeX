# Avalonia FillGold ArchUp Width Probe Rejected

## Scope

`wordart-watermark-stress.docx`, page 1, against the manually saved Microsoft Word PDF raster at 816x1056. The probe was restricted to the imported floating WordArt signature `Review Copy` + `FillGold` + `ArchUp` + 26pt.

## Probe

The current renderer uses a `-24,-19` DIP placement offset and a `0.64` fitted-width ratio. The Word glyph ink appeared wider in a raw crop, so the candidate moved only that signature 5 DIP right and increased its ratio to `0.69`.

## Result

The rebuilt `FreeW.PageLayoutShot` Release artifact rendered the same `wordart-watermark-stress` fixture without a new Word export. Candidate versus Word metrics regressed:

| Region | Accepted baseline | Candidate |
| --- | ---: | ---: |
| Whole page | 4.4915% | 4.5347% |
| Review Copy ROI (430,340)-(710,440) | 5.8868% | 6.2191% |
| Tight glyph ROI (455,360)-(650,415) | 5.0104% | 5.5894% |
| Independent GlowBlue banner ROI | 15.8725% | 15.8725% |

The candidate was reverted. The gold material surface remains on its existing exact signature path.

## Rule

Do not infer a WordArt ArchUp width correction from a raw ink bbox alone. For an exact transformed-text signature, require the targeted ROI and whole page to improve; preserve unrelated WordArt objects byte-stable.
