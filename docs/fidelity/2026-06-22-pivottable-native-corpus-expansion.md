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
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-excel-reference-style-fixed-20260622b'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all eight workbooks passed; nine PivotTable ranges were compared using Excel `TableRange2`. With Excel reference PNG dimensions loaded before FreeX rendering, the strict `--fail-on-dimension-mismatch` gate passes with exact Excel-vs-FreeX PNG dimensions. The Excel reference exporter now rejects transparent/blank-looking clipboard images, falls back through bitmap and enhanced-metafile extraction, and preserves the same target canvas for FreeX rendering.

- `Pivot Basic!A3:E9`: diff `9.6%`, dimensions `Excel 610x170; FreeX 610x170`
- `Pivot Sort Filter!A3:D6`: diff `4.6%`, dimensions `Excel 671x98; FreeX 671x98`
- `Pivot Buckets!A3:E9`: diff `4.6%`, dimensions `Excel 685x170; FreeX 685x170`
- `Pivot Layout!A3:F13`: diff `10.7%`, dimensions `Excel 713x266; FreeX 713x266`
- `Pivot Shared Cache!A3:B8`: diff `12.9%`, dimensions `Excel 448x146; FreeX 448x146`
- `Pivot Shared Cache!F3:G7`: diff `16.6%`, dimensions `Excel 228x122; FreeX 228x122`
- `Pivot Filters!A3:E8`: diff `7.3%`, dimensions `Excel 740x146; FreeX 740x146`
- `Pivot Date Group!A3:B9`: diff `10.3%`, dimensions `Excel 371x170; FreeX 371x170`
- `Pivot Calculations!A3:I11`: diff `6.1%`, dimensions `Excel 1427x218; FreeX 1427x218`

Disparities fixed in this pass:

- Excel range PNG export sometimes returned transparent/blank clipboard content that contained only the filter-button glyph; the harness now rejects low-opacity references and retries through alternate `CopyPicture` paths, including enhanced metafile rasterization.
- No-reference FreeX renders accidentally inherited a default `0x0` nullable target dimension and collapsed to `1x1`; the renderer now only targets Excel dimensions when a reference PNG was actually discovered.
- Loaded PivotTables sharing one cache can render in Excel with the first visible shared-cache style by sheet position. FreeX now applies the same loaded-cache style choice while leaving refresh-created pivots on their own selected style.
- Office-equivalent XLSX themes can differ in non-accent slots such as hyperlink colors; built-in PivotStyle Medium2 now uses the Excel-matching Office palette when the Accent1-6 palette is unchanged, and custom accent themes still resolve dynamically.
- Loaded PivotTables preserve explicitly imported visual cell formatting, but default font-theme metadata no longer blocks PivotTable style materialization.

## Still Open

- The visual lane now passes strict Excel-vs-FreeX PNG dimension checks for the native PivotTable corpus.
- Pixel comparison still uses a thresholded mean-diff comparison rather than a pixel-perfect acceptance gate.
