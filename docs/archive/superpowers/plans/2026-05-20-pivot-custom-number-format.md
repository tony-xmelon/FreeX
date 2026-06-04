# PivotTable Custom Number Format Implementation Plan

## Tasks

- [x] Add failing refresh and XLSX save/load tests for custom PivotTable value-field number formats.
- [x] Add a workbook custom number-format catalog and a `PivotDataFieldModel.NumberFormatCode` field.
- [x] Teach `PivotTableRefreshService` to prefer explicit custom format codes before built-in `numFmtId` mapping.
- [x] Load custom `styles.xml` `numFmt` entries and bind matching PivotTable data fields to their format code.
- [x] Save custom catalog entries to `styles.xml` for authored PivotTables.
- [x] Remap custom PivotTable `dataField/@numFmtId` values when a generated stylesheet already uses the requested custom ID.
- [x] Apply the same remap after source-package preservation so loaded PivotTable XML cannot keep stale IDs.
- [x] Update architecture, command parity, toolbar parity, and ADR documentation.
- [ ] Run focused model/IO tests, review, then merge and sync.

## Decisions

- Custom PivotTable value formatting is model-backed through `Workbook.NumberFormatCatalog` plus the data field's resolved `NumberFormatCode`.
- Built-in ID mapping remains in `PivotTableRefreshService`; custom IDs are treated as workbook catalog entries rather than hard-coded formatter cases.
- Save keeps generated cell-style `numFmtId` entries authoritative. If a PivotTable catalog ID collides with a different generated style format, the PivotTable catalog entry is assigned the next free custom ID and every authored or preserved PivotTable `dataField/@numFmtId` is rewritten to that ID.
- Full locale and external/OLAP PivotTable behavior remain outside this slice.
