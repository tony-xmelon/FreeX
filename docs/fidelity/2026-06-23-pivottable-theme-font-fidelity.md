# PivotTable Theme Font And Style Fidelity - 2026-06-23

## Scope

This pass continues local native PivotTable parity against desktop Microsoft Excel for the in-scope feature surface. External connections, Data Model, and OLAP remain excluded.

The patch addresses two native-rendering issues found in the Excel-authored PivotTable corpus:

- Loaded PivotTable visual styles now merge over each cell's existing style instead of replacing the style id, preserving Excel-authored font family, font size, font scheme, and number formats while still applying PivotTable fills, borders, bold, and font colors.
- The WPF GridView font availability cache now recognizes the installed Windows `ARIALN.TTF` font as `Arial Narrow`, giving `Aptos Narrow` themed workbooks a narrow local fallback when Office's `Aptos Narrow` family is not visible through WPF.
- Loaded PivotTables that share a cache now apply each PivotTable's own `StyleName` rather than inheriting the first style seen for the shared cache.
- The modeled modern Office palettes now match the corpus for `PivotStyleMedium2` and `PivotStyleDark3`: Medium2 renders as the blue Excel style, while Dark3 renders as the orange/brown Excel style.
- Loaded native PivotTables with wrapped report filters now use the native pivot `TargetRange` and `firstDataRow` offsets for header styling instead of shifting the style footprint below page fields that already live outside the native pivot location.
- `PivotStyleMedium5` and `PivotStyleMedium6` keep their modern Office header/subtotal treatment but no longer fill grand-total rows, matching the report-filter and date-grouping corpus cases.

## Evidence

Visual evidence folder:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-native-layoutfilters-20260623`

Baseline:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-styleoffset-pageguard-20260622`

Command shape:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release --no-restore
dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- <workbook.xlsx> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out <case-output> --threshold 25 --pixel-tolerance 8
```

## Visual Delta

| Workbook | Previous diff | Current diff | Delta | Previous changed>8 | Current changed>8 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Excel_native_pivot_basic_row_column_001.xlsx` | 7.5% | 7.2% | -0.3 | 28.48% | 28.28% |
| `Excel_native_pivot_calculated_field_item_003.xlsx` | 3.7% | 3.5% | -0.2 | 30.60% | 30.00% |
| `Excel_native_pivot_date_grouping_003.xlsx` | 10.5% | 9.9% | -0.6 | 39.48% | 33.45% |
| `Excel_native_pivot_filters_sorts_002.xlsx` | 4.5% | 4.3% | -0.2 | 42.70% | 42.39% |
| `Excel_native_pivot_grouping_show_values_001.xlsx` | 5.2% | 5.0% | -0.2 | 48.29% | 48.72% |
| `Excel_native_pivot_layout_options_002.xlsx` | 9.0% | 8.9% | -0.1 | 70.65% | 70.55% |
| `Excel_native_pivot_multiple_pivots_one_cache_001.xlsx` | 5.6% | 3.0% | -2.6 | 58.04% | 29.77% |
| `Excel_native_pivot_report_filters_001.xlsx` | 8.8% | 4.5% | -4.3 | 53.13% | 27.02% |
| `Excel_native_pivot_slicer_timeline_001.xlsx` | 5.4% | 5.2% | -0.2 | 35.73% | 35.71% |
| `Excel_native_pivot_table_source_filters_001.xlsx` | 4.5% | 4.4% | -0.1 | 32.80% | 33.11% |

All ten cases still match Excel PNG dimensions exactly.

## Remaining Disparities

The corpus is not at 100% visual fidelity. The largest remaining normalized diffs are:

- `Excel_native_pivot_layout_options_002.xlsx`: 8.9%.
- `Excel_native_pivot_date_grouping_003.xlsx`: 9.9%.
- `Excel_native_pivot_basic_row_column_001.xlsx`: 7.2%.

The remaining side-by-side images still show text rasterization/weight differences, PivotTable element style gaps such as subtotal/group/total fills and borders, and native control chrome differences for PivotTable buttons, slicers, and timelines. The shared-cache style/palette issue is no longer one of the leading deltas.

## Verification

Focused tests run in this slice:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotTableRefreshServiceTests --logger "trx;LogFileName=pivot-palette-tests.trx" --verbosity minimal
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter "FullyQualifiedName~GridViewTextDecorationTests|FullyQualifiedName~GridViewThemeFontResolutionTests" --logger "trx;LogFileName=pivot-font-fallback-tests.trx" --verbosity minimal
```

Results:

- PivotTable focused core tests: 148 passed, 1 skipped.
- GridView text/font focused UI tests: 42 passed.
