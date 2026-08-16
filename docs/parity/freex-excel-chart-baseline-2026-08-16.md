# FreeX Excel chart reference expansion — 2026-08-16

The Excel COM baseline now includes eight current-source chart references in addition to the existing chart and PivotTable ranges. Microsoft Excel generated the fixtures and exported the `A1:N25` ranges; `FreeX.SheetGridImageCompare` rendered the same ranges through the WPF `GridView` and wrote the committed metrics.

| Chart family | Mean pixel delta | Exact mean delta | Changed pixels (> 8) |
| --- | ---: | ---: | ---: |
| Clustered column | 4.6054% | 6.5207% | 16.9581% |
| Clustered bar | 4.3169% | 6.1073% | 15.9015% |
| Line with markers | 1.4467% | 2.0948% | 10.0225% |
| Pie | 3.9083% | 5.5270% | 16.8347% |
| Area | 4.1760% | 5.8864% | 15.9919% |
| XY scatter | 0.9341% | 1.4135% | 9.3700% |
| 3-D clustered column | 5.6197% | 7.9280% | 19.6191% |
| 3-D clustered bar | 4.3749% | 6.1819% | 16.4974% |

All eight comparisons passed the existing 25% mean-delta discovery threshold with equal Excel/FreeX image dimensions. These are diagnostic range comparisons, not a visual-parity claim; 3-D charts are the highest-delta chart family in this set and should be reviewed first when tightening the threshold.

The authoritative PNGs and per-case metrics are in `docs/parity/freex-excel-com-baseline-2026-08-14/native-chart-corpus/`. The aggregate manifest has 38 Excel reference artifacts: nine chart ranges and 29 PivotTable ranges.

## Reproduction

From an interactive Windows desktop with Excel installed:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke --configuration Release -- --generate-excel-chart-corpus-fixtures --out C:\Users\<user>\freex-excel-baseline
dotnet run --project tools/FreeX.SheetGridImageCompare --configuration Release -- C:\Users\<user>\freex-excel-baseline\generated-excel-chart\Excel_native_chart_column_001.xlsx --capture-range A1:N25 --export-excel-pngs --out C:\Users\<user>\freex-excel-baseline\visual\Excel_native_chart_column_001 --threshold 25
```

Repeat the comparison command for each generated workbook. The fixture generator and range exporter use Excel COM and do not need foreground input. By contrast, `tools/screenshot_excel.ps1` requires foreground ownership for ribbon, menu, and native-dialog capture. Its 2026-08-16 refresh attempt correctly stopped before capture because this desktop session did not expose a foreground window; no UI reference was promoted from that attempt.
