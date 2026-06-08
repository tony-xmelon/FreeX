# macOS Review Workflow Readiness

The bounded Review workflow surface for Avalonia lives in `FreeX.App.Services` through
`ReviewWorkflowPlanner` and `WorkbookSession` review helpers. The planner composes the existing
portable core services for workbook statistics, accessibility checks, spelling issues, notes, and
threaded comments without depending on WPF dialogs.

Avalonia review dialogs should request a `ReviewWorkflowPlan` from `WorkbookSession.GetReviewWorkflowPlan`,
render platform-native UI around that data, and route navigation through `GoToNextNote`,
`GoToNextThreadedComment`, or `GoToAccessibilityIssue`. Spelling dialog actions can build replacement
commands with `ReviewWorkflowPlanner.BuildSpellingReplacementCommand` or
`BuildSpellingReplaceAllCommand`, then execute them through `WorkbookSession.ExecuteReviewCommand` so
selection, viewport, dirty state, undo, and recalculation stay consistent with other workbook edits.

This slice intentionally does not port the WPF dialogs or rewrite the Review tab. It establishes the
portable orchestration contract future macOS/Avalonia UI can consume.
