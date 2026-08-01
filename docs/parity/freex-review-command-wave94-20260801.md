# FreeX Review Command Parity Wave 94

Date: 2026-08-01
Branch: `codex/agent-freex-review-command-wave94-20260801`
Baseline: `faa90dbf93` (Wave94 integration context)

## Selected gap

The WPF review surface gives `Show Comments` and `Show Notes` different meanings:

- `Show Comments` opens a modeless list of threaded comments for the active sheet and lets the
  user open the selected cell.
- `Show Notes` executes the undoable show-all/hide-all legacy-note command.
- The worksheet context-menu `Show Notes` route uses the same show-all/hide-all command.

Avalonia routed both ribbon commands to one combined notes/comments list. That made legacy notes
appear in the comments list and left the `Show Notes` command unable to pin or unpin note boxes.
It was a concrete runtime behavior difference, not an evidence-only discrepancy.

## Implementation

- Added a dedicated Avalonia `ShowCommentsListAsync` route that lists threaded comments only,
  preserves the modeless window and selection, refreshes after comment mutations, and reports the
  WPF-style no-comments case without opening an empty window.
- Routed Avalonia `Show Notes`, `review.showNotes`, and worksheet-context `Show Notes` to
  `ToggleAllNotesVisibility`.
- Updated parity capture to seed a threaded comment for the comment-list surface.
- Aligned the Avalonia comment-list automation identifiers with the WPF comment-list surface.

## Verification

Command:

```text
dotnet test tests\\FreeX.App.Avalonia.Tests\\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaReviewCommentInlineRuntimeTests|FullyQualifiedName~DialogInteractionValidationTests|FullyQualifiedName~ParityCaptureTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: 30 passed, 0 failed, 0 skipped.

Focused runtime coverage proves that the open comment list refreshes after an inline root edit,
filters out legacy notes, preserves the same modeless window on re-open, and that `Show Notes`
toggles all legacy-note visibility on and off.

## Residuals

The Avalonia list still uses its existing portable `ListBox` presentation rather than WPF's
two-column `GridView` template. This slice fixes command semantics and data scope; visual chrome
parity for the two list windows remains a separate visual task. Reply-level editing remains in
the existing inline comment editor, matching the current Avalonia workflow.
