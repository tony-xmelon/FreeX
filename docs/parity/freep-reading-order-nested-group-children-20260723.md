# FreeP nested reading-order moves

## Scope

Reading Order Move Earlier/Move Later now applies to the selected shape's
containing sibling list. Top-level shapes continue to reorder in `Slide.Shapes`;
group children reorder only in their parent `Children` list, preserving group
membership and the flattened pane order. The existing undoable
`ReorderShapeCommand` resolves the containing list recursively, so WPF and
Avalonia use the same mutation path.

## Verification

- Shared planner/model focused lane: 9/9 compile and 9/9 `--no-build`.
- Full `PresentationReviewWorkflowPlannerTests`: 81/81 `--no-build`.
- WPF `MainWindow_ReadingOrderCommand_ShowsSharedPlanBackedPane`: 1/1 compile and 1/1 `--no-build`.
- WPF `ReviewWorkflowAdapterTests`: 30/30 `--no-build`.
- Avalonia nested reading-order headless test: 1/1 compile and 1/1 `--no-build`.
- Avalonia reading-order filter: 2/2 `--no-build`.

The boundary contract remains explicit: the first and last child disable only
the direction that has no sibling; nested moves are no longer reported as
deferred. Undo/redo restores the child order without changing top-level slide
order.
