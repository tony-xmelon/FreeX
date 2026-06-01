# Handoff — Excel-openability & chart follow-ups (2026-06-01)

Self-contained task list for assignment to other workstreams. Context: a real-Excel
verification pass found FreeX's XLSX output did not open in Microsoft Excel. Two root
causes were fixed and **merged to `main`** this session (verified via the Open XML SDK
validator *and* real Excel COM):

- **Theme** (`f36cdd6c1`): modeled `theme1.xml` `fontScheme`/`fmtScheme` were incomplete →
  blocked **every** workbook. Fixed. Plain/text/data workbooks now open in Excel.
- **Charts** (`9525a8d6a`): classic chart title/axis `<c:rich>` missing `<a:bodyPr>`,
  `<c:lineChart>` missing `<c:grouping>`, worksheet `<drawing>` mis-ordered after
  `tableParts`, and the chartEx `cx:` schema (dataId/title/legend/binning). Fixed.
  **Classic charts (Column/Bar/Line/Pie/Area/Scatter) now open in Excel — verified.**

A permanent, Excel-independent gate exists: `tests/FreeX.Core.IO.Tests/XlsxSchemaValidationTests.cs`
(uses the Open XML SDK validator; `DocumentFormat.OpenXml` is available transitively via
ClosedXML). All 13 chart types currently pass schema validation.

---

## TASK 1 — (P1) Make modern chartEx charts open in Excel  ← highest value

**Problem.** Histogram, Waterfall, Treemap, Sunburst, Pareto, Funnel, Box-&-Whisker charts
are now schema-valid but **still do not open in Excel** (Excel `Workbooks.Open` → `0x800A03EC`).
Excel requires modern-chart package extras that FreeX does not emit. A classic chart in the
same workbook opens fine, so this is chartEx-specific package wiring.

**What Excel requires** (determined by diffing an Excel-authored histogram — see Reference below):

1. `xl/charts/colors1.xml` — content type `application/vnd.ms-office.chartcolorstyle+xml`
   (root `<cs:colorStyle>` … namespace `http://schemas.microsoft.com/office/drawing/2012/chartStyle`).
2. `xl/charts/style1.xml` — content type `application/vnd.ms-office.chartstyle+xml`
   (root `<cs:chartStyle>`).
3. `xl/charts/_rels/chartEx1.xml.rels` relating the chartEx part to the two parts above:
   - `http://schemas.microsoft.com/office/2011/relationships/chartColorStyle` → `colors1.xml`
   - `http://schemas.microsoft.com/office/2011/relationships/chartStyle` → `style1.xml`
4. `[Content_Types].xml` Overrides for `colors1.xml` and `style1.xml`.
5. **Drawing wrapper**: the chartEx `graphicFrame` must be wrapped in
   `<mc:AlternateContent>` →
   `<mc:Choice Requires="cx1" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex">`
   (containing the `graphicFrame` with `<a:graphicData uri=".../2014/chartex"><cx:chart r:id=…/>`)
   plus an `<mc:Fallback>` containing a placeholder `<xdr:sp>` ("This chart isn't available in
   your version of Excel."). Excel authors this inside a `twoCellAnchor`; FreeX currently emits
   a bare `absoluteAnchor` graphicFrame with no AlternateContent.

**Where in code.**
- chartEx part: `src/FreeX.Core.IO/XlsxChartXmlWriter.ChartEx.cs` (add colors/style emission;
  the chart part itself is already schema-valid).
- drawing + rels + content-types: `src/FreeX.Core.IO/XlsxWorksheetChartWriter.cs` (graphicFrame /
  drawing rels) and the content-type/rels editors it uses. The `mc:AlternateContent` wrapper goes
  in the drawing writer; only chartEx charts (`ChartTypeSupport.IsChartExFamily`) need it.
- A reference for which relationship/content-type to wire: existing chartEx part writing already
  sets the chartEx content type + rel via `XlsxChartXmlWriter.GetContentType/GetRelationshipType`.

**Reference file (gold standard).** An Excel-authored histogram is saved at
`C:\Users\anton\freex-xlsx-verify\excel_ref_histogram.xlsx`. Unzip it and copy the structure of
`xl/charts/colors1.xml`, `xl/charts/style1.xml`, `xl/charts/_rels/chartEx1.xml.rels`,
`[Content_Types].xml`, and `xl/drawings/drawing1.xml` (note the `mc:AlternateContent` + `twoCellAnchor`).
Minimal-but-valid colors/style content likely suffices; confirm in Excel.

**Verification.** Extend `XlsxSchemaValidationTests` for schema; the real check is opening in Excel.
Use the recorded approach: a small C# console with `dynamic` Excel COM and
`Thread.CurrentThread.CurrentCulture = en-US` set *before* creating the COM object (this machine's
Office is non-English so PowerShell late-binding fails); write files under `%USERPROFILE%` (not
`%TEMP%`, which triggers Protected View); open with `DisplayAlerts=false`; a rejected file throws
`0x800A03EC`. Track `EXCEL` PIDs and kill orphans. (A throwaway verifier already exists at
`C:\Users\anton\xlsxverify\` — reusable or delete.)

**Done when:** a FreeX histogram + waterfall workbook opens in real Excel without repair, and a
chartEx case is added to `XlsxSchemaValidationTests`/an Excel-open smoke check.

---

## TASK 2 — (P2) Reachability UI for histogram bins & waterfall totals

Model + renderer + native-JSON + XLSX(schema) persistence already exist
(`ChartModel.HistogramBinning`, `ChartModel.WaterfallTotalPointIndices`; pure planners
`HistogramBinPlanner`, `WaterfallBarPlanner`). Missing UI to set them:
- Histogram: "Format Axis ▸ Bins" controls (Automatic / bin width / number of bins +
  overflow/underflow) — likely `ChartAxisFormatDialog` in `src/FreeX.App.Host`.
- Waterfall: a "Set as Total" per-point context-menu/ribbon action that toggles indices in
  `WaterfallTotalPointIndices`.
WPF UI work in `FreeX.App.Host`; add a command for undo/redo and source-text/planner tests.

---

## TASK 3 — (P2) Pre-existing drag resize-preview regression  (grid/viewport lane)

`MainWindowMouseResizeTests.DragRowResize_PreviewsWithoutRefreshingViewportOrMutatingSheetUntilCommit`
and the `DragColumnResize` variant fail (`ViewportCallCount` = 1, expected 0). Confirmed
**pre-existing on clean `main`** — a preview-path change now calls `IViewportService.GetViewport`
(or `UpdateViewport`) during `OnColumnResizing`/`OnRowResizing` instead of only at commit. Already
noted in `OUTSTANDING_BUILD.md` (code-quality backlog). Owner: grid mouse-resize / viewport lane.

---

## TASK 4 — (P3) Chart formatting depth (ongoing polish)

Advanced chart-family formatting presets (treemap/sunburst/Pareto/funnel), full chart
format-pane/dialog UX, and gradients/richer shape effects. Lower priority; incremental.

---

## Notes
- No held git stash remains (the chartEx binning/subtotals persistence was un-stashed and merged
  in `9525a8d6a`). Confirm with `git stash list` if in doubt.
- Throwaway artifacts outside the repo (safe to delete; useful for Task 1):
  `C:\Users\anton\xlsxverify\` (C# Excel verifier) and `C:\Users\anton\freex-xlsx-verify\`
  (generated test workbooks + `excel_ref_histogram.xlsx` reference).
