# Handoff - Excel-openability and chart parity follow-ups (2026-06-01)

This handoff started after real Microsoft Excel verification found two P0 XLSX issues where
FreeX-authored workbooks did not open at all. Those blockers are now fixed and merged to `main`.
Keep this document as the compact current-state handoff for future chart/XLSX lanes.

## Current status

- **P0 Excel openability is resolved for the chart parity matrix.** The latest full harness run at
  `C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-final-current-main-full-chart-parity`
  passed 28/28 chart cases for FreeX renderer PNG output, FreeX-authored XLSX opened/exported by
  Excel, Excel-authored XLSX opened/exported by Excel, and Excel-authored XLSX loaded/saved by
  FreeX then reopened/exported by Excel.
- **Visual gate is green.** The same run passed 28/28 visual gates. The only caveat allowance is
  `ThreeDColumn` Excel-native -> FreeX -> Excel round-trip chart-export raster variance: pHash
  distance 6 against the strict threshold 4, allowed under the dedicated 3-D column threshold 12.
- **The remaining `ThreeDColumn` caveat is not an XLSX package/openability bug.** Cicero's
  read-only package audit showed the native and round-tripped `ThreeDColumn.xlsx` files are
  byte-identical, with SHA-256
  `27F042F3716F9FFA9CA0C90893DCC2AECE3F920704DC8957FA733038451FC7FB`; all 17 package parts,
  including `xl/charts/chart1.xml`, `xl/charts/style1.xml`, `xl/charts/colors1.xml`, drawings,
  relationships, styles, theme, and docProps match by name, size, CRC, and per-entry SHA.
- **chartEx package parity is verified for the current supported families.** Histogram, Waterfall,
  Treemap, Sunburst, Pareto, Funnel, and Box-and-Whisker now open/export in Excel and pass the
  visual gate. The focused chartEx run
  `20260601-chartex-native-style-201-known-gap-clean` passed 7/7 openability/export and 7/7 visual
  gate with 0 chartEx known gaps.

## Completed fixes

- Theme output now emits valid `theme1.xml` `fontScheme`/`fmtScheme` content, unblocking plain
  workbooks.
- Classic charts now emit valid title/axis rich text, line chart grouping, worksheet drawing order,
  and package relationships.
- chartEx charts now emit the required chart color/style sidecars, drawing wrapper, relationships,
  content types, native style profile `id="201"`, and native color style `id="10"`.
- Pareto chartEx writes aggregation, an owner-linked Pareto line, and plot-area percentage-axis
  metadata while avoiding Excel-rejected series-level axis ids.
- Box-and-Whisker chartEx writes multi-series title metadata, stable unique ids, exclusive-quartile
  statistics, and Excel-native chartEx axes.
- Waterfall chartEx writes connector visibility, axes, and subtotal metadata; the app has a tested
  Set as Total context-menu path.
- Treemap/Sunburst chartEx data uses `type="size"` numeric dimensions; Histogram writes Excel's
  default binning shape.
- Classic stacked and percent-stacked column/bar defaults run without known-gap allowances; FreeX
  percent-stacked renderer axes now use Excel-compatible positive-only, mixed, and negative-only
  bounds.
- 3-D classic chart cleanup removed invalid `c:serAx` from 3-D column/bar while preserving the
  series axis for 3-D surface; 3-D bar/line/pie/area/surface no longer need known-gap allowances.
- `tools/FreeX.ChartInteropCompare` separates openability/export failures, FreeX renderer failures,
  and visual mismatches, and normalizes FreeX pixel fixture sizes to Excel COM point sizes for
  native authoring.

## Verification evidence

Focused tests:

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxClassicChartDefaultTests|XlsxChartExWriterTests|XlsxSchemaValidationTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --no-restore
```

Result: 79/79 passed.

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --filter "FullyQualifiedName~PercentStackedRenderer" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --no-restore
```

Result: 6/6 passed.

Full interop harness:

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -- --out C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-final-current-main-full-chart-parity
```

Result: 28/28 openability/export, 28/28 FreeX renderer PNG, 28/28 visual gate, one caveat
threshold allowance used for `ThreeDColumn` raster variance.

## Remaining follow-ups

1. Keep the chart harness green as future XLSX writer or renderer changes land; treat a new Excel
   openability failure as P0.
2. Keep `ThreeDColumn` documented as an Excel chart-export raster variance unless a future run
   shows package XML/relationship drift.
3. Continue broader XLSX corpus proof and manual desktop Excel open/save/reopen sampling outside
   the 28-chart parity matrix.
4. Finish product polish that is separate from openability: full chart format panes/dialogs, deeper
   per-family style controls, and any future Map chart product scope.

## Historical note

The original version of this handoff listed chartEx openability as the highest-priority blocker.
That is now complete; use [CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md](CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md)
for the detailed comparison matrix and artifact paths.
