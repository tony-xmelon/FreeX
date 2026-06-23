# PivotTable corpus gap handoff - 2026-06-23

Scope: Windows-only local/native PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Expanded the Excel-authored native PivotTable corpus from 10 to 16 workbooks.
- Added local PivotTable coverage for:
  - show items with no data (`pivotField@showAll` plus table-level `showEmptyRow`)
  - compact / outline / tabular layout matrix
  - subtotal and grand-total permutations, including bottom subtotal placement
  - named-range source pivots via `NativeSalesRange`
  - additional Show Values As variants (`% of column`, running total by Month)
  - field chrome and pivot style option flags
- Added schema guard assertions in `ExcelOpenSmokeReportSchemaTests` so the new corpus names, generator methods, and key COM/XML hooks stay discoverable.
- Worked around an Office COM automation gap for `ShowItemsWithNoDataOnRows`: Excel authors the workbook, then the generator patches `xl/pivotTables/pivotTable1.xml` to add `showEmptyRow="1"`. This keeps the fixture Excel-authored while exercising the table-level flag FreeX uses for no-data materialization.

## Evidence

Generated and save/reopen validated the full expanded corpus:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-gaps-20260623b
```

Outcome: `PASS: Excel validated 16/16 workbook(s)`.

Built and ran the full visual comparison lane:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

Then each generated workbook was compared with:

```powershell
FreeX.SheetGridImageCompare.exe <workbook.xlsx> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out <case-output> --threshold 25 --pixel-tolerance 8
```

Evidence root:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-gaps-20260623b\full
```

Visual outcome: 16/16 cases exited `0`; every case has exact Excel-vs-FreeX PNG dimensions.

| Case | Diff | Exact dimensions | Exact pixel metrics |
| --- | ---: | --- | --- |
| `subtotal_grand_totals_004` | 8.7% | 747x530 | mean 9.691%, changed>8 50.61% |
| `show_items_no_data_004` | 7.9% | 512x482 | mean 10.602%, changed>8 39.31% |
| `date_grouping_003` | 7.0% | 371x218 | mean 9.572%, changed>8 22.34% |
| `layout_options_002` | 6.6% | 713x314 | mean 12.128%, changed>8 73.89% |
| `named_range_source_004` | 6.1% | 654x218 | mean 14.580%, changed>8 50.90% |
| `basic_row_column_001` | 5.6% | 610x218 | mean 12.578%, changed>8 25.93% |
| `chrome_style_flags_004` | 5.4% | 719x218 | mean 14.716%, changed>8 58.93% |
| `layout_matrix_004` | 5.0% | 1380x458 | mean 12.096%, changed>8 42.27% |
| `table_source_filters_001` | 4.4% | 740x194 | mean 13.352%, changed>8 34.97% |
| `grouping_show_values_001` | 4.2% | 685x218 | mean 10.718%, changed>8 50.49% |
| `report_filters_001` | 3.7% | 681x194 | mean 10.449%, changed>8 23.95% |
| `filters_sorts_002` | 3.2% | 671x146 | mean 12.026%, changed>8 36.36% |
| `show_values_as_variants_004` | 2.6% | 1010x218 | mean 9.979%, changed>8 24.91% |
| `slicer_timeline_001` | 2.4% | 1490x338 | mean 8.333%, changed>8 38.93% |
| `calculated_field_item_003` | 2.2% | 1427x266 | mean 9.563%, changed>8 27.03% |
| `multiple_pivots_one_cache_001` | 2.0% | 914x194 | mean 7.321%, changed>8 23.11% |

Focused checks already run before this handoff:

```powershell
dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --configuration Release
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~ExcelOpenSmokeReportSchemaTests --logger "trx;LogFileName=pivottable-corpus-schema-tests.trx" --verbosity minimal
```

Both passed.

## Outstanding work

- The expanded visual lane proves exact range dimensions, not pixel-perfect PivotTable fidelity. The largest remaining visual diffs are now `subtotal_grand_totals_004` (8.7%), `show_items_no_data_004` (7.9%), `date_grouping_003` (7.0%), and `layout_options_002` (6.6%).
- The no-data fixture now exercises table-level row expansion. A future product-level regression should assert both `pivotTableDefinition@showEmptyRow` and field-level `pivotField@showAll` semantics in model refresh tests.
- The Show Values As fixture covers `% of column` and running total. Future corpus growth should add difference-from, percent-difference-from, rank ascending/descending, index, and parent-row/parent-column variants.
- Report filter visuals still only have the existing page-field arrangement; future growth should add `(All)`, single-select, multi-select, and alternate wrap/order combinations in one dedicated fixture.
- The pixel differences remain dominated by text ink/typography, style fill/header details, and subtotal/no-data layout styling. The previous medium-weight Aptos/Calibri fallback experiment was byte-identical in sampled renders, so it was discarded.
- External connections, Data Model, and OLAP remain excluded from this parity goal.
