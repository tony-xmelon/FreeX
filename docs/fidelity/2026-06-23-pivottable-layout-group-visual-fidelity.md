# PivotTable Layout And Group Visual Fidelity - 2026-06-23

This pass continued the local, Windows-only PivotTable parity goal against desktop Microsoft Excel. External connections, Data Model pivots, and OLAP pivots remain explicitly out of scope.

## Scope

- Regenerated the native Excel-authored PivotTable corpus through `tools/FreeX.ExcelOpenSmoke` with local MS Excel.
- Re-ran `tools/FreeX.SheetGridImageCompare` in `--pivot-sheet-ranges --export-excel-pngs` mode against all ten non-external native PivotTable fixtures.
- Tightened two visual gaps in the loaded native PivotTable renderer:
  - Tabular/outline repeated parent labels now reserve the expand/collapse gutter even on repeated sibling rows where Excel aligns the label text but draws no extra button.
  - `PivotStyleMedium6` compact grouped parent rows now use Excel's stronger modern Office accent5 fill (`RGB(216,109,205)`) without changing ordinary subtotal or grand-total behavior.
- Corrected `tools/FreeX.SheetGridImageCompare` target-dimension rendering so the FreeX WPF render is scaled exactly once when matching an Excel reference PNG. The old path applied both scaled DPI and a `ScaleTransform`, which inflated captured grid geometry.
- Corrected explicit `--pivot-sheet-ranges` captures so they no longer add the whole-sheet/drawing safety padding or the generic 200x100 minimum viewport. The exported FreeX PivotTable range now uses the exact Excel-detected range while full-sheet captures still keep their padding.

## Evidence

Workbook corpus:

- `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-layout-next-20260623\generated-excel-pivots`
- Excel open/save/reopen smoke result: 10/10 passed.

Visual evidence:

- Baseline same-fixture layout comparison from `main`: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-main-baseline-20260623\layout-options`
- Current full visual run: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-next-20260623\full-after-medium6`
- Corrected scale-once visual run: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-next-20260623\full-after-scale-once`
- Corrected exact-range visual run: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-geometry-next-20260623\full-after-exact-range`

Measured improvements before the scale correction:

- `Excel_native_pivot_layout_options_002`: 9.0% baseline on `main`, 8.8% after repeated-label gutter reservation.
- `Excel_native_pivot_date_grouping_003`: 9.9% before the Medium6 grouped-parent fill fix, 8.9% after.

Those old percentages are not directly comparable to the corrected harness because the FreeX reference render was being scaled twice. With scale-once rendering, the geometry is visibly more truthful: the date-grouping value column is no longer clipped, and the layout-options `Grand Total` column remains inside the captured range.

Full-corpus visual diffs after scale-once rendering, before exact-range sizing:

| Fixture | Visual diff |
| --- | ---: |
| Basic row/column | 8.8% |
| Calculated field/item | 3.5% |
| Date grouping | 11.5% |
| Filters/sorts | 5.1% |
| Grouping/show values | 5.9% |
| Layout options | 9.0% |
| Multiple pivots one cache | 3.9% |
| Report filters | 6.3% |
| Slicer/timeline | 4.2% |
| Table source filters | 7.0% |

Current full-corpus visual diffs after exact range sizing:

| Fixture | Visual diff |
| --- | ---: |
| Basic row/column | 5.8% |
| Calculated field/item | 2.2% |
| Date grouping | 7.5% |
| Filters/sorts | 3.3% |
| Grouping/show values | 4.4% |
| Layout options | 6.9% |
| Multiple pivots one cache | 2.0% |
| Report filters | 3.7% |
| Slicer/timeline | 3.3% |
| Table source filters | 4.4% |

All ten native PivotTable fixtures rendered with exact FreeX/Excel PNG dimensions and `Errors: 0`.

## Remaining Gaps

FreeX is not yet at 100% visual fidelity for native PivotTables. The remaining largest diffs are dominated by row height, text metrics, and column-width mapping rather than missing PivotTable semantics:

- Date grouping is down to 7.5%, but still differs in text rasterization and row height.
- Layout options is down to 6.9%, but still differs in row height, text weight, and column-width distribution.
- Basic row/column is down to 5.8%, with remaining variance primarily from text weight/rasterization and bold fallback behavior.

Next work should target GridView row-height/font metrics and column-width-to-pixel mapping under Excel `CopyPicture` evidence before making additional style-specific palette changes.
