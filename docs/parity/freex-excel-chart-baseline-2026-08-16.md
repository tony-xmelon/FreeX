# FreeX Excel chart reference expansion — 2026-08-16

The Excel COM baseline now includes eight current-source chart references in addition to the existing chart and PivotTable ranges. Microsoft Excel generated the fixtures and exported the `A1:N25` ranges; `FreeX.SheetGridImageCompare` rendered the same ranges through the WPF `GridView` and wrote the committed metrics.

| Chart family | Mean pixel delta | Exact mean delta | Changed pixels (> 8) |
| --- | ---: | ---: | ---: |
| Clustered column | 4.6330% | 6.6030% | 17.8742% |
| Clustered bar | 4.3988% | 6.2557% | 17.0091% |
| Line with markers | 1.5010% | 2.2132% | 10.5887% |
| Pie | 3.9906% | 5.7009% | 17.9276% |
| Area | 4.2136% | 5.9992% | 16.9771% |
| XY scatter | 0.9972% | 1.5069% | 9.8754% |
| 3-D clustered column | 3.9103% | 5.5648% | 16.5419% |
| 3-D clustered bar | 3.0061% | 4.3087% | 14.4527% |

All eight comparisons passed the existing 25% mean-delta discovery threshold with equal Excel/FreeX image dimensions. These are diagnostic range comparisons, not a visual-parity claim. The 2026-08-20 refresh was generated from current source commit `adbeb8542843eff41a93308f18edda4726cc8421` and uses fresh Excel COM references. The 3-D renderer repair reduces the 3-D column mean delta from the stale 5.6197% result to 3.9103% and the 3-D bar mean delta from 4.3749% to 3.0061%.

The authoritative PNGs and per-case metrics are in `docs/parity/freex-excel-com-baseline-2026-08-14/native-chart-corpus/`. The aggregate manifest has 45 Excel reference artifacts: nine chart ranges, seven cell-style ranges, and 29 PivotTable ranges.

## Reproduction

From an interactive Windows desktop with Excel installed:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke --configuration Release -- --generate-excel-chart-corpus-fixtures --out C:\Users\<user>\freex-excel-baseline
dotnet run --project tools/FreeX.SheetGridImageCompare --configuration Release -- C:\Users\<user>\freex-excel-baseline\generated-excel-chart\Excel_native_chart_column_001.xlsx --capture-range A1:N25 --export-excel-pngs --out C:\Users\<user>\freex-excel-baseline\visual\Excel_native_chart_column_001 --threshold 25
```

Repeat the comparison command for each generated workbook. The fixture generator and range exporter use Excel COM and do not need foreground input. By contrast, `tools/screenshot_excel.ps1` requires foreground ownership for ribbon, menu, and native-dialog capture. Its 2026-08-16 refresh attempt correctly stopped before capture because this desktop session did not expose a foreground window; no UI reference was promoted from that attempt.
