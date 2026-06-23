# PivotTable visual metrics JSON - 2026-06-23

Scope: Windows-only local PivotTable visual comparison against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Extended `FreeX.SheetGridImageCompare` diff mode so every Excel-vs-FreeX visual comparison writes a machine-readable `metrics.json` next to the existing `REPORT.txt`.
- Preserved the existing text report and exit behavior.
- Added source-level guard coverage so the PivotTable comparison harness continues to expose:
  - `metrics.json`
  - effective row status
  - same-size exact pixel metrics
  - changed-pixel percentages
  - PivotTable dropdown summaries

The JSON schema is intentionally small and stable for automation:

- `schemaVersion`
- `options`
- `summary`
- `rows[]`
- per-row dimensions, fallback mean diff, exact pixel metrics, status, error text, and Pivot dropdown summary

## Verification

Focused build:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

Outcome: passed with 0 warnings and 0 errors.

Focused schema guard:

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~ExcelOpenSmokeReportSchemaTests --logger "trx;LogFileName=pivottable-metrics-schema.trx" --verbosity minimal
```

Outcome: 13 passed, 0 failed.

Focused live visual compare:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_date_grouping_003.xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\date_grouping_003
```

Outcome: rendered 1, skipped 0, errors 0, dimensions matched exactly, and `metrics.json` was emitted.

The parsed JSON preserved the known `date_grouping_003` baseline:

- dimensions: 371x218
- fallback mean diff: 6.896505%
- exact mean diff: 9.439676%
- changed pixels over tolerance 8: 20.308366%
- Pivot dropdown summary: `Row:A3:Years (SaleDate)`

## 16-case machine-readable evidence

The full current native PivotTable corpus was rerun with `--pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8`.

Evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\full
```

Each case folder contains:

- `excel\excel_*.png`
- `freex\freex_*.png`
- `freex\worst_*.png`
- `freex\REPORT.txt`
- `freex\metrics.json`

Local summary CSV:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\full\summary.csv
```

Current ranked metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.2025% | 8.0647% | 31.88% | 0 |
| `date_grouping_003` | 6.8965% | 9.4397% | 20.31% | 0 |
| `layout_options_002` | 6.6075% | 12.1284% | 73.89% | 0 |
| `show_items_no_data_004` | 6.1368% | 8.2908% | 18.66% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.8986% | 11.8461% | 40.84% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

## Resume guidance

The harness now gives future PivotTable fixes a deterministic JSON target:

1. Run a focused case with `--threshold 100` during investigation so the tool exits 0 while preserving exact metrics.
2. Compare `freex\metrics.json` before and after the change.
3. Promote the fix only if the targeted case improves without increasing adjacent high-risk cases.
4. Use the full 16-case corpus before integration.

Next product targets remain:

- compact row-label text placement for `date_grouping_003`
- loaded native body/text rendering for `layout_options_002`
- subtotal/grand-total text and chrome fidelity for `subtotal_grand_totals_004`
