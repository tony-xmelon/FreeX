# PivotTable Native Style Offset Fidelity

Date: 2026-06-22

Scope: local worksheet/data-table PivotTables only. External connections, Data Model, and OLAP remain intentionally out of scope.

## Change

Loaded Excel-authored PivotTables now use the native OOXML `location` offsets when applying PivotTable header and banded style footprints:

- `firstDataRow` now controls the loaded/native header-band extent for non-page-field layouts.
- `firstDataCol` now controls where native column striping begins, keeping row-label columns out of column stripes.
- Header and band style footprint cells are materialized for loaded/native PivotTables so Excel-style blank cells inside a PivotTable range receive the same visual treatment as populated cells.
- Page-field/report-filter layouts remain guarded so report-filter caption rows do not cause body rows to inherit the matrix header footprint.

This fixes a visible gap in native layout/report variants where Excel paints a continuous PivotTable header or stripe band across blank cells but FreeX only styled cells that already had values.

## Corpus Run

Command:

```powershell
$base = 'C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out = 'C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-styleoffset-pageguard-20260622'
Get-ChildItem $base -Filter 'Excel_native_pivot_*.xlsx' | Sort-Object Name | ForEach-Object {
  $caseOut = Join-Path $out $_.BaseName
  dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out $caseOut --threshold 25 --pixel-tolerance 8
}
```

Result: all `10` native PivotTable corpus workbooks rendered with exact Excel/FreeX PNG dimension matches and `OK` status under the normalized threshold.

Summary output: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-styleoffset-pageguard-20260622\summary.json`

Delta output: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-styleoffset-pageguard-20260622\delta-vs-strictmetrics.json`

| Workbook | Normalized diff | Exact mean | Changed pixels > 8 | Normalized delta | Exact mean delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Excel_native_pivot_basic_row_column_001.xlsx` | 7.5% | 16.139% | 28.48% | -1.0 | -2.119 |
| `Excel_native_pivot_calculated_field_item_003.xlsx` | 3.7% | 15.000% | 30.60% | -2.4 | -9.747 |
| `Excel_native_pivot_date_grouping_003.xlsx` | 10.5% | 13.803% | 39.48% | 0.0 | 0.000 |
| `Excel_native_pivot_filters_sorts_002.xlsx` | 4.5% | 16.209% | 42.70% | -0.2 | -0.806 |
| `Excel_native_pivot_grouping_show_values_001.xlsx` | 5.2% | 12.651% | 48.29% | -0.1 | -0.233 |
| `Excel_native_pivot_layout_options_002.xlsx` | 9.0% | 15.826% | 70.65% | -1.3 | -2.247 |
| `Excel_native_pivot_multiple_pivots_one_cache_001.xlsx` | 5.6% | 20.046% | 58.04% | 0.0 | 0.000 |
| `Excel_native_pivot_report_filters_001.xlsx` | 8.8% | 23.827% | 53.13% | 0.0 | 0.000 |
| `Excel_native_pivot_slicer_timeline_001.xlsx` | 5.4% | 13.266% | 35.73% | -0.3 | -0.835 |
| `Excel_native_pivot_table_source_filters_001.xlsx` | 4.5% | 13.423% | 32.80% | -0.8 | -2.246 |

## Remaining Disparities

This is not 100% pixel fidelity. Exact changed-pixel rates remain high, from `28.48%` to `70.65%`, even with exact PNG dimension matches. The biggest remaining contributors are still:

- GridView vs Excel text metrics, antialiasing, bold weight, and clipping.
- Coarse PivotTable style element mapping compared with Excel's richer per-element table style model.
- Button, slicer, timeline, border, and body-fill chrome details.
- Row/column sizing and text overflow behavior in dense PivotTable ranges.

