# FreeW Undoable Table Layout Commands

Date: 2026-08-04

## Scope

The Table Layout commands Distribute Rows, Distribute Columns, and AutoFit changed the document model
outside the undo/redo bus in both WPF and Avalonia.

Three shared commands now own those mutations:

- `DistributeTableRowsCommand` snapshots every row height and height rule.
- `DistributeTableColumnsCommand` snapshots the table grid and every cell width.
- `SetTableAutoFitCommand` snapshots AutoFit mode, preferred width, grid widths, and cell widths.

Both hosts execute the same commands and retain their existing rendering invalidation behavior. This
is a functional command-ownership change; layout calculations and DOCX serialization are unchanged.

## Verification

- Core `TableLayoutCommandTests`: 4/4 passed for apply, exact undo, and redo across all three
  operations.
- Core `TablePropertiesModelTests`: 6/6 passed as the unchanged layout-operation control.
- WPF `TableLayoutCommandParityTests`: 1/1 passed across all three caret-table routes.
- Avalonia `TableContextualTabTests.Table_layout_commands_are_undoable`: 1/1 passed across the same
  three routes and undo stack.

No Word COM visual baseline is required for this functional slice.
