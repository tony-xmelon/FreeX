# Table Border Payload Retention

## Scope

Word keeps table-level borders in `w:tblPr/w:tblBorders`, with independent
outer and inside edges. FreeW previously reduced that element to one Boolean
used for WPF rendering, then emitted six generated `single/auto/0.5pt` edges
on save. That discarded an imported edge's line style, width, literal color
token, and whether another edge was absent.

The table model now carries an explicit `TableBorders` payload. DOCX read/write,
the WPF view tag, table splitting, document combine/merge/compare, and mail
merge preserve it. A literal Word `color="auto"` remains `auto`; it is not
converted to an assumed black renderer color.

This is package/edit fidelity only. The WPF table-border compositor still uses
its existing visual style path, so the previously observed Word raster gap is
not hidden by a broad color or thickness calibration.

## Package Evidence

The focused DOCX contract creates a table with only `top`, `left`, and
`insideH` edges. It asserts the written `word/document.xml` has exactly those
three elements and preserves `double`, `thick`, `dotted`, `12` eighth-points,
the explicit `1F4E79` RGB token, and literal `auto`. Reopening the package
reconstructs the same immutable model payload.

## Visual Control

Fresh Release composites against the persistent 816 x 528 Word COM baseline
for `table-pagination-repeat-header.docx` remained on the existing values:

| Page | Word delta |
| --- | ---: |
| 1 | 5.1924% |
| 2 | 4.5939% |

The slice does not alter WPF border paint ownership; those deltas are recorded
only as a no-visual-calibration control.

## Verification

- `TableStyleRoundTripTests`: 10/10 passed.
- `TablePropertiesModelTests`: 6/6 passed.
- `DocumentViewRoundTripTests.Table_ExplicitBorderPayload_SurvivesViewRoundTrip`:
  1/1 passed.
- `FreeW.FidelityRender` Release build completed with zero warnings and errors,
  then rendered both paginated-table pages.
