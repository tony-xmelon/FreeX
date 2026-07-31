# FreeX Avalonia parity wave 83: header drag anchor retention

Date: 2026-07-31
Scope: FreeX only (`src/FreeX.App.Avalonia`, paired FreeX tests)

## Finding

WPF's header drag path stores the header index from pointer-down and passes that explicit anchor
to `ExtendHeaderSelection`. Avalonia stored the same `_headerSelectionDragAnchorIndex`, but its
continuation called the ordinary `SelectEntireRow/Column(..., extend: true)` path. That path uses
the session's active cell as its anchor. After a Shift-click header extension, the active cell is
the start of the already-expanded band, so dragging again could extend from the wrong edge.

## Change

Avalonia now has dedicated row/column header-drag continuation helpers that use the stored
pointer-down header index as the selection anchor. Formula point-mode range selection also receives
the explicit anchor and cursor, matching WPF's directional range semantics. Ordinary click, Shift
extension, and Ctrl-added header selection keep their existing entry points.

## Verification

Focused Avalonia coverage is `R84_MouseSelectionMultiAreaTests.HeaderDragAfterShiftClick_UsesPointerDownHeaderAsAnchor`.
The paired WPF source test is `MainWindowMouseSelectionSourceTests.HeaderDragRangeUsesPointerDownIndexAsExplicitAnchor`.

Nearby audit leads were not selected as this slice: Avalonia already honors
`EnableFillHandleAndCellDragAndDrop` in move, fill, and handle rendering; Custom Views' page-setup
and filter snapshot limitation is shared presentation/Core behavior; and the contextual Pivot/Chart
commands named by the clue have live Avalonia handlers rather than only inventory entries.
