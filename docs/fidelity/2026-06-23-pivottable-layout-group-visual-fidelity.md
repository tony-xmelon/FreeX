# PivotTable Layout And Group Visual Fidelity - 2026-06-23

This pass continued the local, Windows-only PivotTable parity goal against desktop Microsoft Excel. External connections, Data Model pivots, and OLAP pivots remain explicitly out of scope.

## Scope

- Regenerated the native Excel-authored PivotTable corpus through `tools/FreeX.ExcelOpenSmoke` with local MS Excel.
- Re-ran `tools/FreeX.SheetGridImageCompare` in `--pivot-sheet-ranges --export-excel-pngs` mode against all ten non-external native PivotTable fixtures.
- Tightened two visual gaps in the loaded native PivotTable renderer:
  - Tabular/outline repeated parent labels now reserve the expand/collapse gutter even on repeated sibling rows where Excel aligns the label text but draws no extra button.
  - `PivotStyleMedium6` compact grouped parent rows now use Excel's stronger modern Office accent5 fill (`RGB(216,109,205)`) without changing ordinary subtotal or grand-total behavior.

## Evidence

Workbook corpus:

- `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-layout-next-20260623\generated-excel-pivots`
- Excel open/save/reopen smoke result: 10/10 passed.

Visual evidence:

- Baseline same-fixture layout comparison from `main`: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-main-baseline-20260623\layout-options`
- Current full visual run: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-next-20260623\full-after-medium6`

Measured improvements on the regenerated corpus:

- `Excel_native_pivot_layout_options_002`: 9.0% baseline on `main`, 8.8% after repeated-label gutter reservation.
- `Excel_native_pivot_date_grouping_003`: 9.9% before the Medium6 grouped-parent fill fix, 8.9% after.

Current full-corpus visual diffs after this pass:

| Fixture | Visual diff |
| --- | ---: |
| Basic row/column | 7.2% |
| Calculated field/item | 3.5% |
| Date grouping | 8.9% |
| Filters/sorts | 4.3% |
| Grouping/show values | 5.0% |
| Layout options | 8.8% |
| Multiple pivots one cache | 3.0% |
| Report filters | 4.5% |
| Slicer/timeline | 5.2% |
| Table source filters | 4.4% |

## Remaining Gaps

FreeX is not yet at 100% visual fidelity for native PivotTables. The remaining largest diffs are dominated by grid geometry and text metrics rather than missing PivotTable semantics:

- Layout options still renders wider/taller than Excel, pushing the rightmost `Grand Total` column and last rows out of the captured viewport.
- Date grouping now matches the group-row fill more closely, but still differs in text rasterization, row height, and value-column clipping.
- Basic row/column is primarily text weight/rasterization and bold fallback variance.

Next work should target GridView row-height/font metrics and column-width-to-pixel mapping under Excel `CopyPicture` evidence before making additional style-specific palette changes.
