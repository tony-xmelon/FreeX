# PivotTable Medium12 outline style fidelity - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Improved loaded native `PivotStyleMedium12` outline PivotTable rendering for subtotal and grand-total permutations.
- Split the generic Medium12 style mapping into Excel-observed surfaces:
  - outline parent rows use the lighter Accent4 0.8 fill,
  - subtotal rows use the darker Accent4 0.7 fill,
  - grand-total rows keep Excel's white worksheet surface instead of inheriting the subtotal fill.
- Reused the optional compact/group header fill for outline parent rows so the style layer can represent parent rows separately from subtotal rows.
- Added focused regression coverage for the native `A3:E22` Medium12 outline shape, including blank row-field footprint cells.

This is not a 100% PivotTable-fidelity checkpoint. It is a measured visual improvement for the previous worst-ranked native PivotTable corpus case, with no measured full-corpus regressions.

## Visual evidence

Baseline evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-expand-collapse-size-20260623\full
```

Current focused evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\focused
```

Current full 16-case evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full
```

Machine-readable deltas:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\full\delta-vs-pivot-expand-collapse-size.csv
```

The full run compared all 16 native PivotTable cases with 0 failed rows and 0 dimension mismatches.

Delta summary versus `pivot-expand-collapse-size-20260623`:

| Metric | Improved cases | Regressed cases |
| --- | ---: | ---: |
| Fallback mean diff | 1 | 0 |
| Exact mean diff | 1 | 0 |
| Changed pixels | 1 | 0 |

Targeted improvement:

| Case | Fallback mean before | Fallback mean after | Exact mean before | Exact mean after | Changed pixels before | Changed pixels after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.1965% | 6.3641% | 8.0582% | 7.1258% | 31.81% | 29.05% |

Current ranked full-corpus metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `layout_options_002` | 6.4261% | 11.9970% | 73.82% | 0 |
| `date_grouping_003` | 6.4024% | 8.8429% | 19.76% | 0 |
| `subtotal_grand_totals_004` | 6.3641% | 7.1258% | 29.05% | 0 |
| `show_items_no_data_004` | 6.1310% | 8.2832% | 18.56% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.7888% | 11.6343% | 40.78% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

## Verification

Focused core PivotTable style regression:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivot-medium12-core-style-tests.trx" --verbosity minimal
```

Outcome: 155 passed, 1 benchmark skipped, 0 failed.

Focused visual comparison:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b\generated-excel-pivots\Excel_native_pivot_subtotal_grand_totals_004.xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out C:\Users\ali\freex-xlsx-verify\visual\pivot-medium12-subtotal-20260623\focused
```

Outcome: 1 compared case, 0 failed rows, 0 dimension mismatches.

Full native PivotTable visual corpus:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- <native-pivot-workbook> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out <case-output>
```

Outcome: 16 compared cases, 0 failed rows, 0 dimension mismatches.

## Remaining gaps

FreeX is still not at 100% local PivotTable visual fidelity. After this slice, the highest fallback-mean residuals are:

- `layout_options_002`: font rasterization, row-label/body layout, and residual style geometry.
- `date_grouping_003`: compact date-grouping geometry/text and button chrome.
- `subtotal_grand_totals_004`: still has text rasterization and field-button chrome residuals after the Medium12 style improvement.
- `show_items_no_data_004` and `named_range_source_004`: loaded native style/chrome and typography differences.
- `chrome_style_flags_004`: field-button/dropdown chrome remains the largest exact-mean residual.

Recommended next target: typography/font rendering for loaded Office-authored PivotTables, especially the `Aptos Narrow` theme face that Excel reports but WPF does not expose as an installed system font in this environment.
