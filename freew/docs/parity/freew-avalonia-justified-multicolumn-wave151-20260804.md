# FreeW Avalonia justified multi-column layout parity

Wave 151 closes the remaining Avalonia gap for `PageVerticalAlignment.Justified` in Print Layout when a page has multiple columns.

## Behavior

- Unused body height is measured per physical page, including the existing footnote reservation.
- Body-block boundaries are ordered by the existing column flow: left-to-right column, then top-to-bottom within that column.
- A block that continues into another column or page contributes only its earliest occurrence on each page, so justification does not insert a gap inside a wrapped block.
- The resolved cumulative offset is applied to glyphs, sentinels, paragraph/table decorations, inline images, floating objects, wrap exclusions, shape-text caret stops, table hit rectangles, caret lookup, selection painting, and hit testing.
- Floating geometry is keyed by its owning paragraph/block flow start, never by the floating rectangle's X coordinate. One owner offset is propagated through a complete group tree, its snapshots, wrap exclusions, selection rectangles, and caret rotation centers.
- Image-only blocks retain their owning block index and therefore participate in the same boundary order even when they emit no text glyph.
- Web Layout and Draft remain continuous single-column flows and do not apply page vertical alignment.

## Evidence

- `PageVerticalAlignmentPlanner` now owns the column-order body-start ordering policy.
- `PageVerticalAlignmentPlannerTests` covers column reading order and continuation de-duplication.
- `PageVerticalAlignmentTests` covers a paragraph spanning columns, a following image-only block, glyph hit testing, and caret geometry.
- `PageVerticalAlignmentTests` also covers both cross-column floating-anchor directions: a column-1 anchor positioned in column 2 and a column-2 anchor positioned back in column 1, including nested child, snapshot, wrap, and selection geometry.

## Boundary

The current FreeW document model carries one `PageSettings` value for the document flow. Per-section vertical-alignment boundaries cannot be represented until section-level page settings are modeled by the Avalonia layout pipeline.
