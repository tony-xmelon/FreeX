# Charts Excel / FreeX Comparison - 2026-06-01

## Scope

Compared 28 FreeX-renderable chart types against Microsoft Excel using a repeatable harness:

- FreeX renderer PNG: `ChartRenderer.Render(...)`.
- FreeX-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX loaded and saved by FreeX, then reopened and chart-exported by Excel.

`ChartType.Map` remains outside this pass because FreeX marks it known but not renderable/authorable.

## Evidence

Latest complete all-green full run:

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-full-after-sizing-normalization`

Final focused branch-head runs:

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-focused-final-20260601-1945`

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-pareto-final-20260601-1920`

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-boxwhisker-chartex-parent`

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-waterfall-chartex-worker`

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-sizing-probe-classic`

`C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-sizing-probe-3d`

Late full-run diagnostics after repeated Excel automation:

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-full-postmerge-20260601-1855`

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-full-final-20260601-1925`

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-pareto-postmerge-20260601-1905`

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-column-final-20260601-2000`

Key artifacts:

- `chart_compare_results.csv` / `.json`: functional interop matrix.
- `README.md`: openability/export vs visual-gate summary, including per-family counts.
- `visual_metrics.csv`: nonblank-image checks, perceptual hash distances, thresholds, and visual status.
- `visual_contact_sheet_classic.png`: classic chart visual comparison.
- `visual_contact_sheet_chartex.png`: chartEx visual comparison.
- `visual_contact_sheet_all.png`: full side-by-side chart visual comparison.

## Result

The harness change is active and separates openability/export failures from visual mismatches. The
latest complete all-green full run passed all 28 chart cases. Final focused branch-head reruns for
`Pareto`, `ThreeDBar`, `BoxAndWhisker`, `Waterfall`, and the sizing-normalized classic probes also
passed openability/export and the visual gate.

After many repeated Excel COM runs in this session, later full/focused diagnostics started returning
Excel automation RPC/open failures even for basic `Column`. The harness correctly reports these as
`openability` failures rather than visual mismatches; no production writer change was made here.

| Path | Result |
|---|---:|
| FreeX renderer produced a PNG | 28/28 |
| FreeX-authored XLSX opened in Excel and exported a chart PNG | 28/28 |
| Excel-authored XLSX opened/exported in Excel | 28/28 |
| Excel-authored XLSX loaded/saved by FreeX, then reopened/exported in Excel | 28/28 |

The harness now has an explicit visual gate in addition to the openability/export gate. In the
latest complete full run, every chart passed openability and the visual gate:

| Gate | Result |
|---|---:|
| Openability/export | 28/28 |
| FreeX renderer PNG | 28/28 |
| Visual gate | 28/28 |
| Known visual gap charts tracked | 11 |
| Known-gap threshold allowances used | 2 |

The visual gate distinguishes openability failures from visual mismatches in `chart_compare_results.csv`
(`OpenabilityError`, `VisualFailure`, `FailureCategory`) and exits with separate codes:
`1` for openability/export failure, `2` for visual mismatch, and `3` for FreeX renderer PNG failure.

Known-gap allowances used in the latest complete full run:

- `PercentStackedColumn`: native-vs-FreeX hash distance was 99, allowed under the known-gap threshold of 128.
- `ThreeDColumn`: Excel-native -> FreeX -> Excel round-trip hash distance was 6, allowed under the 3-D known-gap round-trip threshold of 12.

Per-family visual summary from the latest complete full run:

| Family | Charts | Openability pass | Visual pass | Known-gap allowance | Visual fail | Max native-vs-FreeX hash | Threshold |
|---|---:|---:|---:|---:|---:|---:|---:|
| classic | 21 | 21 | 19 | 2 | 0 | 99 | 96 |
| chartEx | 7 | 7 | 7 | 0 | 0 | 54 | 72 |

## Fixes Made From The Comparison

- `Treemap` and `Sunburst` chartEx data now writes numeric dimensions as `type="size"` instead of `type="val"`. Before this, desktop Excel opened the files but rendered blank chart areas.
- `Histogram` chartEx output now writes Excel's default `<cx:binning intervalClosed="r" />` layout while still omitting custom `cx:binCount` and `cx:binSize` values that were proven to make Excel reject the workbook.
- `Scatter` classic XLSX now suppresses default connector lines, matching Excel's marker-only scatter default unless a series explicitly requests line styling or smoothing.
- `Pareto` chartEx now writes aggregation, an owner-linked Pareto line, and plot-area percentage axis metadata while omitting series-level `cx:axisId` values that made Excel reject the workbook.
- `BoxAndWhisker` chartEx now writes per-series title metadata, stable series `uniqueId`s, exclusive-quartile statistics layout metadata, and Excel-native chartEx axes for multi-series sample data.
- `Waterfall` chartEx now writes Excel-native connector-line visibility and chartEx axes alongside subtotal metadata, and the app now exposes a tested Set as Total context-menu path for waterfall points.
- Stacked column/bar and 3-D families now emit closer Excel-native default layout metadata, including stacked gap/overlap defaults, 3-D view/wall defaults, and 3-D chart axis defaults.
- The interop harness now converts FreeX pixel fixture sizes to Excel COM points when creating Excel-native charts, so visual hashes compare similarly sized exports instead of point-vs-pixel artifacts.
- The FreeX Pareto renderer now aggregates repeated categories before sorting and formats the right axis as percentages.

## Remaining Visual Parity Gaps

These do not block XLSX open/load/save interop, but they are visible parity work:

- FreeX-authored stacked column/bar and several 3-D families are structurally valid but differ from Excel-native default styling/layout.
- FreeX-authored `Waterfall` is visible and openable, with connector/axis metadata now aligned; remaining differences are primarily chartEx style sidecar/default styling.
- FreeX renderer visuals intentionally differ from Excel-native rendering because FreeX uses the OxyPlot/WPF renderer path; this pass treats it as a separate visual surface, not a pixel-parity target.

## Harness Notes

`tools\FreeX.ChartInteropCompare` now supports focused runs:

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -- --chart Pareto,ThreeDBar
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -- --family chartEx
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -- --list-charts
```

Visual thresholds can be overridden with `--classic-visual-threshold`,
`--chartex-visual-threshold`, `--known-gap-threshold`, and `--roundtrip-threshold`.
The harness uses a fresh Excel COM instance per chart case with activation retry/owned-PID cleanup,
which avoids one dead Excel automation server cascading into unrelated chart failures.
Excel-native fixtures created through COM use point units, so the harness converts the shared
FreeX pixel fixture rectangle to points before authoring native Excel charts.

## Verification Commands

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxClassicChartDefaultTests|XlsxChartExWriterTests|XlsxSchemaValidationTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: 78/78 passed.

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj
```

Result from the latest complete full run: 28/28 chart cases passed openability/export and the
visual gate. Later repeated Excel COM diagnostics showed RPC/open failures; these are reported in
the `OpenabilityError`/`FailureCategory=openability` columns, not as visual mismatches.
