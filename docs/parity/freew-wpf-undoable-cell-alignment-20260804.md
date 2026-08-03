# FreeW WPF Undoable Cell Alignment

Date: 2026-08-04

## Scope

The WPF table-layout alignment gallery changed a cell's vertical alignment and every contained
paragraph's horizontal alignment directly. The equivalent Avalonia route already used the shared
`SetCellAlignmentCommand`, so WPF edits could not be undone or redone.

WPF now executes the shared command with the caret table, row, and cell coordinates. The command
retains each paragraph's complete prior `ParagraphFormatting` value as well as the prior vertical
alignment, preserving mixed paragraph settings exactly on undo.

## Verification

- Core `SetCellShadingBordersCommandTests`: 16/16 passed, including apply, exact
  mixed-paragraph undo, and redo.
- WPF `TableStyleGalleryTests`: 12/12 passed, including the caret-cell route, model mutation,
  undo, and redo.
- Avalonia `CellAlignmentTests`: 21/21 passed as the cross-host control.

This functional slice does not alter DOCX serialization or rendering geometry and therefore does not
require a Word COM visual baseline.
