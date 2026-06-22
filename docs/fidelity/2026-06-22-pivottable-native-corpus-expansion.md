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
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-exact-dimensions-20260622a'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all eight workbooks passed; nine PivotTable ranges were compared using Excel `TableRange2`. With Excel reference PNG dimensions loaded before FreeX rendering, the strict `--fail-on-dimension-mismatch` gate now passes with exact Excel-vs-FreeX PNG dimensions.

- `Pivot Basic!A3:E9`: diff `7.9%`, dimensions `Excel 610x170; FreeX 610x170`
- `Pivot Sort Filter!A3:D6`: diff `5.1%`, dimensions `Excel 671x135; FreeX 671x135`
- `Pivot Buckets!A3:E9`: diff `3.4%`, dimensions `Excel 685x170; FreeX 685x170`
- `Pivot Layout!A3:F13`: diff `5.1%`, dimensions `Excel 713x266; FreeX 713x266`
- `Pivot Shared Cache!A3:B8`: diff `6.6%`, dimensions `Excel 448x146; FreeX 448x146`
- `Pivot Shared Cache!F3:G7`: diff `17.6%`, dimensions `Excel 228x135; FreeX 228x135`
- `Pivot Filters!A3:E8`: diff `4.7%`, dimensions `Excel 740x146; FreeX 740x146`
- `Pivot Date Group!A3:B9`: diff `9.3%`, dimensions `Excel 371x170; FreeX 371x170`
- `Pivot Calculations!A3:I11`: diff `2.0%`, dimensions `Excel 1427x218; FreeX 1427x218`

## Still Open

- The visual lane now passes strict Excel-vs-FreeX PNG dimension checks for the native PivotTable corpus.
- Pixel comparison still uses a thresholded mean-diff comparison rather than a pixel-perfect acceptance gate.
