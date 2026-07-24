# FreeP comment mention picker parity slice

## Scope

The review planner already discovered mention candidates and normalized insertion text, but both host panes inserted only the first candidate. This slice exposes the full candidate set through a native picker in WPF and Avalonia.

## Behavior

- A single candidate keeps the existing one-click insertion behavior.
- Multiple candidates show a host-native menu labeled with each `@mention` token.
- Choosing a menu item routes through `PresentationReviewWorkflowPlanner.BuildCommentMentionInsertionPlan` and the existing comment mutation path.
- WPF and Avalonia use the same candidate ordering, query filtering, and insertion semantics.
- The test-only default action still selects the first candidate so existing automation remains deterministic.

## Evidence

- WPF `ReviewWorkflowAdapterTests` covers non-default candidate selection.
- Avalonia `MainWindowHeadlessTests` covers non-default candidate selection.
- Existing shared planner tests continue to cover candidate deduplication, filtering, and token replacement.

Rich people-directory integration, coauthor presence, notification routing, and PowerPoint-authoritative review-pane visual baselines remain deferred.
