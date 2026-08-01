# FreeX Threaded Comments Parity Wave 94

Date: 2026-08-01
Branch: `codex/agent-freex-comments-wave94-20260801`
Baseline: `origin/main` at `334d8f69c38bc0eec4ee75a5cb465576e90a088f`

## Selected gap

The WPF review workflow keeps an open modeless threaded-comment list current after comment
mutations. `MainWindow.ReviewCommands.cs` applies `RefreshOpenReviewCommentNoteWindows()` after
add, edit, reply edit/delete, resolve, and delete operations. Avalonia already had a modeless
review list and already marked comment panes dirty in `PresentationReviewRefreshPlan`, but
`MainWindow.ReviewSessionController.cs` only rebuilt the main shell. The open Avalonia list could
therefore continue showing old root text after an inline edit, and could retain deleted comments.

This is a functional workflow gap rather than a command-inventory or evidence-only difference.

## Implementation

Avalonia now consumes `RefreshCommentPanes` by invoking the existing list refresh callback with
the active sheet's current notes and threaded comments. The callback preserves the list window,
selection, and modeless lifecycle while replacing its rows with current data.

## Verification

- Headless Avalonia runtime regression: `OpenReviewCommentList_RefreshesAfterInlineCommentMutation`
  opens the production list, edits a threaded root through the inline editor, and verifies the
  same visible list instance changes from `Original root` to `Updated root`.
- Presentation controller coverage already proves threaded mutations produce a refresh plan with
  `RefreshCommentPanes = true`.

## Residuals

This slice covers live refresh of the existing Avalonia list. It does not change the separate WPF
and Avalonia list presentation differences, nor add reply-level rows or list-side edit/delete
commands; those remain follow-up parity work if required by the product workflow.
