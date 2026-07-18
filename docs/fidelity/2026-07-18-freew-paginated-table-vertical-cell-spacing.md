# Paginated Table Vertical Cell Spacing

## Scope

Imported fixed-width paginated tables cannot consume `Table.CellSpacing` directly
in WPF: it expands horizontal columns as well as vertical bands. The
`table-page-composition-stress.docx` payload has `w:tblCellSpacing` of 1.8
points, and Word advances each repeated body row by roughly four more pixels
than the WPF surface when that spacing is discarded.

For paginated table segments only, FreeW keeps `Table.CellSpacing` at zero to
preserve the fixed horizontal widths and reserves the authored spacing in the
top and bottom cell padding. Tables with no serialized cell spacing continue
to use the original two-DIP vertical padding.

## Matching Word COM Evidence

The persistent Word COM PNG corpus is 816 x 528 for this three-page fixture.

| Page / Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Page 1 whole | 8.4124% | 8.1638% | -0.2486 pp |
| Page 2 whole | 11.1179% | 11.1048% | -0.0131 pp |
| Page 2 table `(60,55)-(755,440)` | 16.8849% | 16.5301% | -0.3548 pp |
| Page 3 whole | 8.2834% | 8.2200% | -0.0634 pp |

The adjacent `table-pagination-repeat-header.docx` control has no
`w:tblCellSpacing`; its paginated cells retain two-DIP top padding in the
focused WPF contract.

## Verification

- `TablePageCompositionStress_RendersWordLikePhysicalSegments` and
  `TableRepeatHeader_RenderedRows_DoNotRoundTripIntoModel` pass compiled and
  with `--no-build`.
- `FreeW.FidelityRender` Release build completes with zero warnings and errors.
- The complete three-page target was rendered after the dependent artifact
  rebuild, with the two-page no-spacing control rendered alongside it.
