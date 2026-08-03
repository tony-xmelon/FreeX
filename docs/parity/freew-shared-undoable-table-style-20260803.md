# FreeW shared undoable table styles (2026-08-03)

## Gap

Avalonia applied catalog table styles through an undoable host-local command. WPF applied the same style
ID and border intent by mutating the model directly, so an accepted Table Styles gallery choice could not
be undone in WPF.

## Change

- Promoted `ApplyTableStyleCommand` to `FreeW.Core.Model` and removed the Avalonia-private duplicate.
- WPF now executes the shared command through its document command bus.
- The command changes only `TableStyleId` and the style's border intent. Header-row, banded-row, first/last
  column, and other `tblLook` formatting flags remain authoritative and restore exactly on undo.
- WPF live preview remains a separate temporary snapshot and is reverted before the committed command,
  matching the gallery's existing hover/click lifecycle.

## Verification

- Core `DocumentTableStyleTests`: 14/14 passed, including apply/undo/redo.
- WPF `TableStyleGalleryTests`: 10/10 passed with host-level undo/redo and rendered style controls.
- Avalonia `EffectsAndTableStyleCommands_MutateAndUndoRealDocumentState`: 1/1 passed.
- DOCX `TableStyleRoundTripTests`: 10/10 passed.
- `git diff --check`: passed.

This is functional and package parity work; it does not alter the table renderer or require Word COM.
