# WPF floating-table text distance and overlap composition

## Scope

This slice extends the WPF single-page floating-table `Figure` path. It maps the four
authored `TableFloatingPosition` text distances to the closest FlowDocument primitive,
`Figure.Margin`, while preserving the table edge established by the shared page-placement
plan. Inline tables and physically paginated table segments remain on their existing paths.

WPF `Figure` has no supported equivalent of Word's floating-table `AllowOverlap` collision
policy. The model value therefore remains preserved through the existing table tag and
view-to-model commit path, but it does not alter `WrapDirection` or `CanDelayPlacement`.
Inventing table collision behavior in the host is outside this bounded slice.

## Effective mapping

- `LeftFromTextPt`, `TopFromTextPt`, `RightFromTextPt`, and `BottomFromTextPt` are consumed
  from the shared DIP plan and applied as the WPF `Figure.Margin`.
- Left and top distances are subtracted from the Figure offsets so the rendered table edge
  retains the page-space placement already established on current main.
- Missing distances resolve to zero; negative imported values are bounded to zero because
  WPF `Thickness` cannot represent negative text clearance.
- `WrapDirection.Both` and `CanDelayPlacement=false` remain the established Figure behavior
  for both `AllowOverlap=true` and `AllowOverlap=false`.

## Verification

Focused WPF host tests cover:

- effective four-sided Figure margins, compensated page offsets, and metadata round-trip;
- distinct overlap values retaining identical supported Figure composition properties;
- an inline table staying a direct FlowDocument table;
- a multi-page table staying on the existing Section pagination path with no Figure wrapper.

Release verification on the consuming WPF artifacts:

- `FreeW.App.Host` build: 0 warnings, 0 errors.
- `FreeW.App.Host.Tests` build: 0 warnings, 0 errors.
- Slice contracts: 3 passed (`FloatingTablePlacement_UsesTheSharedPlacementContractAndSurvivesCommit`,
  `FloatingTableAllowOverlap_RemainsMetadataWithoutInventingFigureCollisionBehavior`, and
  `FloatingTableTextDistances_LeavePaginatedTablesOnTheExistingSectionPath`).
- Neighboring inline/pagination controls: 5 passed (`CenteredFixedWidthPaginatedTable_RendersWithWordLikeBlockMargin`,
  `CenteredFixedWidthFlowTable_UsesTheAuthoredWidthConstraint`,
  `LeftAlignedPreferredWidthFlowTable_ReservesTrailingWidth`,
  `TablePagination_WithoutRepeatHeader_RendersPlannedPageBreakSegments`, and
  `TablePageCompositionStress_RendersWordLikePhysicalSegments`).

No Word COM or pixel claim is attached to this functional host slice. A later visual pass can
calibrate FlowDocument's actual wrap exclusion against a matching Word reference without
changing the package or shared placement contracts.
