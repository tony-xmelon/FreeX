# FillGold Material Top-Band Registration

## Scope

The manually saved Word PDF for `wordart-watermark-stress.docx` is the
reference for the exact imported secondary WordArt signature:

- text: `Review Copy`
- style: `FillGold`
- warp: `ArchUp`
- font size: 34.67 DIPs (26 pt)

The existing WPF material layer had the correct bounds, but its gradient began
interpolating immediately. The Word raster holds the top `#C09000` gold band
for four device rows before the darker material ramp begins.

## Change

Only this material layer now uses its own vertical gradient with a repeated
`#C09000` stop at 8%. The shared FillGold plan, ArchUp glyph placement, and
all other WordArt paths are unchanged.

## Evidence

The 816x1056 reference was rasterized from the manually saved Word PDF
(`EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`).
Fresh WPF composite output from the rebuilt Release FidelityRender artifact:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.1957% | 4.1914% | -0.0043 pp |
| `Review Copy` `(430,360)-(690,430)` | 5.3146% | 5.1135% | -0.2011 pp |
| Material panel `(440,366)-(682,426)` | 6.5738% | 6.3217% | -0.2521 pp |
| Primary GlowBlue/Wave1 banner | 7.4621% | 7.4621% | unchanged |

The exact top-gold mask changes from one row at `y=368` to four rows at
`y=368..371`, matching the Word reference. The primary banner is pixel-stable.

## Verification

- `WordArtPlacementSourceGuardTests`: 1/1 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Candidate used the WPF composite route and the same 96-DPI PDFium Word
  reference as the baseline.

## Process Note

For a warped WordArt material residual, preserve the glyph and source geometry
when their placement is already proven. Measure the raw material bands first,
then adjust only the owning background layer under an exact source signature.
