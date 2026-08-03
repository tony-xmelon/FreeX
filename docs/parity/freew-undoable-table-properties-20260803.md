# FreeW undoable Table Properties (2026-08-03)

## Gap

WPF and Avalonia exposed the same Table Properties dialog and applied the same shared value payload, but
both hosts mutated the table model directly. The operation could not be undone even though Microsoft Word
treats an accepted Table Properties dialog as one document edit.

## Change

- Added a host-neutral `ApplyTablePropertiesCommand` in `FreeW.App.Presentation`.
- WPF and Avalonia now execute that command through their existing document command buses.
- Undo snapshots every field the shared planner can mutate: table width/alignment/indent/wrapping,
  table margins and cell spacing, table formatting, row height/rule/break policy, the explicit column-width
  vector, and every cell width/alignment/margin value.
- The full width snapshot is required because a Column-tab width propagates across rows before the Cell-tab
  width can override the selected cell.
- Undo restores the exact pre-dialog state; redo reapplies the accepted payload as one edit.

## Verification

- Shared `TablePropertiesDialogPlannerTests`: 6/6 passed, including complete-footprint undo/redo.
- WPF `TablePropertiesDialogTests`: 3/3 passed with host-level undo/redo.
- Avalonia WPF-authority table-properties scenario: 1/1 passed with host-level undo/redo.
- Existing DOCX `TablePropertiesRoundTripTests`: 5/5 passed.
- `git diff --check`: passed.

This is functional and package parity work. It does not change table rendering or require Word COM.
