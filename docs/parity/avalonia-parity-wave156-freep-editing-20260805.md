# Avalonia FreeP Inline Table Editing Wave 156

## Closed

- Added Avalonia inline table-cell editor actions for inserting rows above/below, inserting columns left/right, deleting the active row/column, merging the active cell with its shared-planner neighbor, and splitting a merged anchor.
- Each action first commits the child rich-text editor through `InCanvasTableCellTextEditPlanner` and the existing `PresentationCommandBus`, then invokes the existing `EditingSession` table transaction. This keeps rich runs and undo ordering owned by the shared model instead of introducing a host-local table mutation path.
- Capability checks come from `TableCellEditPlanner.PlanSelectedCell`, so one-row/one-column tables and unmerged cells reject destructive or split actions without closing the active editor.
- The WPF authority remains `InCanvasTableCellEditor`: its row/column and merge/split actions use the same `EditingSession` operations now exposed by the Avalonia inline editor.
- Avalonia's real table context-menu routes and Merge/Split ribbon routes now invoke the inline editor bridge while a cell edit is active. When no inline editor is active, they retain the WPF-authority `EditingSession` route.
- Table context-menu and ribbon enablement now comes from the shared `TableCellEditState`. Right-clicking a table selects the hit table before setting its active cell so the state describes the actual menu target.

## Evidence

- `FreeP.App.Rendering.Avalonia.Tests`: focused inline-cell/editor adapter lane passed `19/19`.
- New table-command bridge coverage passed `2/2` in the initial focused run.
- `FreeP.App.Avalonia.Tests`: route-level table ribbon/context lane passed `11/11`; focused bridge-first and fallback tests passed `2/2`.
- `FreeP.App.Presentation.Tests` `TableCellEditPlannerTests`: `54/54` passed.
- `git diff --check`: passed.

## Remaining

- Avalonia inline table cells still do not expose every WPF cell command, including the complete cell paragraph/table-format command surface and richer clipboard behavior.
- Structural commands close the inline child editor before applying the table transaction; reopening the affected cell remains a host workflow concern.
- Inline cell edits remain part of the enclosing parent rich-text transaction until the containing shape edit commits, matching the Wave155 boundary.
