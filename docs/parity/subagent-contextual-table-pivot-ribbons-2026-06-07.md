# Contextual Table And Pivot Ribbons Reconciliation - 2026-06-07

## Purpose

This note preserves the historical contextual table/pivot ribbon report reference used by the visual parity ledger. The current aggregate branch has the detailed implementation notes split across table/pivot residual reports and source-visible tests.

## Current Coverage

- Table Design is present as a collapsed contextual tab with Properties, Tools, Table Style Options, and Table Styles groups.
- `FREEX_SS_TOUR_CONTEXT=table` now has live screenshot evidence for the seeded structured-table selection at `screenshots/contextual-table-tour/900_Table_Design.png`, indexed by `screenshots/contextual-table-tour/ribbon_screenshot_tour_manifest.json`.
- PivotTable Analyze and PivotTable Design are present as collapsed contextual tabs with Excel-like group ordering and key-tip routing.
- `docs/parity/subagent-insert-table-pivot-residual-2026-06-08.md` and `docs/parity/subagent-pivottable-contextual-residual-2026-06-08.md` record the latest table/pivot command behavior and remaining evidence gaps.
- `RibbonTabParityTests`, `RibbonXamlCatalogSnapshotReaderTests`, and `MainWindowRibbonKeyTipTests.Pivot` guard the contextual tab catalog and key-tip behavior.

## Remaining Gaps

- Table Design and PivotTable Analyze/Design now have workbook-backed screenshot-tour evidence at 900 width; additional widths, mouse/keytip workflows, and command-routing screenshots remain.
- PivotTable field-list, slicer/timeline, and protected-sheet command matrices continue to be tracked in their focused residual reports.
