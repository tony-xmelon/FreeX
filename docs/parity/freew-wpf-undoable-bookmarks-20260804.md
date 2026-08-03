# FreeW WPF Undoable Bookmarks

Date: 2026-08-04

## Scope

WPF bookmark insertion and deletion mutated paragraph bookmark metadata outside the document command
bus. WPF bookmark enumeration also read only the legacy primary-name projection, while the model and
Avalonia support multiple bookmark names on one paragraph.

Shared bookmark commands now snapshot complete bookmark-name lists for undo and redo. WPF routes add
and delete operations through those commands, and enumerates bookmark names through the shared
`Bookmarks.List` model helper. Sibling names and their order remain unchanged when the primary name is
replaced or one selected name is deleted.

## Verification

- Focused shared `BookmarkCommandTests`: 2/2 passed for set/delete apply, undo, redo, duplicate
  occurrences, sibling names, and exact order restoration.
- Focused WPF `BookmarkUndoParityTests`: 1/1 passed for caret insertion, deletion, enumeration, undo,
  and redo.
- Focused existing Avalonia bookmark controls: 2/2 passed as the cross-host control.

No Word COM baseline is required because this slice changes only editor command ownership and does
not change DOCX serialization or rendering.
