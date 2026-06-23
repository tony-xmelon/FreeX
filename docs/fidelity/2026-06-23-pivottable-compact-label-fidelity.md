# PivotTable compact row-label fidelity pause - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed before pause

- Added machine-readable `metrics.json` output to `FreeX.SheetGridImageCompare` for Excel-vs-FreeX visual comparisons. The prior text `REPORT.txt` remains unchanged.
- Ran the 16-case native PivotTable visual corpus with `--pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8`.
- Adjusted compact-layout PivotTable row-label adornment planning so indented child labels reserve the Excel-style expand/collapse gutter without drawing a child expand/collapse button.
- Added focused host-logic coverage for the compact parent plus child-label padding behavior.

## Current evidence

Metrics JSON harness baseline:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-metrics-json-20260623\full
```

Compact-label slice evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-compact-label-fidelity-20260623\full
```

The full compact-label run compared 16 PivotTable cases, with 0 failed rows and 0 dimension mismatches.

Targeted improvements versus the metrics-JSON baseline:

| Case | Fallback mean before | Fallback mean after | Exact mean before | Exact mean after | Changed pixels before | Changed pixels after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `date_grouping_003` | 6.8965% | 6.4129% | 9.4397% | 8.8561% | 20.31% | 19.84% |
| `layout_matrix_004` | 4.8986% | 4.8190% | 11.8461% | 11.7024% | 40.84% | 40.75% |

No other 16-case corpus entry moved meaningfully.

Current ranked compact-label metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.2025% | 8.0647% | 31.88% | 0 |
| `layout_options_002` | 6.6075% | 12.1284% | 73.89% | 0 |
| `date_grouping_003` | 6.4129% | 8.8561% | 19.84% | 0 |
| `show_items_no_data_004` | 6.1368% | 8.2908% | 18.66% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.8190% | 11.7024% | 40.75% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

## Verification used

Focused compact-label test:

```powershell
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotRowLabelAdornmentPlannerTests --logger "trx;LogFileName=pivot-compact-adornment-tests.trx" --verbosity minimal
```

Outcome before final integration: 5 passed, 0 failed.

The branch was prepared for the standard full verification lane:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"
```

## Outstanding non-external PivotTable work

- This is not yet 100% visual fidelity. The compact row-label adjustment reduced a targeted geometry mismatch, but the current corpus still shows measurable differences across every case.
- The largest remaining fallback mean diffs are `subtotal_grand_totals_004`, `layout_options_002`, `date_grouping_003`, `show_items_no_data_004`, and `named_range_source_004`.
- The highest changed-pixel cases remain `layout_options_002`, `chrome_style_flags_004`, `named_range_source_004`, `grouping_show_values_001`, and `layout_matrix_004`; these are mostly text weight, border/chrome, fill, and loaded-native body-surface differences rather than dimension failures.
- Resume by using the JSON metrics harness for one focused case at a time, then rerun the 16-case corpus before integration.
