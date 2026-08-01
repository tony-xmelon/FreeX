# FreeW Shadowed Squares page-border visual parity (2026-08-01)

## Scope

- Canonical source: `w:pgBorders` with `w:val="shadowedSquares"`, `w:sz="24"`,
  `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 57`, `WidthPt == 3`, and `SpacePt == 24`.
- The shared page-border art planner owns the same Word-calibrated 23-horizontal / 30-vertical
  cadence as Apples plus the exact navy/white square construction.

## Reference provenance

- Exact source DOCX SHA-256: `E1B4CD8146CE3453177B655C46060D52BE9D577471963CEA5E854CBBDD7201FD`.
- Microsoft Word PDF SHA-256: `282D3FE5E8F9B7C86C6DB93CAE1CCC63553B6E40B0E480E98552F946F68E9E05`.
- Poppler 96-DPI PNG SHA-256: `1F11465F5AD6C637EFFBFB1D14D262DF0B7C4F91EB21AC5A8AD752F0B42B4946`.
- Final FreeW PNG SHA-256: `856D3CC4E47662ED10D8F4D53F036302989166799D93F08EBEC0163D2759D095`.
- Reference and FreeW images are both 816 x 1056 pixels.
- Word COM opened the direct canonical package and completed short-path PDF export in 5.5 seconds.

## Measured result

Mean absolute RGB channel difference against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.0800% | 1.6678% | -3.4122 pp |
| Perimeter excluding interior | 10.8704% | 1.2164% | -9.6540 pp |
| Top edge | 12.3503% | 1.8155% | -10.5348 pp |
| Left edge | 12.2621% | 1.8834% | -10.3787 pp |
| Right edge | 20.9015% | 1.8536% | -19.0479 pp |
| Bottom edge | 20.8554% | 1.7874% | -19.0680 pp |
| Interior control | 1.9146% | 1.9146% | 0 changed pixels |

Word paints each motif as an exact `#000080` 28-DIP back square, a white 26-DIP face, and four
one-DIP navy rails outside that face. A centered host pen produced blended pixels and scored worse;
pixel-aligned filled rails are the accepted physical owner in WPF, Avalonia, software evidence, and
direct PDF.

## Verification and process rule

- Shared planner coverage verifies ArtId 57, size, count, cadence, corners, and unsupported fallback.
- WPF live view, print preview, FidelityRender, and software evidence consume the shared plan.
- Avalonia live view and direct PDF consume the same plan; direct PDF uses solid rectangles and does
  not emit the old full-page line-border fallback.
- Both consuming applications build Release with zero warnings and errors; focused page-border lanes
  pass in shared, WPF, and Avalonia test projects.

For geometric art with exact flat colors, sample one motif's physical layers before tuning the frame.
Replace centered antialiased strokes with explicit surface-owned rails only when all four edge ROIs and
the whole page improve and the interior remains pixel-stable. Exact-color area by itself is diagnostic,
not acceptance evidence.
