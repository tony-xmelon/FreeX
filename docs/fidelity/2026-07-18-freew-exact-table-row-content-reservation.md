# FreeW exact table-row content reservation

## Scope

Imported Word tables with `TableRowHeightRule.Exact` now reserve the measured
FlowDocument cell-chrome overhead from the inner content host. WPF adds that
chrome outside a `BlockUIContainer`; previously this made each exact Word row
grow beyond its authored height. `AtLeast` rows retain their existing behavior.

## Evidence

Fresh 816x528 Microsoft Word COM baselines were compared with current Release
WPF composites for `table-pagination-repeat-header.docx`:

| Page | Whole page | Table ROI `(60,90)-(755,455)` |
| --- | --- | --- |
| 1 | `5.1924% -> 4.6486%` | `7.9717% -> 7.0493%` |
| 2 | `4.5939% -> 3.7978%` | `6.9466% -> 5.3814%` |

The same current-main WPF artifact improved all three pages of the independent
exact-row composition-stress fixture (`table-page-composition-stress.docx`):

| Page | Whole page | Table ROI `(60,55)-(755,440)` |
| --- | --- | --- |
| 1 | `8.4124% -> 7.1167%` | `11.6843% -> 9.5974%` |
| 2 | `11.1179% -> 9.1889%` | `16.8849% -> 13.7622%` |
| 3 | `8.2834% -> 7.0188%` | `12.3089% -> 10.2832%` |

The complex-table control (`table-layout-complex.docx`) was rendered from a
fresh same-main baseline and candidate: its complete 816x1056 PNG was
byte-identical (`563A12F8...5151`) and its whole page / table ROI remained
`3.9860%` / `7.6642%`. The unrelated `f2-hf-images.docx` page-2 control was
also SHA-256 stable.

## Verification

- Focused exact/at-least row-height tests: `2/2` passed.
- `FreeW.FidelityRender` Release build: `0` warnings, `0` errors.

## Guard

Treat exact row height as a reservation for outer host chrome, not as an
instruction to change text layout. Score all affected pages plus a complex-table
control against a matching Word COM baseline; do not rely on stale artifacts
from pre-border or pre-layout paths.
