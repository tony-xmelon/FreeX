# Flow Table Cell Spacing

## Scope

`table-layout-complex.docx` carries a 2.4pt table cell spacing value. The WPF
table renderer represented that value as vertical cell padding only for tables
that had been split into pagination segments. A normal single-page table
discarded the serialized spacing and rendered rows too compactly.

The WPF host now applies the existing vertical-only cell-spacing representation
to every table. It deliberately leaves `Table.CellSpacing` at zero so WPF does
not expand fixed column widths horizontally.

## Matching Word Evidence

The persistent Word COM target and fresh Release WPF candidate are 816 x 1056.

| Fixture | Measurement | Before | After |
| --- | --- | ---: | ---: |
| `table-layout-complex` | Whole page | 3.9860% | 3.4556% |
| `table-pagination-repeat-header` p1 | Whole page | 4.5222% | 4.5222% |
| `table-pagination-repeat-header` p2 | Whole page | 3.6768% | 3.6768% |
| `table-page-composition-stress` p1 | Whole page | 7.1167% | 7.1167% |
| `table-page-composition-stress` p2 | Whole page | 9.1889% | 9.1889% |
| `table-page-composition-stress` p3 | Whole page | 7.0188% | 7.0188% |

The repeat-header and all page-composition control PNGs are candidate-vs-baseline
SHA-256 stable. This keeps the existing pagination-segment behavior unchanged.

## Verification

- Focused `DocumentViewRoundTripTests` passed 2/2 compiled.
- The no-build rerun passes the same two tests.
- `FreeW.FidelityRender` Release build completed with 0 warnings and 0 errors.
- Fresh composite renders used the rebuilt FidelityRender artifact and the
  persistent matching Word PNG cache; no competing Word COM export was started.
