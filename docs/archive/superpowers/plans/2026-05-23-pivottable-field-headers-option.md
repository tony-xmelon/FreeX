# PivotTable Field Headers Option

## Goal

Expose and preserve Excel's PivotTable display option for field captions and filter drop-downs.

## Scope

- Add `PivotTableModel.ShowFieldHeaders` with a default of `true`.
- Surface the option in `PivotTableOptionsDialog` on the Display tab.
- Apply it through `ConfigurePivotTableOptionsCommand` with undo snapshots while preserving quick-option commands that omit it.
- Clone the setting with sheets.
- Round-trip OOXML `pivotTableDefinition/@showHeaders` on XLSX load/save.
- Update architecture and command parity documentation.

## Verification

- Focused PivotTable options command test.
- Focused PivotTable options dialog tests.
- Focused authored PivotTable XLSX smoke test.
- Full solution build.
