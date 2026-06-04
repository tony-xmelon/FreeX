# PivotTable Custom Number Format Catalog Design

## Goal

FreeX should apply and round-trip custom PivotTable value-field number formats whose `dataField/@numFmtId` points to a custom workbook `styles.xml` number-format catalog entry.

## In Scope

- Add a workbook-level custom number-format catalog keyed by XLSX `numFmtId`.
- Load custom `styles.xml` `numFmt` entries with IDs 164 and above.
- Attach a resolved custom format code to loaded PivotTable data fields.
- Prefer a data field's custom format code over built-in format ID lookup during PivotTable materialization.
- Save authored custom number-format catalog entries back to `styles.xml` and preserve the PivotTable `dataField/@numFmtId`.
- Avoid corrupting unrelated custom cell styles when a PivotTable catalog requests a custom ID already used by a generated stylesheet entry.
- Rewrite preserved source-package PivotTable XML after a save-time ID remap.

## Out of Scope

- Full Excel/OS locale formatting fidelity.
- Custom PivotTable format editing UI beyond existing modeled value-field settings.
- External/OLAP/data-model PivotTable refresh or execution.

## Acceptance Tests

- Pivot refresh applies a custom `NumberFormatCode` while preserving PivotStyle visual formatting.
- XLSX save/load writes a custom `numFmt` entry, writes the PivotTable data-field `numFmtId`, loads the catalog, and resolves the loaded data-field format code.
- XLSX save/load remaps a colliding custom PivotTable `numFmtId` instead of overwriting an unrelated cell-style format.
- Save-after-load remaps preserved PivotTable XML when source-package retention copies an old PivotTable part back into the generated package.
