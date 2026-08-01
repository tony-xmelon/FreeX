# FreeW Apples page-border visual parity (2026-08-01)

## Scope

- Source signature: canonical WordprocessingML `w:pgBorders` with `w:val="apples"`,
  `w:sz="24"`, `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 1`, `WidthPt == 3`, and `SpacePt == 24`.
- Unsupported decorative art IDs intentionally retain the existing line-border fallback pending
  their own Word-calibrated visual slices.

## Reference provenance

- Exact source DOCX SHA-256: `16A27AD450B05BF72726C0E59F3CC31171B794A9192AF84B35DCB82BEF12C138`.
- Microsoft Word PDF SHA-256: `EFC881B8BFCF7E5F124B3BB6E6A0440E802941D9889D679629A5EBAB70543A2C`.
- Poppler 96-DPI PNG SHA-256: `55B0EBDC87985894B7D1C6AFE78AD7BAD226F826A233469EA5CF6230AAF5E558`.
- Final current-main FreeW PNG SHA-256: `F2E40666E701032136390E1449DBDBF241CF3DCA8C2B15BC1218CFBA491E9FC4`.
- Reference and FreeW images are both 816 x 1056 pixels.
- Word COM opened the already-authored short-path package and completed PDF export in about six
  seconds. Mutating the decorative border through the live Word object model was deliberately not
  used for evidence after that separate call stalled before saving.

## Measured result

Mean absolute RGB channel difference against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 8.5431% | 2.3778% | -6.1653 pp |
| Perimeter excluding interior | 21.0652% | 3.6215% | -17.4437 pp |
| Top edge | 34.3218% | 5.6997% | -28.6221 pp |
| Left edge | 30.9024% | 5.4843% | -25.4181 pp |
| Right edge | 32.2714% | 5.2371% | -27.0343 pp |
| Bottom edge | 31.6412% | 5.7426% | -25.8986 pp |
| Interior control | 1.6979% | 1.6979% | 0 changed pixels |

The current FreeW image changed from a plain black rectangle to the measured red apple motif. The
shared plan maps the art-border `w:sz` semantics to a 32-DIP motif, stretches 23 motifs across each
horizontal edge and 30 across each vertical edge, and avoids duplicated corner motifs.

## Ownership and verification

- `PageBorderArtVisualPlanner` owns motif size, cadence, placement, and palette.
- WPF live view, print preview, FidelityRender, and software evidence consume the shared plan.
- Avalonia live view and direct PDF export consume the same plan; the PDF contract emits 102 apples
  as 306 vector paths, retains a white center control, and emits no rectangular line fallback.
- Focused planner, WPF consumer, Avalonia live/PDF source, and raster contracts pass.
- Both Release consuming applications build with zero warnings and zero errors.

## Process rule

Decorative page-border art must be calibrated per canonical art token against a fresh, exact-package
Word raster. Keep cadence, palette, and size renderer-neutral; accept only with all edge ROIs and the
whole page improving while the interior control remains stable. A live Word object-model mutation
stall is not a reason to block the lane: author the canonical package directly and use Word only for
the final open/export operation.
