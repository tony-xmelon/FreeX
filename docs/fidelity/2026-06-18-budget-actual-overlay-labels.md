# Budget-vs-Actual chart: deviation overlay + range data labels (2026-06-18)

Workbook: `ExcelExamples1.xlsx`, sheet **Budget v Actual**, main chart
"Budget vs. Actual Performance" (`xl/charts/chart2.xml`).
Ground truth: `gaps-gt/bva_1.png` (Excel COM export, captured earlier).

## What the chart actually is (chart2.xml)

A combo chart:

- `<c:barChart grouping="clustered">` — two column series, **Budget** (idx 0, light
  grey) and **Actual** (idx 1, grey). FreeX already rendered these correctly via the
  prior `ClusteredBarOffsets` work.
- `<c:lineChart>` — two *invisible* line series ("Budget Line" idx 2, "Actual Line"
  idx 3), both `<a:ln><a:noFill/>` with `marker symbol="none"`. They carry the same
  Budget / Actual values and exist only to host:
  - `<c:upDownBars>` — the **deviation bars**. `upBars` fill = `accent6` (green,
    Actual > Budget), `downBars` fill = `accent4` (blue, Actual < Budget).
  - per-point **data labels** whose text comes from `c15:datalabelsRange`
    (`'Budget v Actual'!$H$6:$H$14` and `$I$6:$I$14`) — cached strings like
    `👎 30%`, `👍 10%`, `👌 0%`, `👍👍 42%`. The numeric `showVal` flags are all 0,
    so the *only* visible label text is the literal range text.

## What FreeX dropped before this change

1. **Deviation bars** — not drawn at all. `<c:upDownBars>` colors *were* already read
   into the model (`ApplyChartGuideLineMetadata` sets `ShowUpDownBars` + up/down fills),
   but nothing in the renderer drew them outside the Stock/candlestick path.
2. **Emoji + percent labels** — `c15:datalabelsRange` was never read; the model had no
   place to hold literal label text, and the renderer's data-label path only formats the
   numeric value (which is suppressed here by `showVal=0`).

The two invisible line series collapse onto the same two data columns (C, D) the bars
already use, so FreeX's column-scan renderer never materialized them — that is fine,
because they are `noFill` and would not be visible anyway. The deviation overlay and
labels are therefore computed directly from the two clustered **bar** series' values.

## Implementation

- **Model** (`ChartModel.Support.cs`, `ChartModel.cs`): new
  `record ChartRangeDataLabel(SeriesIndex, PointIndex, Text)` and
  `ChartModel.RangeDataLabels`. (upDownBars fields already existed.)
- **IO** (`XlsxChartDataLabelReader.ApplyRangeDataLabels`): reads
  `series/extLst/ext/c15:datalabelsRange/c15:dlblRangeCache/c:pt/c:v`; wired into the
  combo line-series loop in `XlsxChartPartReader.Bar.cs`.
- **Renderer** (`ChartRenderer.DeviationOverlay.cs`): the Column path now captures each
  clustered bar series' per-category values; after the loop:
  - `AddDeviationOverlay` draws a thin (`half-width ≈ 0.06`) `RectangleBarSeries`
    centered on each category, spanning `min(Budget,Actual)..max(Budget,Actual)`,
    colored green when Actual > Budget else blue (resolved from the model's up/down
    fills, with accent6/accent4 fallbacks). Zero-deviation categories draw nothing.
  - `AddRangeDataLabelAnnotations` draws the literal range text as a `TextAnnotation`
    just above the taller of the two columns per category.
  - Both are no-ops unless the respective model data is present, so plain clustered
    columns are unaffected.

## Before / after (FreeX render vs Excel ground truth)

- **Before** (`bva-out/freex/Budget_v_Actual_01.png`): clustered Budget/Actual columns
  only — no deviation bars, no labels.
- **After** (`bva-out2/freex/Budget_v_Actual_01.png`): deviation bars present and
  correctly sign-colored — blue at A (30%) and H (27%) where Actual < Budget, green at
  B/D/E/F/G/I where Actual > Budget, nothing at C (0%). Percent labels (30%, 5%, 0%, 4%,
  7%, 10%, 13%, 27%, 42%) float above each category, matching `bva_1.png` positions and
  values.

### Approximation / deferred

- **Emoji rendering**: the 👎/👍/👌 glyphs render via the default WPF/OxyPlot font as
  **monochrome** glyphs rather than Excel's full-color emoji. The percent text and the
  emoji code points are present and correct; only the colored emoji bitmap is not
  reproduced (OxyPlot text has no color-font/emoji support). The deviation bars carry the
  same up/down semantics, so the sign cue is conveyed by both color and emoji.
- **Bar geometry**: Excel positions the up/down bar in the gap *between* the two columns;
  FreeX centers it on the category center (the same gap), which reads identically at chart
  scale. Exact Excel up/down-bar width/positioning semantics are approximated with a slim
  category-centered bar driven by `UpDownBarGapWidth`.

## Verification

- `dotnet build FreeX.slnx -c Release` — succeeded, 0 warnings/errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — all assemblies pass,
  0 failed (e.g. Core.IO 2627, Core.Model 3969, App.Host.Logic 1558, App.Avalonia 430).
- `dotnet test tests/FreeX.App.UI.Tests --no-build` — 738 passed / 0 failed / 27 skipped,
  including 3 new `ChartRendererTests.DeviationOverlay` tests (sign-colored deviation bars,
  range-label text present, no overlay without upDownBars).
