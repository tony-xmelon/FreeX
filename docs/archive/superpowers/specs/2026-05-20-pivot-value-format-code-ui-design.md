# PivotTable Value Format Code UI Design

## Goal

Let Value Field Settings author custom PivotTable value-field number format codes using the model and XLSX catalog support already in place.

## Scope

- Add a custom format-code field to the Number Format tab of the PivotTable Value Field Settings dialog.
- Load existing `PivotDataFieldModel.NumberFormatCode` values into the dialog.
- Save edited custom codes back to `PivotDataFieldModel.NumberFormatCode`.
- When a user enters a custom format code without a custom `numFmtId`, assign the default custom ID `164` so refresh and XLSX save route through the workbook catalog path.

## Non-Goals

- Full Excel number-format picker/gallery UI.
- Locale-aware format-code validation.
- Full workbook-palette or accounting-format catalog editing.

## Verification

Focused verification covers the dialog input parser and the source/XAML hygiene test for the Value Field Settings dialog.
