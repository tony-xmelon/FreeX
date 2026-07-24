# WPF imported WordArt square-wrap flow

## Scope

Imported `wordart-watermark-stress.docx` contains a paragraph-anchored, square-wrapped
DrawingML WordArt object with the serialized payload `Review Copy`, `FillGold`, 26 pt,
`textArchUp`, and `wp:docPr/@descr="Secondary WordArt watermark stress"`.

## Reference and provenance

The Word reference is the user-saved PDF for the exact source document, rasterized at
816x1056:

- source DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- Word PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- Word PNG SHA-256: `D5C425CFA1EE139C2F8FEDB1F48D33469306882EDBA2069BEF1A3B1FD917F7BB`
- candidate: current Release `FreeW.FidelityRender`, WPF composite route

## Result

WPF previously placed a zero-height `Floater` in the owning paragraph. It moved WPF's
paragraph line box while failing to express Word's page-space square-wrap exclusion.
The exact imported signature now remains an overlay marker in the flow document; its
visual overlay still renders and owns the drawn WordArt.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.2506% | 7.2069% | -0.0437 pp |
| Body `(70,200)-(340,800)` | 17.5127% | 17.2805% | -0.2322 pp |
| Early flow `(70,200)-(340,360)` | 10.2633% | 9.3924% | -0.8709 pp |
| Primary Wave WordArt `(280,210)-(815,320)` | 12.9890% | 12.8279% | -0.1611 pp |
| Independent Review Copy `(430,355)-(690,435)` | 4.8234% | 4.8234% | unchanged |

## Guard

The condition is intentionally exact. Removing every complex square-wrap reservation
improved whole-page score only to 7.2266% while regressing the wider body and the Review
Copy crop. The page-space shape exclusion still needs a general model; do not generalize
this marker-only route without matched Word references for both flow and adjacent-object
regions.
