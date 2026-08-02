# FreeW Wave106: Editable Side-to-Side prerequisite

Date: 2026-08-02

## Scope

The documented residual in `docs/parity/2026-06-27-avalonia-wpf-parity-scope.md` was that View > Side to Side used a read-only page preview and deferred editable horizontal page view. This slice closes the largest independently testable prerequisite: entering Side to Side now keeps an editable page surface alive in both hosts and preserves edits when the mode is exited.

## Implementation

- `FreeWViewDepthPlanner` now describes Side to Side as an `EditablePageView` with `AllowsPrimaryEditing=true` and `UsesReadOnlySnapshot=false`.
- WPF uses the existing `PaginatedEditorPanel` with horizontal page flow. The panel remains responsible for page sharding, cross-page caret routing, repagination, and commit; the WPF shell only supplies pair navigation and lifecycle restoration.
- Avalonia keeps the live `DocumentView` attached, enables horizontal scrolling for the mode, and reuses the existing pair-navigation host instead of creating a hit-test-disabled cloned snapshot.
- Multiple Pages and Split remain read-only by design in this slice.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~FreeWViewDepthPlannerTests`
  - 15 passed, 0 failed.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --no-restore --filter FullyQualifiedName~PageViewModesTests`
  - 22 passed, 0 failed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~ViewTabDepthTests`
  - 27 passed, 0 failed.

## Remaining residual

This is a prerequisite, not a claim of complete page-view parity. Cross-page clipboard/undo parity remains deferred. Avalonia's live editor is editable but still needs a native horizontal page-grid layout with page-aware hit testing and pair scrolling; its current adapter preserves the live editor and navigation contract while that deeper layout work remains. Multiple Pages remains a read-only grid, and Split remains a live-editor plus read-only snapshot.
