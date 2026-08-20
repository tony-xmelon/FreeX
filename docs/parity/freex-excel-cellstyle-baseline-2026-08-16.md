# FreeX Excel native cell-style reference expansion — 2026-08-16

This iteration adds seven Excel COM-generated range references for visible grid formatting. Each fixture was exported by Microsoft Excel from `A1:E20`, then rendered through FreeX's WPF `GridView` using the same range. The fixtures extend the Office baseline beyond charts and PivotTables without requiring foreground ribbon or dialog automation.

| Surface family | Mean pixel delta | Exact mean delta | Changed pixels (> 8) |
| --- | ---: | ---: | ---: |
| Border styles | 5.3927% | 6.9105% | 17.0653% |
| Diagonal borders | 1.5674% | 2.5054% | 11.8491% |
| Pattern fills | 5.8582% | 9.4306% | 26.9141% |
| Gradient fills | 3.9564% | 6.6370% | 25.7948% |
| Alignment and rotation | 4.1447% | 6.9478% | 16.7223% |
| Merged cells | 3.2273% | 4.2951% | 14.7616% |
| Fonts | 6.2425% | 7.2131% | 19.9971% |

All seven comparisons passed the existing 25% mean-delta discovery gate at equal image dimensions. They are diagnostic range comparisons, not a visual-parity claim. The 2026-08-20 refresh was generated from current source commit `adbeb8542843eff41a93308f18edda4726cc8421` and uses fresh Excel COM references. The gradient renderer repair reduces the gradient-fills mean delta from the stale 16.8261% result to 3.9564%; fonts are now the highest mean-delta cell-style family at 6.2425%.

The authoritative Excel PNGs and per-case metrics are in `docs/parity/freex-excel-com-baseline-2026-08-14/native-cellstyle-corpus/`. The aggregate Office manifest now contains 45 artifacts: nine chart ranges, seven cell-style ranges, and 29 PivotTable ranges.

## Reproduction

From a Windows desktop with Excel installed:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke --configuration Release -- --generate-excel-cellstyle-corpus-fixtures --out C:\Users\<user>\freex-excel-baseline
dotnet run --project tools/FreeX.SheetGridImageCompare --configuration Release -- C:\Users\<user>\freex-excel-baseline\generated-excel-cellstyle\Excel_native_cellstyle_fills_gradient_004.xlsx --capture-range A1:E20 --export-excel-pngs --out C:\Users\<user>\freex-excel-baseline\visual\Excel_native_cellstyle_fills_gradient_004 --threshold 25
```

Repeat the comparison command for each generated workbook. The fixture generator and range exporter use Excel COM only; they do not require a foreground Excel window.
