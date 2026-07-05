# FreeP Comment Mention Insertion - 2026-07-06

## Scope

This comments/review workflow-depth slice adds shared people-picker-style
mention candidate discovery and mention insertion planning for comment text.
The implementation remains shared-first: WPF and Avalonia expose thin host
routes over `PresentationReviewWorkflowPlanner` and continue to apply comment
changes through the existing shared mutation path.

## Improved

- `PresentationReviewWorkflowPlanner` now builds deterministic mention
  candidate plans from the current reviewer plus existing comment and reply
  authors, deduplicated by normalized author identity.
- The shared insertion plan replaces partial `@` tokens around the caret or
  inserts a readable `@Name.Token` mention at the requested caret position.
- WPF and Avalonia test hooks consume the same picker and insertion plans, then
  route selected-comment updates through existing edit-comment mutation logic so
  pane refresh, dirty state, and mention descriptors stay consistent.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PresentationReviewWorkflowPlannerTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ReviewWorkflowAdapterTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep\FreeP.App.Avalonia.Tests\FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowHeadlessTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Remaining

- PowerPoint-authoritative review-pane visual baselines remain deferred.
- Coauthor presence and notification routing remain deferred.
