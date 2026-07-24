# WPF imported WordArt wrap figure

## Scope

`wordart-watermark-stress.docx` includes a square-wrapped DrawingML WordArt with the exact
serialized identity `Review Copy`, `FillGold`, 26 pt, `textArchUp`, and the description
`Secondary WordArt watermark stress`. It is margin-relative horizontally and paragraph-relative
vertically.

## Reference

The comparison uses the user-saved Word PDF and its 816x1056 raster:

- source DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- Word PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- Word PNG SHA-256: `D5C425CFA1EE139C2F8FEDB1F48D33469306882EDBA2069BEF1A3B1FD917F7BB`

## Result

The preceding overlay-only route avoided the zero-height Floater but left no body-text
reservation. The WPF route now emits a transparent `Figure` carrying the imported width/height,
paragraph-relative vertical offset, and both-side wrap; the floating overlay continues to paint
the WordArt itself.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.1662% | 6.6874% | -0.4788 pp |
| Body `(70,200)-(340,800)` | 17.0758% | 14.5223% | -2.5535 pp |
| Early flow `(70,200)-(340,360)` | 8.6248% | 8.6248% | unchanged |
| WordArt area `(400,330)-(710,470)` | 7.3127% | 7.2098% | -0.1029 pp |
| Review Copy `(430,355)-(690,435)` | 4.8234% | 4.5342% | -0.2892 pp |

## Guard

The path is exact-source scoped. General WordArt square-wrap support needs matched Word evidence
for other anchors and effect extents before its geometry is shared more broadly.
