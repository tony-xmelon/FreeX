# Chart Excel-Parity — Findings & Fixes

Date: 2026-06-13
Branch: `chart-excel-parity-20260613` (off `main`)

## Method

Charts are a mature feature. `tools/FreeX.ChartInteropCompare` drives real Excel
(en-US C# COM path) and visually hashes 28 chart types against FreeX. A full run
(`dotnet run --project tools/FreeX.ChartInteropCompare -c Release -- --out <dir>`)
showed **28/28 pass openability + visual gate**, `KnownGaps` empty.

Critical distinction confirmed this pass: the gate metric `HashDistanceNativeVsFreeXXlsx`
compares **Excel-rendering-FreeX's-saved-XLSX vs Excel-native** — i.e. *file* fidelity,
both rendered by Excel. FreeX's own **renderer** output is the contact sheet's
**column 1** (`png-freex-renderer`). Renderer-only changes do not move the gate hash;
verify them on the contact sheet.

## Fixed (committed)

1. **Trendline curves** (`326dbd5fc`) — exponential/logarithmic/power trendlines
   returned only 2 endpoints, so the renderer drew them as straight chords. They now
   sample the fitted curve (`SampleTrendCurve`), rendering smooth curves like Excel.
2. **Excel series palette** (`145dafbc4`) — the renderer used OxyPlot's green-first
   default palette. `PlotModel.DefaultColors` is now built from the workbook Office
   theme accents (Accent1..Accent6 + tint rounds); pie/doughnut/treemap/sunburst/funnel
   slices use the same palette. Verified on contact-sheet column 1: column/bar are now
   blue-first and pies multi-colored, matching Excel. (FreeX's default theme is the
   modern Office theme, Accent1 = #156082.)
3. **Exp/power R² on the log-linearized fit** (`506036920`) — Excel reports
   exponential/power trendline R² from the `ln y` regression, not original-scale
   residuals. `TryCalculateRSquared` gained a `logTransformY` flag set for those types.

## Residual file-fidelity gaps (within tolerance, actionable)

A FreeX vs Excel-native chart XML diff of a clustered **Column** chart (FreeX 2890 B
vs Excel 8188 B; gate hash 88 / threshold 96) found FreeX omits, relative to Excel
native:

- **`<c:gapWidth val="219"/>` and `<c:overlap val="-27"/>`** for clustered bar/column.
  FreeX writes neither when `BarGapWidth`/`BarOverlap` are null, so Excel falls back to
  the OOXML schema defaults (150 / 0), making FreeX's clustered bars wider and touching
  vs Excel's UI defaults (219 / −27). Fix: writer emits 219/−27 for clustered bar/column
  when null, AND extend `NormalizeExcelNativeDefaultBarGapWidth/Overlap`
  (`XlsxChartPartReader.Bar.cs`, currently stacked-only) to normalize clustered 219/−27
  → null for round-trip stability. Guard existing chart round-trip/schema tests.
- **`<c:majorGridlines/>` on the value axis** — Excel's default column chart shows
  horizontal major gridlines; FreeX's `ShowYAxisMajorGridlines` defaults false, so the
  written chart has none. Matching Excel means defaulting value-axis major gridlines on
  for the families Excel does (column/bar/line/area) — broad: affects the renderer and
  many tests, so do it deliberately.
- **`<c:txPr>` axis text properties, `roundedCorners`, `dispBlanksAs`, `plotVisOnly`,
  `autoTitleDeleted`** — minor chart-level elements Excel always writes.
- **`colors1.xml` + `style1.xml`** chart style parts — Excel native classic charts
  include the color-mapping and chart-style parts; FreeX emits neither for classic
  charts. A larger feature (emit `cs:colorStyle`/`cs:chartStyle` parts + content types
  + rels), parallel to the chartEx style-parts work.

These all *pass* the visual gate today; closing them would tighten the file-fidelity
hash distances (Column 88, Bar 70, ThreeDColumn/ThreeDSurface 68) further.

## Other residual

- Exp/power trendline R² is now log-space (fixed). Logarithmic/linear/polynomial keep
  original-scale R² (correct — y is not transformed for those).
