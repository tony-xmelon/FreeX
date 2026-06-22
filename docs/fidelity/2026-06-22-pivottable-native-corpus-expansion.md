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

## Evidence

Generated native corpus:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps2-20260622a
```

Outcome: `PASS: Excel validated 6/6 workbook(s).`

Package inspection confirmed:

- `Excel_native_pivot_filters_sorts_002.xlsx` contains `<filters count="2">` with `type="captionBeginsWith"` and `type="valueGreaterThan"`.
- `Excel_native_pivot_layout_options_002.xlsx` contains `showHeaders="0"`, `compact="0"`, `compactData="0"`, `defaultSubtotal="0"`, and `fillDownLabels` extension metadata.

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps2-20260622a\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-gaps2-20260622a'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all six workbooks passed; seven PivotTable ranges were compared using Excel `TableRange2`.

- `Pivot Basic!A3:E9`: diff `9.3%`
- `Pivot Sort Filter!A3:D6`: diff `4.7%`
- `Pivot Buckets!A3:E9`: diff `5.1%`
- `Pivot Layout!A3:F13`: diff `5.0%`
- `Pivot Shared Cache!A3:B8`: diff `6.9%`
- `Pivot Shared Cache!F3:G7`: diff `14.5%`
- `Pivot Filters!A3:E8`: diff `4.7%`

## Still Open

- True Excel date grouping metadata remains uncovered; the current grouping/show-values fixture uses helper source columns rather than Excel `fieldGroup` metadata.
- Native calculated fields/items still need Excel-authored corpus coverage and render coverage.
- Table-name PivotCache source semantics are being addressed separately because the visual COM path that used a ListObject table name previously produced an anchor-only body.
- Pixel comparison still uses an exploratory threshold; completion should eventually include strict dimension reporting before pixel-diff thresholds.
