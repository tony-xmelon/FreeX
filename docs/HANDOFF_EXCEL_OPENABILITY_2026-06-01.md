# Handoff - Excel-openability and chart parity follow-ups (2026-06-01)

This handoff started after real Microsoft Excel verification found two P0 XLSX issues where
FreeX-authored workbooks did not open at all. Those blockers are now fixed and merged to `main`.
Keep this document as the compact current-state handoff for future chart/XLSX lanes.

## Current status

- **Partner Dashboard source-package openability is now verified.** The real workbook
  `E:\Users\anton\Documents\Melon\Kin+Carta\Partner Dashboard 20250116.xlsx` now loads in FreeX,
  saves through FreeX, and opens in desktop Excel without repair/rejection. The verified FreeX
  output is
  `C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-codex-normalizer-r4\freex-saved\Partner Dashboard 20250116-freex-saved.xlsx`.
  OpenXML validation for that output reported `errors=0`.
- **Loaded source-package custom views are intentionally removed on save.** Fresh modeled custom
  views remain supported, but source `customWorkbookViews` and worksheet `customSheetViews` are
  dropped in the source-package compatibility repair path because the Partner investigation proved
  those native view blocks can make Excel reject otherwise valid workbooks.
- **Corrupt source-package pivot cache metadata is repaired conservatively.** When a pivot cache has
  more `cacheField` entries than its worksheet source range can support, FreeX writes a refreshable
  skeleton pivot cache/table tied to the original source range instead of preserving an Excel-
  rejected native payload. This prioritizes opening the workbook in Excel over retaining corrupt
  pivot layout XML.
- **P0 Excel openability is resolved for the chart parity matrix.** The latest full harness run at
  `C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-threedcolumn-caveat-final-main-sync-full`
  passed 28/28 chart cases for FreeX renderer PNG output, FreeX-authored XLSX opened/exported by
  Excel, Excel-authored XLSX opened/exported by Excel, and Excel-authored XLSX loaded/saved by
  FreeX then reopened/exported by Excel.
- **Visual gate is green without chart-specific allowances.** The same run passed 28/28 visual
  gates, reported 0 known-gap charts, used 0 known-gap threshold allowances, and confirmed 28/28
  Excel-native -> FreeX -> Excel round-trip XLSX packages are byte-identical to the Excel-native
  packages.
- **The former `ThreeDColumn` caveat is now covered by package-identity evidence.** Focused
  verification showed the Excel-native and FreeX round-tripped `ThreeDColumn.xlsx` packages are
  byte-identical while repeated Excel chart PNG export can still differ by pHash distance 6. The
  harness records `NativeRoundTripXlsxByteIdentical=true` and treats that raster-only drift as an
  Excel export repeatability artifact, not a FreeX writer/openability bug.
- **chartEx package parity is verified for the current supported families.** Histogram, Waterfall,
  Treemap, Sunburst, Pareto, Funnel, and Box-and-Whisker now open/export in Excel and pass the
  visual gate. The focused chartEx run
  `20260601-chartex-native-style-201-known-gap-clean` passed 7/7 openability/export and 7/7 visual
  gate with 0 chartEx known gaps.

## Completed fixes

- Source-package saves now run an Excel compatibility normalizer that removes stale calc-chain
  references when repairs are applied, removes duplicate worksheet drawing relationships pointing
  at the same drawing part, converts phone-like invalid formula text such as `+389 78 609-030` to
  literal text, prunes missing content type overrides, and repairs internally inconsistent pivot
  cache/table packages.
- The Excel open smoke tool now has representative FreeX-authored feature fixtures covering
  formulas, data validation, conditional formatting, tables, links/comments, images/sparklines,
  shapes/text boxes, and protection/page setup, plus an enriched Excel-authored fixture for
  FreeX->Excel validation.
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
- `tools/FreeX.ChartInteropCompare` now records byte-identical Excel-native/FreeX-round-trip XLSX
  packages and passes those cases without a chart-specific visual allowance when repeated Excel PNG
  export has minor raster drift.

## Verification evidence

Partner Dashboard:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --no-build -- --freex-resave-before-excel --out "C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-codex-normalizer-r4" "E:\Users\anton\Documents\Melon\Kin+Carta\Partner Dashboard 20250116.xlsx"
```

Result: 1/1 passed. FreeX source load: 27 sheets, 56,958 cells, 16,863 formulas. Excel open:
28 worksheets, 124 worksheet shapes.

```powershell
dotnet run --project "$env:TEMP\freex-openxml-validator" -- "C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-codex-normalizer-r4\freex-saved\Partner Dashboard 20250116-freex-saved.xlsx"
```

Result: `errors=0`.

Feature smoke:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --no-build -- --save-reopen --generate-freex-feature-fixtures --out "C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-feature-fixtures-r2"
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --no-build -- --save-reopen --generate-excel-fixture --out "C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-excel-authored-r2"
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --no-build -- --save-reopen --generate-chart-fixtures --out "C:\Users\anton\freex-xlsx-verify\excel-smoke\20260603-chart-fixtures-r2"
```

Result: FreeX feature fixtures 7/7 passed, Excel-authored fixture 1/1 passed, chart fixtures
2/2 passed.

Core IO regression suite:

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: 1,767/1,767 passed.

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
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -- --out C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-threedcolumn-caveat-final-main-sync-full
```

Result: 28/28 openability/export, 28/28 FreeX renderer PNG, 28/28 visual gate, 0 known-gap charts,
0 known-gap threshold allowances, and 28/28 byte-identical Excel-native/FreeX-round-trip packages.

## Remaining follow-ups

1. Keep the chart harness green as future XLSX writer or renderer changes land; treat a new Excel
   openability failure as P0.
2. Preserve the package-identity guard in `tools/FreeX.ChartInteropCompare` so repeated Excel PNG
   export variance stays separate from package/openability regressions.
3. Continue broader XLSX corpus proof and manual desktop Excel open/save/reopen sampling outside
   the 28-chart parity matrix.
4. Finish product polish that is separate from openability: full chart format panes/dialogs, deeper
   per-family style controls, and any future Map chart product scope.

## Historical note

The original version of this handoff listed chartEx openability as the highest-priority blocker.
That is now complete; use [CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md](CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md)
for the detailed comparison matrix and artifact paths.
