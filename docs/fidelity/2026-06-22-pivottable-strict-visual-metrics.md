# PivotTable Strict Visual Metrics

Date: 2026-06-22

Scope: local worksheet/data-table PivotTables only. External connections, Data Model, and OLAP remain intentionally out of scope.

## Change

`FreeX.SheetGridImageCompare` now reports exact same-size pixel metrics whenever the Excel and FreeX PNG dimensions match:

- Mean exact pixel delta, alpha-composited over white.
- Changed-pixel percentage using a configurable max-channel tolerance.
- Maximum channel delta.
- Optional strict gate with `--strict-pixel-threshold <percent>`.

The older normalized `800x600` mean-pixel diff remains in place for continuity with existing reports. Exact metrics are meant to expose residual PivotTable rendering disparities that normalized scaling can hide.

## Corpus Run

Command:

```powershell
$base = 'C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out = 'C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-strictmetrics-20260622'
Get-ChildItem $base -Filter *.xlsx | Sort-Object Name | ForEach-Object {
  $caseOut = Join-Path $out $_.BaseName
  dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out $caseOut --threshold 25 --pixel-tolerance 8
}
```

Result: all `10` native PivotTable corpus workbooks rendered with exact Excel/FreeX PNG dimension matches and `OK` status under the existing normalized threshold. The exact same-size metrics show that this is not pixel-perfect fidelity yet.

Summary output: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-strictmetrics-20260622\summary.json`

| Workbook | Normalized diff | Exact mean | Changed pixels > 8 |
| --- | ---: | ---: | ---: |
| `Excel_native_pivot_basic_row_column_001.xlsx` | 8.5% | 18.258% | 31.58% |
| `Excel_native_pivot_calculated_field_item_003.xlsx` | 6.1% | 24.747% | 44.19% |
| `Excel_native_pivot_date_grouping_003.xlsx` | 10.5% | 13.803% | 39.48% |
| `Excel_native_pivot_filters_sorts_002.xlsx` | 4.7% | 17.015% | 44.23% |
| `Excel_native_pivot_grouping_show_values_001.xlsx` | 5.3% | 12.884% | 48.29% |
| `Excel_native_pivot_layout_options_002.xlsx` | 10.3% | 18.073% | 69.28% |
| `Excel_native_pivot_multiple_pivots_one_cache_001.xlsx` | 5.6% | 20.046% | 58.04% |
| `Excel_native_pivot_report_filters_001.xlsx` | 8.8% | 23.827% | 53.13% |
| `Excel_native_pivot_slicer_timeline_001.xlsx` | 5.7% | 14.101% | 36.69% |
| `Excel_native_pivot_table_source_filters_001.xlsx` | 5.3% | 15.669% | 35.42% |

## Remaining Disparities

- Exact changed-pixel rates remain high, from `31.58%` to `69.28%`, despite exact output dimensions.
- The worst strict metric is the layout-options fixture, where row label adornments now appear but style fill, stripe granularity, text metrics, and clipping still diverge from Excel.
- The report-filter, shared-cache, and layout fixtures still show more than half of same-size pixels changed above tolerance.
- The current default report remains a trend gate, not a 100% fidelity gate. Use `--strict-pixel-threshold` to make the exact changed-pixel percentage fail a run.

## Follow-Up Targets

- Reduce fill and stripe placement differences across PivotTable styles.
- Align row/column sizing and text clipping with Excel's PivotTable rendering.
- Calibrate font metrics and header/body border placement using the exact same-size metrics.
- Promote a strict threshold only after the corpus has been driven down to a stable low changed-pixel baseline.
