# Contextures chart visual fidelity — files 04 (target band) & 03 (pie)

Date: 2026-06-17
Scope: chart RENDERING fidelity only (no GridView / non-chart IO touched).
Harness: `tools/FreeX.ExcelExamplesCharts` run with `--no-excel` (Excel ground-truth PNGs were
captured separately). Re-render: `dotnet run --project tools/FreeX.ExcelExamplesCharts -c Release
--no-build -- "<workbook.xlsx>" "<outDir>" --no-excel`.

Before/after/Excel PNGs: `docs/fidelity/assets/2026-06-17-charts/`.

## File 04 — "shaded target band" COMBO chart (`04_charts_target-range.xlsx`)

### Excel ground truth
*Qty* drawn as a LINE over a pale-yellow shaded *band*; the band is a stacked column of a
transparent spacer (T_Low = 250) + a shaded segment (Target = 100, so band = 250..350). Category
axis shows formatted dates (1-Jan…1-Jun). Legend lists Target + Qty (the transparent spacer hidden).

### Root causes found
The chart loads as `Type = StackedColumn` with a `<c:lineChart>` Qty series at **idx 0**, plus two
`<c:barChart>` helper series (T_Low idx1 col D, Target idx2 col E). The Qty val is col B; col C
("T_High", unused by the chart) sits *inside* the union DataRange A1:E9. Defects:

1. **Combo line at series index 0 was dropped.** Three independent filters discarded idx 0:
   `XlsxChartPartReader.Bar` (`index > 0`), `ChartSeriesIndexSanitizer` (`index > 0`), and the
   renderer guards `IsComboLineSeries`/`IsComboScatterSeries` (`seriesIndex <= 0`). Excel commonly
   emits the line series first, so idx 0 must be allowed. Fixed all three to `>= 0` / `< 0`. Also
   relaxed the WRITER (`XlsxChartXmlWriter.GetComboLineSeriesIndexes`) to keep idx 0 so a loaded
   shaded-band chart round-trips its line series.
2. **Positional series model rendered a phantom "Target" column.** The renderer iterated *every*
   column in the union DataRange and treated each as a series keyed by positional offset, so col C
   became a bogus series and per-series formats/combo flags were mis-keyed (off by the skipped
   column). Added `ChartSeriesColumnMapping` (series chart-XML idx -> value column), populated from
   each series' `<c:val>` range during load. When the mapping is complete and in-range the renderer
   plots exactly those columns, using the real chart-XML idx for format/combo/legend lookups, and
   skips unreferenced columns. Falls back to the legacy positional scan when the mapping is absent
   (named ranges, cross-sheet refs, etc.).
3. **Date-serial categories showed raw serials (44562).** The category/date axis `<c:numFmt>` was
   not read (only the value axis numFmt was). Added category-axis numFmt capture in
   `XlsxChartAxisReader.ApplyCategoryAxisProperties`, and the renderer now formats numeric/date
   category cells through `NumberFormatter` with that code (`FormatCategoryLabel`).
4. **Transparent spacer rendered as a white box with a black border.** `<a:noFill/>` on the bar
   fill was honored, but the series' `<a:ln><a:noFill/>` (no outline) was not. Added a `NoLine` flag
   to `ChartSeriesFormat`, read in `XlsxChartSeriesFormatReader`, and honored in the bar formatters
   (transparent stroke, zero thickness).

### Result (after)
Qty renders as a line over a pale-yellow band; the spacer is invisible; the date axis reads
1-Jan…1-Jun; the phantom column is gone. Very close to the Excel target.
See `file04_before.png` / `file04_after.png` / `file04_excel.png`.

### Deferred (file 04)
- **Legend still lists "T_Low".** The chart XML has `<c:legendEntry><c:idx val="0"/><c:delete/>`,
  but the OOXML legend-entry idx here is the *legend position* (declaration order: T_Low, Target,
  Qty), NOT the series chart-XML idx that FreeX's `IsLegendEntryDeleted` matches on. Honoring it
  correctly requires a position-vs-series-idx mapping that risks regressing bullet-chart helper
  series (which rely on the current series-idx interpretation). Left as-is — minor cosmetic; the
  transparent spacer's plot body is already invisible.
- **Band gap width** differs slightly from Excel (Excel uses a narrower inter-category gap). Pure
  styling; not addressed.

## File 03 — pie (`03_table-chart-slicers_task-tracker.xlsx`)

### Root causes found
1. **Slices were near-identical green.** Both `<c:dPt>` reference `accent6` but with luminance
   modulation — slice 0 `<a:shade val="76000"/>` (darker), slice 1 `<a:tint val="77000"/>`
   (lighter). `XlsxDrawingColorReader.ReadTint` only handled `lumMod`/`lumOff`, so both resolved to
   plain accent6. Extended it to map `<a:tint>` -> positive (lighten) and `<a:shade>` -> negative
   (darken) on FreeX's signed-tint convention. Slices now render distinct (Completed dark green,
   Remaining light green). This is a general DrawingML fix (helps any chart/shape using shade/tint).
2. **No legend.** OxyPlot 2.x `PieSeries` contributes no per-slice entries to the built-in legend,
   so the pie had none. Added `AddPieLegendAnnotations`: a colored swatch (`RectangleAnnotation`) +
   category label (`TextAnnotation`) per slice on a dedicated invisible 0..1 axis pair, placed per
   the chart's legend position. Now shows Completed/Remaining swatches like Excel.

### Result (after)
Distinct slice colors + a per-slice legend, matching Excel.
See `file03_before.png` / `file03_after.png` / `file03_excel.png`.

## Files changed
- `src/FreeX.Core.Model/ChartModel.cs`, `ChartModel.Support.cs` — `SeriesColumnMappings`,
  `ChartSeriesColumnMapping`, `ChartSeriesFormat.NoLine`.
- `src/FreeX.Core.IO/XlsxChartPartReader.Bar.cs` — keep combo idx 0; populate + normalize
  series-column mappings (combo + plain bar).
- `src/FreeX.Core.IO/XlsxChartSeriesRangeReader.cs` — `TryReadSeriesValueColumn`.
- `src/FreeX.Core.IO/ChartSeriesIndexSanitizer.cs` — allow combo idx 0 (`SanitizeComboIndexes`).
- `src/FreeX.Core.IO/XlsxChartAxisReader.cs` — read category/date axis numFmt.
- `src/FreeX.Core.IO/XlsxChartSeriesFormatReader.cs` — read line `<a:noFill/>` as `NoLine`.
- `src/FreeX.Core.IO/XlsxDrawingColorReader.cs` — map `<a:shade>`/`<a:tint>`.
- `src/FreeX.Core.IO/XlsxChartXmlWriter.Series.cs` — writer keeps combo idx 0.
- `src/FreeX.App.UI/ChartRenderer.cs` — category formatting; skip non-series columns; pie legend call.
- `src/FreeX.App.UI/ChartRenderer.SeriesFormatting.cs` — series-column helpers; combo idx-0 guards;
  NoLine handling; `AddPieLegendAnnotations`.
- `src/FreeX.App.UI/ChartRenderer.Stacked.cs` — stacked column/bar use mapping + skip non-series.
- Tests: `tests/FreeX.App.UI.Tests/ChartRendererTests.ComboBand.cs` (new);
  `tests/FreeX.Core.IO.Tests/XlsxChartPartReaderTests.BarLineScatterCombo.cs` +
  `XlsxChartPartReaderTests.PieDonutCharts.cs` (new cases); updated 3 pie data-label tests +
  2 native-json sanitizer tests for the combo-idx-0 behavior change.

## Verification
- `dotnet build FreeX.slnx -c Release` — clean (0 warnings, 0 errors).
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — all green.
- `tests/FreeX.App.UI.Tests` (WPF, not in DefaultTests.slnx): 703 passed, 27 skipped, 0 failed.
- `tests/FreeX.Core.IO.Tests` chart suites: green (incl. new combo-band + shade/tint cases).
