# Chart Fidelity Corpus Coverage

**Date:** 2026-06-21

## Scope

This pass closed the deterministic generated-corpus coverage gap for renderable chart types and verified the installed Microsoft Excel chart comparison harness on Windows. The Linux-vs-Windows lane remains out of scope for this session; this note covers Windows-only FreeX/Excel parity.

## Corpus Coverage

The generated supported-pass corpus now includes deterministic workbook rows for every renderable `ChartType` except `Map`, which remains intentionally non-renderable and covered by known-gap warning/retention tests.

- `generated-charts-classic-extended-004` covers percent-stacked column, stacked bar, percent-stacked bar, 3D column, 3D bar, 3D area, 3D line, and 3D pie.
- `generated-charts-chartex-004` covers treemap, sunburst, histogram, Pareto, box-and-whisker, waterfall, and funnel.
- `XlsxCorpusRunnerTests.GeneratedSupportedChartRows_CoverEveryRenderableChartTypeExceptMap` gates generated supported-pass chart rows against `ChartTypeSupport.IsRenderable()`.

Together with the existing generated chart rows, the corpus now exercises `Column`, `StackedColumn`, `PercentStackedColumn`, `ThreeDColumn`, `Line`, `ThreeDLine`, `Pie`, `ThreeDPie`, `Doughnut`, `Bar`, `StackedBar`, `PercentStackedBar`, `ThreeDBar`, `Scatter`, `Bubble`, `Area`, `ThreeDArea`, `Radar`, `Stock`, `Surface`, `ThreeDSurface`, `Treemap`, `Sunburst`, `Histogram`, `Pareto`, `BoxAndWhisker`, `Waterfall`, and `Funnel`.

## Excel Visual Comparison

The current Windows Excel comparison harness is `tools/FreeX.ChartInteropCompare`. It synthesizes chart cases, renders FreeX PNGs, saves FreeX-authored XLSX files, asks desktop Excel to open/export them, asks Excel to author/open/export its native versions, and then validates the FreeX round-trip path back through Excel.

Baseline run before the corpus expansion:

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -c Release -- --out C:\Users\ali\freex-xlsx-verify\chart-interop\baseline-20260621-225215
```

Result:

- Openability/export gate: 28/28 passed.
- Visual gate: 28/28 evaluated and passed.
- Known-gap chart allowances used: 0.

Final run after corpus expansion and IO fixes:

```powershell
dotnet run --project tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj -c Release -- --out C:\Users\ali\freex-xlsx-verify\chart-interop\final-20260621-230803
```

Result:

- Openability/export gate: 28/28 passed.
- Visual gate: 28/28 evaluated and passed.
- Known-gap chart allowances used: 0.

Focused Office corpus smoke for the two new rows:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --freex-resave-before-excel --generate-supported-corpus-fixtures --corpus-manifest test-corpus\manifest.csv --corpus-id generated-charts-classic-extended-004 --corpus-id generated-charts-chartex-004 --out C:\Users\ali\freex-xlsx-verify\excel-smoke\chart-corpus-20260621-230724
```

Result:

- Excel save/reopen gate: 2/2 passed.
- Classic extended row: 8/8 charts survived FreeX save, Excel open/save/reopen, and FreeX reload.
- ChartEx row: 7/7 charts survived FreeX save, Excel open/save/reopen, and FreeX reload.

## Disparities Resolved

- 3D pie authoring could write `c:firstSliceAng` under `c:pie3DChart`, which the Open XML SDK rejects as schema-invalid. The writer now omits that invalid child for 3D pie charts, and a focused schema-ordering test covers the path.
- Desktop Excel can emit duplicate `xdr:cNvPr id="0"` values inside `mc:Fallback` placeholder shapes when saving ChartEx drawings. The smoke validator now treats that as an Excel-saved fallback-shape quirk only, without relaxing FreeX-authored package validation.

Active chart visual disparities found after fixes: 0.

## Remaining Work

No renderer or XLSX chart IO disparity remains after this pass. The next useful fidelity increment is not a known fix; it is a corpus-driven visual comparison mode that can feed generated and real workbook chart sheets through the same Excel PNG comparison path instead of relying only on synthetic cases.
