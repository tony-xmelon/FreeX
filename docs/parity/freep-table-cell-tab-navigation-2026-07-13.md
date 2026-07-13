# FreeP Table Cell Tab Navigation - 2026-07-13

Scope: bounded FreeP table-editing workflow slice for shared Tab and Shift+Tab navigation between editable table-cell anchors.

## Coverage

- `TableCellEditPlanner` owns renderer-neutral row-major navigation planning.
- Merged-cell continuation coordinates normalize to their editable anchor before resolving the next or previous editable cell.
- WPF and Avalonia both consume the same navigation plan from active in-canvas table-cell editors, commit the current edit, and reopen the target cell.
- No renderer-local table navigation policy is added.

## Verification

- `TableCellEditPlannerTests` covers merged-cell continuation, previous navigation, ordinary row-major traversal, and table-boundary stop status.
- `SlideCanvasAvaloniaTests` covers commit-and-reopen behavior through the Avalonia overlay adapter.
- `CanvasEditingTests` keeps WPF source routed through `TableCellEditPlanner.PlanNavigation`.

## Remaining

This does not add a true Avalonia rich-text editor equivalent to the WPF `RichTextBox`, visible PowerPoint-style list galleries, image-bullet gallery chrome, or PowerPoint-authoritative rich-editor visual baselines.
