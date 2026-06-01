# Charts Excel / FreeX Comparison - 2026-06-01

## Scope

Compared 28 FreeX-renderable chart types against Microsoft Excel using a repeatable harness:

- FreeX renderer PNG: `ChartRenderer.Render(...)`.
- FreeX-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX opened and chart-exported by desktop Excel COM.
- Excel-authored XLSX loaded and saved by FreeX, then reopened and chart-exported by Excel.

`ChartType.Map` remains outside this pass because FreeX marks it known but not renderable/authorable.

## Evidence

Latest post-main-sync run:

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-full-postmerge-20260601-1855`

Focused reproduction for the current `Pareto` openability failure:

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-pareto-postmerge-20260601-1905`

Last all-green run before syncing the latest local `main` into the harness branch:

`C:\Users\anton\freex-xlsx-verify\chart-interop\worker6-full-20260601-1835`

Key artifacts:

- `chart_compare_results.csv` / `.json`: functional interop matrix.
- `README.md`: openability/export vs visual-gate summary, including per-family counts.
- `visual_metrics.csv`: nonblank-image checks, perceptual hash distances, thresholds, and visual status.
- `visual_contact_sheet_classic.png`: classic chart visual comparison.
- `visual_contact_sheet_chartex.png`: chartEx visual comparison.
- `visual_contact_sheet_all.png`: full side-by-side chart visual comparison.

## Result

The harness change is active and separates openability/export failures from visual mismatches.
After syncing the latest local `main`, functional interop currently has one openability failure:
FreeX-authored `Pareto` fails desktop Excel `Workbooks.Open` with
`Unable to get the Open property of the Workbooks class`. This is outside the harness-owned
surface and was not repaired here.

| Path | Result |
|---|---:|
| FreeX renderer produced a PNG | 28/28 |
| FreeX-authored XLSX opened in Excel and exported a chart PNG | 27/28 |
| Excel-authored XLSX opened/exported in Excel | 28/28 |
| Excel-authored XLSX loaded/saved by FreeX, then reopened/exported in Excel | 28/28 |

The harness now has an explicit visual gate in addition to the openability/export gate. In the
latest post-main-sync full run, every chart that passed openability also passed the visual gate:

| Gate | Result |
|---|---:|
| Openability/export | 27/28 |
| FreeX renderer PNG | 28/28 |
| Visual gate | 27/27 evaluated |
| Known visual gap charts tracked | 14 |
| Known-gap threshold allowances used | 1 |

The visual gate distinguishes openability failures from visual mismatches in `chart_compare_results.csv`
(`OpenabilityError`, `VisualFailure`, `FailureCategory`) and exits with separate codes:
`1` for openability/export failure, `2` for visual mismatch, and `3` for FreeX renderer PNG failure.

Known-gap allowance used in the latest post-main-sync run:

- `ThreeDBar`: Excel-native -> FreeX -> Excel round-trip hash distance was 8, allowed under the 3-D known-gap round-trip threshold of 12.

The pre-main-sync all-green run also used a `Pareto` known-gap visual allowance
(`native-vs-FreeX` hash distance 83 under the chartEx known-gap threshold of 128), but the current
post-main-sync `Pareto` FreeX-authored workbook does not open far enough for visual evaluation.

Per-family visual summary from the latest post-main-sync run:

| Family | Charts | Openability pass | Visual pass | Known-gap allowance | Visual fail | Max native-vs-FreeX hash | Threshold |
|---|---:|---:|---:|---:|---:|---:|---:|
| classic | 21 | 21 | 20 | 1 | 0 | 89 | 96 |
| chartEx | 7 | 6 | 6 | 0 | 0 | 65 | 72 |

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

## Verification Commands

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxChartExWriterTests|XlsxSchemaValidationTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: 54/54 passed.

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj
```

Result after syncing latest local `main`: 27/28 chart cases passed openability/export; 27/27
evaluated chart cases passed the visual gate. `Pareto` is a current openability failure, not a
visual mismatch.
