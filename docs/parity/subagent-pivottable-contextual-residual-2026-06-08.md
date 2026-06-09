# PivotTable contextual residual parity - 2026-06-08

## Scope

Validated bounded residual PivotTable contextual interactions against Excel behavior after a PivotTable cell/body is selected:

- Refresh, Select, Clear, Move, Options, Field List, Change Data Source, Show Details.
- Insert Slicer and Insert Timeline when reached from PivotTable context.
- PivotTable Design layout/style toggles that share the active PivotTable guard.

## Findings

- Existing command/model coverage already guards PivotTable refresh, Show Details drill-down, options, slicer/timeline authoring, protected-sheet permissions, and timeline date-field validation.
- Existing UI planner coverage already distinguishes strict PivotTable-body selection from the helper that falls back to the first PivotTable on the active sheet.
- Residual gap found: several contextual Analyze/Design command handlers used the fallback helper, so a command could operate on the first PivotTable on the sheet even after selection had moved to an ordinary cell. Excel hides/disables PivotTable contextual surfaces when the selection leaves the PivotTable body.

## Change

- `TryGetActivePivotTable` now requires the current selection to intersect the PivotTable.
- Field List and Change Data Source handlers now use the same strict PivotTable selection requirement.
- Focused source tests document that contextual handlers must use `FindPivotTableContainingSelection` and must not use the non-contextual fallback helper.

## Remaining gaps

- Full native Excel task-pane chrome, exact slicer/timeline styling, and full external/OLAP PivotTable cache execution remain outside this bounded slice.
- Insert-tab Slicer/Timeline behavior outside PivotTable context was not expanded; this slice only tightened PivotTable-contextual commands.
