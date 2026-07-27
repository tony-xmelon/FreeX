# FreeX Review New Comment Inline Workflow - Wave 38

Date: 2026-07-27

## Closure

WPF's Review New Comment route opens the selected-cell worksheet inline editor and submits through
the shared review-session mutation path. FreeX Avalonia now follows the same route for the normal
Review ribbon, Insert Comment, and worksheet context command: it opens an in-grid editor, validates
through `ThreadedCommentDialogPlanner`, and applies the result through
`PresentationReviewSessionController.ApplyThreadedComment`.

The existing Avalonia modal editor remains available for the parity-capture dialog route, so this
functional closure does not remove an existing capture surface.

## Verification

- WPF source authority is covered by `ReviewCommandSourceTests.NewThreadedComment_UsesSelectedCellInlineEditorAndSharedSubmitRoute`.
- Avalonia production behavior is covered by `AvaloniaReviewCommentInlineRuntimeTests`, including
  commit/undo and cancel behavior.

## Residuals

- New Note still uses the existing modal text prompt; this wave closes threaded New Comment.
- Pixel-level placement and styling of the inline editor still require paired foreground WPF and
  Avalonia capture review.
