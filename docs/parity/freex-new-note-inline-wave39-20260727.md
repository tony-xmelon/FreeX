# FreeX New Note Inline Workflow - Wave 39

Date: 2026-07-27

## Closure

WPF routes both Review **New Note** and **Edit Note** through the selected-cell worksheet
inline editor. FreeX Avalonia previously routed both commands through a modal text prompt.
Avalonia now uses a worksheet-anchored note editor built alongside its existing threaded-comment
editor, with the WPF-compatible yellow popup chrome and shared automation IDs:

- `WorksheetNoteInlineEditor`
- `GridNoteInlineTextBox`
- `GridCommentInlineSaveButton`
- `GridCommentInlineCancelButton`

The editor seeds the selected note when editing, commits through
`PresentationReviewSessionController.ApplyNote`, supports Ctrl+Enter to save and Escape to
cancel, restores worksheet focus after either lifecycle, and leaves the mutation undoable.
New Note, Edit Note, Shift+F2, and worksheet-context New/Edit Note routes all converge on this
production path.

## Verification

- Avalonia `AvaloniaReviewCommentInlineRuntimeTests`: **5/5 passed**, including note commit/undo,
  existing-note initialization, Escape cancellation, and the pre-existing threaded-comment
  inline regressions.
- WPF authority filters in `FreeX.App.Host.Tests`: **124/124 passed**, including
  `ReviewCommandSourceTests`, `ThreadedCommentDialogTests`, `ReviewProofingCommentsParityTests`,
  and `ShortcutParityBehaviorTests`.

## Residuals

- Pixel-level placement and styling still require paired foreground WPF/Avalonia capture review.
- The existing Avalonia modal threaded-comment editor remains available for its dedicated parity
  capture route; this Wave 39 change only closes the production New/Edit Note route.
