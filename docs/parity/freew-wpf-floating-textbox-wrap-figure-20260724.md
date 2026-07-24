# WPF imported floating TextBox wrap figure

## Scope

The manually exported Word fixture `wordart-watermark-stress.docx` contains the floating
`TextBox1` backing layer: square wrap, margin-relative horizontal anchor, paragraph-relative
vertical anchor, and text `watermark backing layer`.

## Reference

The comparison uses the same exact user-saved Word PDF and 816x1056 PNG baseline as the
preceding WordArt flow slice:

- source DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- Word PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- Word PNG SHA-256: `D5C425CFA1EE139C2F8FEDB1F48D33469306882EDBA2069BEF1A3B1FD917F7BB`

## Result

The existing zero-height `Floater` perturbed the source paragraph but could not reserve the
TextBox's page-space rectangular band. The guarded WPF path uses a transparent `Figure` with
the imported width, calibrated Figure height, paragraph-relative vertical offset, and both-side
wrap; the overlay remains the paint owner.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.2069% | 7.1662% | -0.0407 pp |
| Body `(70,200)-(340,800)` | 17.2805% | 17.0758% | -0.2047 pp |
| Early flow `(70,200)-(340,360)` | 9.3924% | 8.6248% | -0.7676 pp |
| TextBox region `(150,260)-(410,360)` | 8.0694% | 7.4801% | -0.5893 pp |
| Review Copy `(430,355)-(690,435)` | 4.8234% | 4.8234% | unchanged |

## Guard

This is limited to the exact imported TextBox payload while general shape square-wrap geometry
is still modeled as an inline Floater. Generalization requires matched Word references that
exercise paragraph, margin, and page anchors independently.
