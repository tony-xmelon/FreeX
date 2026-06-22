# PivotTable Group Fidelity Pass - 2026-06-22

## Scope

This pass covers local MS Excel vs FreeX PivotTable visual parity for grouped/date rows in the native Excel-authored corpus. External connections, Data Model, and OLAP remain explicitly out of scope for the active PivotTable parity goal.

## Fixes

- Imported XLSX alignment indentation into `CellStyle.IndentLevel`, preserving native worksheet `alignment indent="..."` on already-rendered Excel PivotTable row labels.
- Added a host-side PivotTable row-label adornment planner for compact grouped rows. The planner identifies expanded parent rows from the imported row-label indentation and emits render targets for the GridView.
- Added a GridView render layer for Excel-like PivotTable expand/collapse boxes and reserved label text padding so parent text does not overlap the box.
- Wired the adornment planner through both the live WPF viewport and `FreeX.SheetGridImageCompare`.
- Materialized compact grouped parent-row styling during loaded PivotTable style application so expanded native grouped rows receive the PivotTable group fill/font treatment.

## Evidence

Visual corpus output:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-group-fidelity-20260622c`

Focused fixture:

- `Excel_native_pivot_date_grouping_003.xlsx`
- Before this pass: 11.3% mean visual diff in the native corpus baseline.
- After expand/collapse, indentation import, and grouped parent styling: 10.5% mean visual diff.
- Render/export/dimension failures: 0.

Full 10-workbook native PivotTable corpus after this pass:

| Workbook | Mean diff |
| --- | ---: |
| `Excel_native_pivot_basic_row_column_001` | 8.5% |
| `Excel_native_pivot_calculated_field_item_003` | 6.1% |
| `Excel_native_pivot_date_grouping_003` | 10.5% |
| `Excel_native_pivot_filters_sorts_002` | 4.7% |
| `Excel_native_pivot_grouping_show_values_001` | 5.3% |
| `Excel_native_pivot_layout_options_002` | 10.3% |
| `Excel_native_pivot_multiple_pivots_one_cache_001` | 5.6% |
| `Excel_native_pivot_report_filters_001` | 8.7% |
| `Excel_native_pivot_slicer_timeline_001` | 5.7% |
| `Excel_native_pivot_table_source_filters_001` | 5.3% |

## Remaining Non-External Gaps

- Text metrics and antialiasing still dominate several PivotTable visual diffs.
- PivotTable style granularity is still approximate for specific built-in style elements such as grand-total border-only rows and exact grouped-row color ramps.
- Field-button chrome and slicer/timeline chrome remain approximate rather than pixel-identical.
