# PivotTable native corpus expansion - 2026-06-22

Scope: Windows-only FreeX vs desktop Microsoft Excel PivotTable parity for local/native PivotTables. External connections, workbook Data Model execution, and OLAP refresh semantics remain out of scope.

## Added Coverage

- `Excel_native_pivot_filters_sorts_002.xlsx` adds an Excel-authored PivotTable with native PivotTable filters:
  - row-field caption filter `captionBeginsWith`
  - column-field value filter `valueGreaterThan`
  - row-field AutoSort materialized in Excel item order
- `Excel_native_pivot_layout_options_002.xlsx` adds an Excel-authored PivotTable with native layout/display metadata:
  - tabular row layout (`compact="0"`, `compactData="0"`)
  - field captions hidden (`showHeaders="0"`)
  - repeated labels (`fillDownLabels`)
  - row/column stripe style flags
  - disabled default subtotals on row fields
- `Excel_native_pivot_date_grouping_003.xlsx` adds an Excel-authored PivotTable grouped by months and years through Excel's native grouping command, producing `fieldGroup` metadata.
- `Excel_native_pivot_calculated_field_item_003.xlsx` adds an Excel-authored calculated field (`Sales Bonus`) and calculated item (`North South`) in the native PivotCache/PivotTable XML shape.

## Evidence

Generated native corpus:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-final-gaps-20260622a
```

Outcome: `PASS: Excel validated 8/8 workbook(s).`

Package inspection confirmed:

- `Excel_native_pivot_filters_sorts_002.xlsx` contains `<filters count="2">` with `type="captionBeginsWith"` and `type="valueGreaterThan"`.
- `Excel_native_pivot_layout_options_002.xlsx` contains `showHeaders="0"`, `compact="0"`, `compactData="0"`, `defaultSubtotal="0"`, and `fillDownLabels` extension metadata.
- `Excel_native_pivot_date_grouping_003.xlsx` contains `fieldGroup` metadata in the PivotCache definition.
- `Excel_native_pivot_calculated_field_item_003.xlsx` contains `cacheField name="Sales Bonus" ... formula="Sales*0.1"` and a native `calculatedItems` block for `North South`.

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-final-gaps-20260622a\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-final-gaps-20260622a'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all eight workbooks passed; nine PivotTable ranges were compared using Excel `TableRange2`.

- `Pivot Basic!A3:E9`: diff `6.2%`
- `Pivot Sort Filter!A3:D6`: diff `4.1%`
- `Pivot Buckets!A3:E9`: diff `5.1%`
- `Pivot Layout!A3:F13`: diff `8.9%`
- `Pivot Shared Cache!A3:B8`: diff `6.9%`
- `Pivot Shared Cache!F3:G7`: diff `14.5%`
- `Pivot Filters!A3:E8`: diff `4.7%`
- `Pivot Date Group!A3:B9`: diff `13.1%`
- `Pivot Calculations!A3:I11`: diff `5.6%`

## Still Open

- Matrix calculated-item rendering remains under active product coverage; the native corpus now exercises Excel-authored calculated field/item metadata.
- Table-name PivotCache source semantics are being addressed separately because the visual COM path that used a ListObject table name previously produced an anchor-only body.
- Pixel comparison still uses an exploratory threshold; completion should eventually include strict dimension reporting before pixel-diff thresholds.
