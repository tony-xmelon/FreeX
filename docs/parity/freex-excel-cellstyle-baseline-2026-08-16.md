# FreeX Excel native cell-style reference expansion — 2026-08-16

This iteration adds seven Excel COM-generated range references for visible grid formatting. Each fixture was exported by Microsoft Excel from `A1:E20`, then rendered through FreeX's WPF `GridView` using the same range. The fixtures extend the Office baseline beyond charts and PivotTables without requiring foreground ribbon or dialog automation.

| Surface family | Mean pixel delta | Exact mean delta | Changed pixels (> 8) |
| --- | ---: | ---: | ---: |
| Border styles | 4.8666% | 6.1377% | 14.4972% |
| Diagonal borders | 1.6302% | 2.5873% | 11.4247% |
| Pattern fills | 5.7151% | 9.1584% | 25.2491% |
| Gradient fills | 16.8261% | 27.7198% | 34.3390% |
| Alignment and rotation | 3.8740% | 6.3755% | 15.0426% |
| Merged cells | 2.8906% | 3.7673% | 12.2435% |
| Fonts | 5.3788% | 6.1060% | 17.5014% |

All seven comparisons passed the existing 25% mean-delta discovery gate at equal image dimensions. They are diagnostic range comparisons, not a visual-parity claim. Gradient fills are now the highest-priority FreeX grid-formatting discrepancy in the committed native cell-style set: 16.8261% mean delta and 34.3390% changed pixels.

The authoritative Excel PNGs and per-case metrics are in `docs/parity/freex-excel-com-baseline-2026-08-14/native-cellstyle-corpus/`. The aggregate Office manifest now contains 45 artifacts: nine chart ranges, seven cell-style ranges, and 29 PivotTable ranges.

## Reproduction

From a Windows desktop with Excel installed:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke --configuration Release -- --generate-excel-cellstyle-corpus-fixtures --out C:\Users\<user>\freex-excel-baseline
dotnet run --project tools/FreeX.SheetGridImageCompare --configuration Release -- C:\Users\<user>\freex-excel-baseline\generated-excel-cellstyle\Excel_native_cellstyle_fills_gradient_004.xlsx --capture-range A1:E20 --export-excel-pngs --out C:\Users\<user>\freex-excel-baseline\visual\Excel_native_cellstyle_fills_gradient_004 --threshold 25
```

Repeat the comparison command for each generated workbook. The fixture generator and range exporter use Excel COM only; they do not require a foreground Excel window.
