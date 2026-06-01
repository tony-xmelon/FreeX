# Charts Excel / FreeX Comparison - 2026-06-01

## Scope

Compared 28 FreeX-renderable chart types against Microsoft Excel using a repeatable harness:

- FreeX renderer PNG: `ChartRenderer.Render(...)`.
- FreeX-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX loaded and saved by FreeX, then reopened and chart-exported by Excel.

`ChartType.Map` remains outside this pass because FreeX marks it known but not renderable/authorable.

## Evidence

Latest run:

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-165656`

Key artifacts:

- `chart_compare_results.csv` / `.json`: functional interop matrix.
- `visual_contact_sheet_classic.png`: classic chart visual comparison.
- `visual_contact_sheet_chartex.png`: chartEx visual comparison.
- `visual_metrics.csv`: nonblank-image and perceptual hash-distance metrics.

## Result

Functional interop passed for all 28 tested chart types.

| Path | Result |
|---|---:|
| FreeX renderer produced a PNG | 28/28 |
| FreeX-authored XLSX opened in Excel and exported a chart PNG | 28/28 |
| Excel-authored XLSX opened/exported in Excel | 28/28 |
| Excel-authored XLSX loaded/saved by FreeX, then reopened/exported in Excel | 28/28 |

The Excel-to-FreeX-to-Excel visual path is effectively preserved: round-trip image hash distance was 0 for nearly every chart, with only tiny 3-D chart differences observed (`ThreeDColumn` distance 1, `ThreeDBar` distance 2 on a 16x16 average-hash scale).

## Fixes Made From The Comparison

- `Treemap` and `Sunburst` chartEx data now writes numeric dimensions as `type="size"` instead of `type="val"`. Before this, desktop Excel opened the files but rendered blank chart areas.
- `Histogram` chartEx output now writes Excel's default `<cx:binning intervalClosed="r" />` layout while still omitting custom `cx:binCount` and `cx:binSize` values that were proven to make Excel reject the workbook.

## Remaining Visual Parity Gaps

These do not block XLSX open/load/save interop, but they are visible parity work:

- FreeX-authored `Scatter` exports as a connected/multiseries-looking chart in Excel rather than Excel's default marker-only scatter.
- FreeX-authored stacked column/bar and several 3-D families are structurally valid but differ from Excel-native default styling/layout.
- FreeX-authored `Pareto` is visible but not Excel-equivalent: Excel-native uses aggregation, an owner-linked Pareto line, and secondary percentage axis metadata that FreeX does not fully model yet.
- FreeX-authored `BoxAndWhisker` is visible but not Excel-equivalent for multi-column sample data; Excel-native uses per-series statistics layout metadata.
- FreeX renderer visuals intentionally differ from Excel-native rendering because FreeX uses the OxyPlot/WPF renderer path; this pass treats it as a separate visual surface, not a pixel-parity target.

## Verification Commands

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxChartExWriterTests|XlsxSchemaValidationTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: 54/54 passed.

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj
```

Result: 28/28 chart cases passed functional interop.
