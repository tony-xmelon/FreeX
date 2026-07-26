# Page Border DIP Conversion

## Reference

- Fixture: `wordart-watermark-stress.docx`
- Word PDF: `freew-fidelity-corpus/runs/current-chart-word-baseline-20260715/fixtures/f2/wordart-watermark-stress.pdf`
- Word PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- Raster: PDFium at 96 DPI, 816x1056
- Candidate: Release `FreeW.FidelityRender --composite`, same fixture and surface

## Change

`FreeW.FidelityRender` previously converted `PageBorder.WidthPt` to DIPs and then applied a second 96/72 multiplier. The compositor surface is already expressed in DIPs at 96 DPI, so this painted the frame too thick. The border now converts points to DIPs once.

## Result

| Region | Before | After |
| --- | ---: | ---: |
| Whole page RGB mean absolute delta | 4.4702% | 4.1957% |
| Page-border ROI `(20,20)-(796,1035)` | 4.8845% | 4.5841% |
| WordArt banner ROI `(310,215)-(810,310)` | 7.4890% | 7.4621% |
| Review Copy ROI `(430,360)-(690,430)` | 5.3146% | 5.3146% |

The exact `#1F4E79` page-frame mask kept the Word bounds `(32,32)-(783,1023)` and moved from 13,564 to 10,185 pixels, near Word's 10,428. This is a compositor-only change; documents without a page border do not enter the changed branch.
