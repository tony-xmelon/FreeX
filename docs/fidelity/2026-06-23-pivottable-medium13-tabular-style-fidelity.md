# PivotTable Medium13 tabular style fidelity - 2026-06-23

Scope: Windows-only local PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain explicitly out of scope.

## Completed in this slice

- Improved loaded native `PivotStyleMedium13` rendering for tabular PivotTables.
- Added an optional body-border color to the built-in PivotTable style palette and applied it to Medium13 body/stripe style surfaces.
- Styled loaded tabular outer row-field labels as Excel does for repeated first row-field labels: bold text, stripe fill, and the Medium13 body grid rule.
- Added focused loaded-style regression coverage for Medium13 tabular outer row labels, striped value cells, and non-striped body cells.

Excel COM `DisplayFormat` inspection was used as supporting evidence for the visual style layer. The final acceptance signal remains the `FreeX.SheetGridImageCompare` Excel `CopyPicture` visual comparison.

## Visual evidence

Focused evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\focused
```

Full 16-case evidence:

```text
C:\Users\ali\freex-xlsx-verify\visual\pivot-loaded-style-text-20260623\full
```

The full run compared all 16 native PivotTable cases with 0 failed rows and 0 dimension mismatches.

Targeted improvements versus the compact-label baseline:

| Case | Fallback mean before | Fallback mean after | Exact mean before | Exact mean after | Changed pixels before | Changed pixels after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `layout_options_002` | 6.6075% | 6.4298% | 12.1284% | 12.0053% | 73.89% | 73.82% |
| `layout_matrix_004` | 4.8190% | 4.7904% | 11.7024% | 11.6374% | 40.75% | 40.77% |

No other corpus entry moved meaningfully.

Current ranked full-corpus metrics:

| Case | Fallback mean diff | Exact mean diff | Changed pixels | Dimension mismatches |
| --- | ---: | ---: | ---: | ---: |
| `subtotal_grand_totals_004` | 7.2025% | 8.0647% | 31.88% | 0 |
| `layout_options_002` | 6.4298% | 12.0053% | 73.82% | 0 |
| `date_grouping_003` | 6.4129% | 8.8561% | 19.84% | 0 |
| `show_items_no_data_004` | 6.1368% | 8.2908% | 18.66% | 0 |
| `named_range_source_004` | 5.9830% | 14.3672% | 48.26% | 0 |
| `basic_row_column_001` | 5.4726% | 12.3692% | 23.29% | 0 |
| `chrome_style_flags_004` | 5.4038% | 14.6442% | 58.03% | 0 |
| `layout_matrix_004` | 4.7904% | 11.6374% | 40.77% | 0 |
| `table_source_filters_001` | 4.3522% | 13.2684% | 33.92% | 0 |
| `grouping_show_values_001` | 4.1474% | 10.5120% | 47.92% | 0 |
| `report_filters_001` | 3.6842% | 10.3939% | 23.45% | 0 |
| `filters_sorts_002` | 3.2170% | 11.9698% | 36.27% | 0 |
| `show_values_as_variants_004` | 2.5840% | 9.8219% | 22.70% | 0 |
| `slicer_timeline_001` | 2.3562% | 8.3122% | 38.54% | 0 |
| `calculated_field_item_003` | 2.1645% | 9.4053% | 24.77% | 0 |
| `multiple_pivots_one_cache_001` | 1.9556% | 7.2527% | 22.22% | 0 |

## Verification

Focused style regression:

```powershell
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotLoadedStyleApplicationTests --logger "trx;LogFileName=pivot-loaded-style-text-tests.trx" --verbosity minimal
```

Outcome: 4 passed, 0 failed.

Full native PivotTable visual corpus:

```powershell
dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- <native-pivot-workbook> --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --threshold 100 --pixel-tolerance 8 --out <case-output>
```

Outcome: 16 compared cases, 0 failed rows, 0 dimension mismatches.

## Reverted experiment

An attempted `PivotStyleMedium12` grand-total fill/border adjustment was rejected because it worsened `subtotal_grand_totals_004` from 7.2025% to 7.3813% fallback mean diff. The patch was removed before integration.

## Remaining gaps

FreeX is still not at 100% local PivotTable visual fidelity. The next highest-impact non-external targets are:

- `subtotal_grand_totals_004`: text weight/rasterization, subtotal/grand-total chrome, and field-button details.
- `date_grouping_003`: compact date-grouping geometry/text and button chrome.
- `show_items_no_data_004` and `named_range_source_004`: loaded native style/chrome and typography differences.
- `layout_options_002`: still dominated by font rasterization, field-button chrome, and residual grid/fill details after the Medium13 row-label/body-grid improvement.
