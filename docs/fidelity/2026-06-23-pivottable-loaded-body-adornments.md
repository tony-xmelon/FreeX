# PivotTable loaded body and outline adornment fidelity - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Loaded native PivotTables whose built-in style has no explicit body fill now materialize a white body surface in FreeX. This mirrors Excel's dynamic PivotTable style layer closely enough to hide normal sheet gridlines through unfilled PivotTable body cells.
- Existing loaded Excel/user visual fills are still preserved. The new white body layer only applies through `ApplyLoadedPivotStyles` when the loaded native PivotTable style has no body fill and the target cell has no existing pattern/fill layer.
- Non-compact row-label adornment planning now handles outline-style native PivotTables where the parent label is shown once and child labels continue on following rows with the parent field cell blank.
- Row-label adornment planning now scans `LastRenderedRange` for loaded native PivotTables instead of stopping at an anchor-only `TargetRange`.

## Verification

Focused tests:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivottable-style-body-surface.trx" --verbosity minimal
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotLoadedStyleApplicationTests" --logger "trx;LogFileName=pivottable-loaded-style-body-surface.trx" --verbosity minimal
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotRowLabelAdornmentPlannerTests" --logger "trx;LogFileName=pivottable-outline-adornments.trx" --verbosity minimal
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

All focused tests passed. `FreeX.SheetGridImageCompare` built with 0 warnings and 0 errors.

Full native PivotTable visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-gridline-fidelity-20260623c\full
```

Outcome: all 16 native Excel-authored PivotTable corpus workbooks rendered with exact Excel-vs-FreeX PNG dimensions and exited `0`. One Excel COM run failed once with `RPC server is unavailable` while exporting the slicer/timeline case; rerunning the remaining cases succeeded with no orphaned `EXCEL.EXE` process left behind.

| Case | Diff | Exact dimensions | Exact pixel metrics |
| --- | ---: | --- | --- |
| `subtotal_grand_totals_004` | 8.4% | 747x530 | mean 9.377%, changed>8 47.52% |
| `show_items_no_data_004` | 7.7% | 512x482 | mean 10.205%, changed>8 34.76% |
| `date_grouping_003` | 6.9% | 371x218 | mean 9.440%, changed>8 20.31% |
| `layout_options_002` | 6.6% | 713x314 | mean 12.128%, changed>8 73.89% |
| `named_range_source_004` | 6.0% | 654x218 | mean 14.367%, changed>8 48.26% |
| `basic_row_column_001` | 5.5% | 610x218 | mean 12.369%, changed>8 23.29% |
| `chrome_style_flags_004` | 5.4% | 719x218 | mean 14.644%, changed>8 58.03% |
| `layout_matrix_004` | 5.0% | 1380x458 | mean 11.962%, changed>8 40.54% |
| `table_source_filters_001` | 4.4% | 740x194 | mean 13.268%, changed>8 33.92% |
| `grouping_show_values_001` | 4.1% | 685x218 | mean 10.512%, changed>8 47.92% |
| `report_filters_001` | 3.7% | 681x194 | mean 10.394%, changed>8 23.45% |
| `filters_sorts_002` | 3.2% | 671x146 | mean 11.970%, changed>8 36.27% |
| `show_values_as_variants_004` | 2.6% | 1010x218 | mean 9.822%, changed>8 22.70% |
| `slicer_timeline_001` | 2.4% | 1490x338 | mean 8.312%, changed>8 38.54% |
| `calculated_field_item_003` | 2.2% | 1427x266 | mean 9.405%, changed>8 24.77% |
| `multiple_pivots_one_cache_001` | 2.0% | 914x194 | mean 7.253%, changed>8 22.22% |

## Remaining work

- The worst case improved from 8.7% to 8.4%, and `show_items_no_data_004` improved from 7.9% to 7.7%, but PivotTable visual fidelity is still not pixel-perfect.
- The dominant remaining deltas are text ink/weight, font fallback/rasterization, PivotTable button chrome, and some spacing/alignment around loaded native labels and totals.
- The next focused slice should start with typography: loaded native PivotTable cells still render visibly lighter than Excel in the worst cases even when geometry and core styling match.
