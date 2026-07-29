# Avalonia Imported ArchUp WordArt Registration

## Source And Owner

The serialized `wordart-picture-watermark-layout.docx` contains one in-front
WordArt object with the exact visual signature:

- `WordArtStyle.GradFillMulti`;
- `textArchUp` warp;
- 34 pt text;
- a three-stop orange, red, purple DrawingML gradient.

After the gradient-direction fix, Avalonia already matched Word's horizontal
glyph span, but raw ink registration showed its glyphs were low and too tall.
The calibration is therefore restricted to that exact imported owner path.

## Correction

Avalonia renders the matched ArchUp glyphs with a `-16 DIP` placement offset
and `0.74` vertical glyph scale. Other WordArt signatures retain the generic
renderer-neutral placement plan.

## Word Evidence

The reference is the same fresh 816x1056 Word COM PDF export used to score the
preceding Avalonia gradient-angle slice.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page mean channel delta | 23.2211 | 23.2047 |
| ArchUp WordArt ROI `(360,280)-(630,375)` | 21.4316 | 20.8813 |

The black glyph mask moved from `(393,305)-(599,345)` before registration to
`(394,292)-(597,326)`, against Word `(390,292)-(595,325)`.

## Controls And Verification

- `wordart-watermark-stress` Avalonia output is SHA-256 byte-identical.
- `field-page-number-variants` Avalonia outputs are SHA-256 byte-identical on
  all four pages.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 8 passed after rebuild and 8 passed
  with `--no-build`.
