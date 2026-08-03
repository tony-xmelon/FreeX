# FreeW Shared Undoable Index Entry

Date: 2026-08-04

## Scope

WPF References > Mark Entry appended directly to the document index side store, so the operation did
not participate in undo/redo. Avalonia had an equivalent host-local command.

Both hosts now consume one shared `AddIndexEntryCommand`. It trims through the existing `IndexEntry`
model, ignores blank and case-insensitive duplicate terms, and removes only its own added entry on
undo. Redo restores the entry at the end of the side store.

## Verification

- Focused shared `IndexEntryCommandTests`: 1/1 passed for apply, undo, redo, order, and duplicate
  suppression.
- Focused WPF `IndexEntryUndoParityTests`: 1/1 passed for Mark Entry, undo, redo, and duplicate
  suppression.
- Focused existing Avalonia References index workflow: 1/1 passed as the cross-host control.

No Word COM baseline is required because this slice changes only command ownership of existing index
metadata; DOCX serialization and generated-index rendering are unchanged.
