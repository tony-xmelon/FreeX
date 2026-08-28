# FreeW Paged Caret Boundary Wave 196

Wave 196 closes the remaining inline-flow-break caret gap in the FreeW Avalonia editor. The production
surface is the live `DocumentView` in `PrintLayout`/Page Edit mode; the WPF authority is the same Word
behavior represented by the WPF paged editor and print paginator: a caret immediately after an inline
page break belongs to the next page, while a caret immediately after an inline column break belongs to
the next column on the current page.

## Exact oracle

For a paragraph containing `Before` followed by a zero-width `w:br type="page"`, placing the caret at
model text offset 6 must report zero-based `CaretPageIndex == 1` and expose non-zero caret geometry.
For the same paragraph with `w:br type="column"` and a two-column page, the caret at offset 6 must
report `CaretPageIndex == 0` and expose non-zero caret geometry in column 2.

## Before / after

Before this fix, the layout advanced past a trailing inline break but emitted no placed caret slot for
the empty post-break fragment. `CaretPageIndex` consequently fell back to page 0 and `CaretTop` was 0.
After this fix, Avalonia emits a zero-width sentinel at the post-break content boundary. Page breaks now
resolve to page 2 (one-based), column breaks remain on page 1 in the next column, and both positions have
usable caret geometry. The model text and zero-width break runs are unchanged.

Focused regressions: `DocumentViewHeadlessTests.TrailingInlineFlowBreak_PlacesCaretOnThePostBreakPageOrColumn` and `DocumentViewHeadlessTests.ConsecutiveTrailingInlineFlowBreaks_PlaceCaretAtTheFinalPostBreakBoundary`. These two source regressions cover both single and consecutive trailing-break boundaries (2/2 focused cases).
WPF source inspection confirms the matching break semantics are native paginator/page-boundary behavior;
the Avalonia sentinel makes its live caret geometry agree at the boundary where no following glyph exists.
