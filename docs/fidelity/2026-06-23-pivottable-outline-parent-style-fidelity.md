# PivotTable outline parent style fidelity - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Loaded native outline-layout PivotTables now detect parent row-label rows whose child labels continue on later rows with the first row-field cell blank.
- Those outline parent rows now materialize the full PivotTable footprint row and apply the Excel-like group/subtotal band style across blank cells, matching cases such as `East`, `North`, `South`, and `West` in the subtotal/grand-total corpus workbook.
- Compact grouped parent rows keep their existing compact group-header treatment, including the darker header-font behavior used by `PivotStyleMedium6`; outline parent rows use black label text with the lighter group band.
- Row-stripe banding excludes both compact and outline group-header rows, so parent rows do not shift subsequent body striping.

## Verification

Focused tests:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivottable-outline-parent-style.trx" --verbosity minimal
```

Result: `154 passed`, `1 skipped`.

Visual compare tool:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

Result: `0 warnings`, `0 errors`.

Full native PivotTable visual evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-outline-parent-style-20260623\full
```

Outcome: all 16 native Excel-authored PivotTable corpus workbooks rendered with exact Excel-vs-FreeX PNG dimensions and exited `0`.

| Case | Previous diff | Current diff |
| --- | ---: | ---: |
| `subtotal_grand_totals_004` | 8.4% | 7.2% |
| `show_items_no_data_004` | 7.7% | 6.1% |
| `date_grouping_003` | 6.9% | 6.9% |
| `layout_options_002` | 6.6% | 6.6% |
| `named_range_source_004` | 6.0% | 6.0% |
| `basic_row_column_001` | 5.5% | 5.5% |
| `chrome_style_flags_004` | 5.4% | 5.4% |
| `layout_matrix_004` | 5.0% | 4.9% |
| `table_source_filters_001` | 4.4% | 4.4% |
| `grouping_show_values_001` | 4.1% | 4.1% |
| `report_filters_001` | 3.7% | 3.7% |
| `filters_sorts_002` | 3.2% | 3.2% |
| `slicer_timeline_001` | 2.4% | 3.1% |
| `show_values_as_variants_004` | 2.6% | 2.6% |
| `calculated_field_item_003` | 2.2% | 2.2% |
| `multiple_pivots_one_cache_001` | 2.0% | 2.0% |

The `slicer_timeline_001` run still passed exact dimension gating and remains owned by the separate timeline-rendering workstream; its visible PivotTable grid output is not the focus of this slice.

## Remaining work

- PivotTable visual fidelity is still not pixel-perfect. The largest remaining diffs are `subtotal_grand_totals_004` at 7.2%, `date_grouping_003` at 6.9%, and `layout_options_002` at 6.6%.
- `date_grouping_003` remains dominated by text rasterization and dynamic PivotTable style rendering that Excel does not expose as ordinary cell `Font.Bold` or `Interior.Color` through COM.
- Next slices should focus on GridView text metrics/rasterization for `Aptos Narrow`-authored PivotTables, remaining PivotTable button chrome, and any style-element gaps visible in the date-grouping and layout-options cases.
