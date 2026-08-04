# FreeW WPF floating-table page placement

## Scope

WPF previously retained imported `w:tblpPr` metadata but rendered a single-page
floating table as an ordinary inline `Table`. Only its horizontal displacement was
approximated through the table margin; the shared planner's vertical placement was
discarded.

The WPF host now wraps only single-page floating tables in a FlowDocument `Figure`.
The figure consumes the shared page-relative X/Y placement plan, while the existing
WPF table remains the editable content owner. Inline tables and the existing
multi-page table-pagination path are unchanged.

## Functional gates

- The figure uses `PageLeft` and `PageTop` anchors with offsets translated from the
  shared surface plan.
- The authored table width remains the figure width and the nested table has no
  duplicate margin offset.
- Commit reconstructs the nested table instead of emitting an empty wrapper
  paragraph, preserving the complete floating-position payload.
- Table discovery descends into figures so table-cell caret restoration continues
  to find the editable table.

Focused WPF Release verification:

- `FloatingTablePlacement_UsesTheSharedPlacementContractAndSurvivesCommit`: 1/1
- floating/inline/paginated/table-layout controls: 9/9
- `FreeW.App.Host` and `FreeW.App.Host.Tests`: 0 warnings, 0 errors

## Remaining work

This slice establishes the WPF page-position owner and functional round trip. Word's
`w:tblpPr` text distances and `w:tblOverlap` collision behavior still need dedicated
WPF composition and visual corpus evidence. Multi-page tables deliberately remain on
the pagination path rather than being placed inside one figure.
