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

## File-fidelity work (from a FreeX vs Excel-native Column chart XML diff)

FreeX's clustered Column `chart1.xml` (2890 B) vs Excel native (8188 B) omitted:

4. **gapWidth/overlap for clustered bar/column — FIXED (`240ec9219`).** FreeX emitted
   neither for clustered Column/Bar, so Excel fell back to schema defaults (150/0) vs
   Excel's 219/−27. The writer now emits 219/−27 for clustered (it already did for
   stacked), the reader normalizes those defaults back to null (round-trip-safe), and a
   latent inversion was corrected (stacked overlap stays −27, *verified* against Excel
   native output; gapWidth=219 for every grouping). Empirically dropped the **Bar**
   file-fidelity hash 70→61; Column stayed ~88 (its gap is dominated by gridlines below;
   perceptual hash also has ±2 run-to-run noise from Excel re-rendering).

## Residual file-fidelity gaps (within tolerance)

- **Value-axis `<c:majorGridlines/>` for column/bar/line/area** — the dominant remaining
  Column-chart divergence. Excel shows them by default; FreeX only does for *stacked*
  bar/column (`ShouldUseExcelNativeValueAxisMajorGridlineStyle`). Extending the write-time
  default to clustered/line/area is NOT round-trip-safe with the current `bool`
  `ShowYAxisMajorGridlines`: a chart with gridlines off reloads as on (the corpus
  round-trip test `XlsxCorpusRunnerTests.GeneratedCorpusRows_RoundTripThroughXlsxAdapter`
  catches this), and "default-on" makes "explicitly off" unrepresentable. Doing it right
  needs a **3-state (nullable) `ShowYAxisMajorGridlines`** (null=Excel default per family,
  true=on, false=off) threaded through reader/writer/renderer — a deliberate refactor,
  not a quick fix. (An attempt to do it write-time-only was reverted for breaking the
  corpus round-trip.)
- **`colors1.xml` + `style1.xml`** chart style parts — Excel native classic charts include
  color-mapping and chart-style parts; FreeX emits neither for classic charts. A larger
  feature (emit `cs:colorStyle`/`cs:chartStyle` parts + content types + rels), parallel to
  the chartEx style-parts work. Note FreeX's *saved* colors already render correctly in
  Excel (contact-sheet col 2 matched native), so impact is mostly subtle styling.
- **Non-visual chart-level elements** (`roundedCorners`, `plotVisOnly`, `dispBlanksAs`,
  `autoTitleDeleted`, axis `txPr`) — FreeX omits them at their default; Excel always
  writes them. Schema-equivalent (omitted default == explicit default), so they do NOT
  affect rendering or the visual hash — purely structural. Low priority.

All charts *pass* the visual gate today; these tighten file-fidelity hashes further.

## Other residual

- Exp/power trendline R² is now log-space (fixed). Logarithmic/linear/polynomial keep
  original-scale R² (correct — y is not transformed for those).
