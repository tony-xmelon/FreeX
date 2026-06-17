# Chart deferred follow-up — combo legend, band gap, single-cell stacked bar

Date: 2026-06-17
Scope: chart RENDERING + minimal chart-IO fidelity only (no GridView / form-control / non-chart
IO touched). Branch: isolated worktree off `main`.

Harness: `tools/FreeX.ExcelExamplesCharts` run with `--no-excel` (Excel ground-truth PNGs captured
separately). Re-render: `dotnet run --project tools/FreeX.ExcelExamplesCharts -c Release --no-build
-- "<workbook.xlsx>" "<outDir>" --no-excel` (writes FreeX PNGs to `<outDir>/freex/`).

Picks up the three items left as "Deferred" in:
- `docs/fidelity/2026-06-17-contextures-chart-visual.md` §Deferred (file 04 legend + band gap)
- `docs/fidelity/2026-06-15-ExcelExamples1-findings.md` §5.3 (todo StackedBar renders blank)

All three are now FIXED. Renders converge to the Excel ground truth.

---

## 1. Combo legend wrongly listed "T_Low" — file 04 `04_charts_target-range.xlsx`

Excel ground truth (`…/ctx-charts/04_charts_target-range/excel/Chart_Target_01.png`): legend shows
**Target + Qty** only (the transparent spacer T_Low is hidden).

### Root cause
chart1.xml declares the series **out of idx order**: declaration order is T_Low (idx 1, col D),
Target (idx 2, col E), Qty (idx 0, col B — the combo line). The chart XML carries
`<c:legendEntry><c:idx val="0"/><c:delete val="1"/></c:legendEntry>`. That `idx` is the
**legend-position index** = the order the series are DECLARED (position 0 = first declared = T_Low),
NOT the series' own `<c:idx>`. FreeX's `IsLegendEntryDeleted` matched the entry idx directly against
the series chart-XML idx, so it tried to delete idx 0 = Qty (which it didn't render as a column
anyway), leaving T_Low visible.

### Fix
- New model field `ChartModel.SeriesPlotOrder` (`src/FreeX.Core.Model/ChartModel.cs`): the series
  chart-XML indexes in DECLARATION order. Populated in `XlsxChartPartReader.Bar.cs` for every series
  loop (combo bar/line/scatter + plain bar) as each `<c:ser>` is read.
- `IsLegendEntryDeleted` (`src/FreeX.App.UI/ChartRenderer.SeriesFormatting.cs`) now resolves the
  legend-entry idx through `SeriesPlotOrder` (position → series idx) when it is populated; when empty
  (the legacy single-plot-group case, e.g. bullet-chart helper series where declaration order equals
  idx order) it falls back to the direct series-idx match — so bullet charts are unaffected.
- Applied the legend-delete check in the stacked column/bar builders' bar titles
  (`ChartRenderer.Stacked.cs`) and centralized it in `CreateLineSeries` so deleted combo-line series
  are hidden too.

### Result
Legend now shows **Qty + Target** only; T_Low (spacer) is hidden. Matches Excel.

---

## 2. Combo band drawn as columns with wide gaps — file 04 (same chart)

Excel: the pale-yellow band is **continuous** across categories (barChart `gapWidth=0`).
FreeX drew narrow columns with white gaps because the stacked-column builder hardcoded a
±0.35 half-width.

### Fix
- The stacked column AND stacked bar builders (`ChartRenderer.Stacked.cs`) now use
  `ColumnBarHalfWidth(chart)` (which derives the half-width from `BarGapWidth`) instead of the
  hardcoded 0.35. With no explicit gapWidth this still yields 0.35, so ordinary stacked charts are
  unchanged.
- `ColumnBarHalfWidth` ceiling raised from 0.49 → 0.5 so `gapWidth=0` makes adjacent category bars
  touch exactly (Excel's continuous look). The default (no gapWidth) path is untouched.

### Result
The band is now fully continuous (no inter-category white seams). Matches Excel.

---

## 3. `todo` StackedBar rendered BLANK — `ExcelExamples1.xlsx` sheet *todo*, chart20.xml

Excel ground truth (`…/deferred-gt/todo_chart1.png`): a single ~45% horizontal progress bar on a
0–100% axis.

### Root cause
chart20 is a stacked bar of **12 single-cell series** (`todo!$J$4 … $J$15`, each `ptCount=1`, NO
`<c:cat>`). The union `DataRange` collapses to one column (J) × 12 rows with **0 categories**, so the
normal stacked-bar builder skips every point (`i >= categories.Count == 0`) → blank. A second,
hidden defect: the value axis `<c:valAx>` has a fixed `min=0/max=1` (the 0–100% scale), but for
bar-direction charts the axis reader stored that on `YAxis*` while the sanitizer wipes `YAxis*`
bounds for bars (`SupportsYAxisBounds(Bar)==false`) — so even once the bar drew, it auto-scaled to
0..0.45 and looked full-width.

### Fix (two bounded changes)
- **Synthesis** (`ChartRenderer.cs` + `ChartRenderer.Stacked.cs`): detect the exact shape via
  `IsSingleColumnStackedSeriesShape` — stacked bar/column, 0 categories, a single data column
  (`dataStartCol == endCol`), >1 row, and an authoritative `SeriesColumnMappings` with >1 series all
  pointing at that one column. When matched, `BuildSingleColumnStackedModel` synthesizes one stacked
  segment per data row in a single synthetic category, so the segments stack to their sum
  (0.30 + 0.15 = 0.45). Gated tightly so normal multi-column bar/column charts are unaffected.
- **Value-axis bounds** (`src/FreeX.Core.IO/XlsxChartAxisReader.cs`): for bar-direction charts
  (Bar/StackedBar/PercentStackedBar/ThreeDBar) the value axis scaling (min/max/units/log/numFmt) is
  now routed to the **X-axis** bounds — where the renderer (value axis at the bottom) and the
  sanitizer (`SupportsXAxisBounds(Bar)==true`) already expect it. Previously it went to Y and was
  silently dropped. The synthesized builder applies these bounds to its value axis. (General
  improvement: any bar chart with a fixed value axis now honors it; before, none did.)

### Result
The todo chart now renders a single ~45% horizontal bar on a 0–100% axis (FreeX uses the direct
fallback renderer for this very-short/no-legend chart; it now honors the 0..1 value axis). Matches
the Excel progress-bar ground truth. Harness `visibly-blank` count for ExcelExamples1 went 1 → 0.

---

## Files changed
- `src/FreeX.Core.Model/ChartModel.cs` — new `SeriesPlotOrder`.
- `src/FreeX.Core.IO/XlsxChartPartReader.Bar.cs` — populate `SeriesPlotOrder` (declaration order).
- `src/FreeX.Core.IO/XlsxChartAxisReader.cs` — route bar value-axis scaling to X.
- `src/FreeX.App.UI/ChartRenderer.SeriesFormatting.cs` — legend-position-aware `IsLegendEntryDeleted`;
  `ColumnBarHalfWidth` ceiling 0.5.
- `src/FreeX.App.UI/ChartRenderer.Stacked.cs` — gapWidth-aware stacked half-width; legend-delete on
  bar titles; single-column stacked progress-bar synthesis (`IsSingleColumnStackedSeriesShape`,
  `BuildSingleColumnStackedModel`).
- `src/FreeX.App.UI/ChartRenderer.cs` — dispatch synthesized progress-bar; centralized legend-delete
  in `CreateLineSeries`.
- Tests: `tests/FreeX.App.UI.Tests/ChartRendererTests.DeferredFollowup.cs` (new) — legend-position
  delete + positional fallback; band gapWidth honored + default unaffected; single-cell synthesis +
  normal multi-column unaffected; value-axis bounds honored.

## Verification
- `dotnet build FreeX.slnx -c Release` — see end of session report.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — see report.
- `tests/FreeX.App.UI.Tests` (chart tests live here, not in DefaultTests): 730 passed, 27 skipped,
  0 failed.
- Re-rendered file 04 and ExcelExamples1 todo via the harness `--no-excel`; both converge to the
  Excel ground truth (continuous band + 2-entry legend; ~45% progress bar on 0–100% axis).
