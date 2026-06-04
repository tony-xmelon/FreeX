# Pivot Value Number Format Design

## Goal

Advance PivotTable fidelity by applying modeled value-field number formats to generated PivotTable value cells.

## Scope

- Resolve common Excel built-in PivotTable `numFmtId` values into FreeX `CellStyle.NumberFormat` codes.
- Apply the resolved number format to generated body, subtotal, grand-total, column-only, matrix, and values-only value cells.
- Preserve value-field number formats when PivotTable visual styles apply header, subtotal, grand-total, stripe, or column-stripe fills/borders.
- Keep worksheet-range PivotTable execution model-first and deterministic.

## Constraints

- Do not implement full Excel custom PivotTable number-format catalogs in this slice.
- Do not change aggregation, Show Values As, sorting, filtering, or source-cache semantics.
- Keep formatting owned by `Core.Commands.PivotTableRefreshService` because that service materializes the report cells.
