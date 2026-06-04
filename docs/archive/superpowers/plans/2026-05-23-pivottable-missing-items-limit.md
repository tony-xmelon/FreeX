# PivotTable Missing Items Limit

## Goal

Expose Excel's PivotTable Data option for retaining items deleted from the data source through the model, command layer, dialog, and XLSX round-trip.

## Scope

- Add `PivotCacheModel.MissingItemsLimit` as the authoritative cache-level setting.
- Map OOXML `pivotCacheDefinition/@missingItemsLimit` on load/save.
- Surface Automatic, None, and Maximum in `PivotTableOptionsDialog`.
- Apply changes through `ConfigurePivotTableOptionsCommand` with undo/redo snapshots.
- Document the normalization contract: `null` = Automatic, `0` = None, positive = Maximum (`1,048,576`).

## Verification

- Focused command test for apply/undo cache data options.
- Focused PivotTable Options dialog tests for result normalization and connected-cache loading.
- Focused XLSX smoke test for `missingItemsLimit` save/load.
- Full solution build.
