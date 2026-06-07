# Contextual Table and Pivot Ribbon Slice

## Findings addressed

- PivotTable Analyze > Show now exposes Excel-like `+/- Buttons` and `Field Headers` commands next to `Field List`.
- Both commands route through the existing undoable `ConfigurePivotTableOptionsCommand` path and only toggle the modeled `ShowExpandCollapseButtons` and `ShowFieldHeaders` flags.
- Focused ribbon catalog/source tests cover the added command names, key tips, handlers, and expected Show group order.

## Remaining gaps

- Table Design still has no table-connected slicer command because FreeX slicer authoring is currently PivotTable-backed.
- PivotTable Analyze still does not expose separate expand-field/collapse-field active-field commands; the model has display toggles and Show Details, but no field expand/collapse action command in this slice.
- Visual QA against a live Excel window was not performed in this slice; parity was checked against Excel command layout conventions and existing FreeX modeled behavior.
