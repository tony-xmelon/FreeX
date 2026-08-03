# FreeW WPF Undoable Picture Layout

Date: 2026-08-04

## Scope

WPF Picture Format alignment and wrapping controls mutated the selected image or its containing
paragraph directly. The equivalent Avalonia controls already consumed the shared command layer.

WPF now uses:

- `SetParagraphFormattingCommand` for image paragraph alignment.
- `SetFloatingWrapCommand` for the selected image's Word-style wrapping mode.

Both routes retain their previous values for undo and redo. The change is limited to command
ownership; paragraph layout, floating-object geometry, and DOCX serialization are unchanged.

## Verification

- WPF `InsertContextBehaviorTests`: 4/4 passed against the real ribbon registry, including image
  alignment and wrapping apply, undo, and redo.
- Focused Avalonia `PictureDrawingContextualTabTests`: 2/2 passed as the existing shared-command
  host control.

No Word COM visual baseline is required for this functional command-routing slice.
