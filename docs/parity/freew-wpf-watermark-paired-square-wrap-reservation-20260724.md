# WPF paired square-wrap reservation

## Scope

The imported `wordart-watermark-stress.docx` fixture has two paragraph-anchored,
square-wrapped objects in its opening paragraph:

- `TextBox1`, `watermark backing layer`, 170 by 58 pt, green fill and outline.
- `WordArt3`, `Review Copy`, `FillGold`, 26 pt, `textArchUp`.

The painted surfaces already registered against Word. The remaining WPF body-flow
error came from the two synthetic `Figure` exclusions ending one text line before
Word's page-space square-wrap band.

## Provenance

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- user-saved Word PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- rasterized 816x1056 Word PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`
- candidate: fresh Release `FreeW.FidelityRender` WPF composite render

## Result

Both exact source signatures now add an 18-DIP extension only to their WPF
Figure reservation height. Their painted overlays, shared model geometry, and
all nonmatching Figure paths remain unchanged.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 6.6272% | 5.1745% |
| Wrapped body `(70,200)-(340,820)` | 14.9658% | 10.3627% |
| TextBox-adjacent paragraph `(70,320)-(430,410)` | 10.0178% | 6.3077% |
| Following paragraph `(70,390)-(430,470)` | 15.9026% | 10.0214% |
| Lower body `(70,420)-(780,820)` | 11.9710% | 8.0672% |
| Review Copy control `(430,350)-(700,440)` | 4.3160% | 4.1009% |

A backing-TextBox-only extension was rejected despite improving the whole page
to 6.5372%: it moved the paired WordArt reservation and regressed its ROI from
4.3160% to 6.1230%. The two source-guarded reservations form one measured
paragraph-space band and must remain calibrated together.

## Verification

- `DocumentView_UsesAPageRelativeFigureForTheExactImportedReviewCopyWordArt`: pass.
- `DocumentView_UsesAPageRelativeFigureForTheImportedWatermarkBackingTextBox`: pass.
- Release `FreeW.FidelityRender` build: 0 warnings, 0 errors.

The broader visual-evidence source test suite has one known pre-existing failure
for the absent `thisPixW - 2 * ins` source string; it fails unchanged before this
slice and is not used as acceptance evidence.
