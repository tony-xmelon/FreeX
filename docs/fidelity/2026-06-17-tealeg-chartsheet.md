# Tealeg chartsheet load + render (2026-06-17)

Driver file: `test-corpus/public/tealeg-xlsx/testchartsheet.xlsx` — two sheets in Excel:
**"Chart1"** (a chartsheet: a full-page line chart titled "Value", data 1→4, legend "Value")
and **"Sheet1"** (a normal worksheet holding the data).

## The gap

FreeX loaded only worksheets. Sheet enumeration on load comes from ClosedXML's
`XLWorkbook.Worksheets`, which only surfaces worksheets — chartsheets were silently dropped.
`XlsxFeatureInspector` flagged `Kind=UnsupportedSheetTypes` for `xl/chartsheets/sheet1.xml`.
The underlying parts already round-tripped (pass-through preserved), so this was a LOAD + DISPLAY
gap, not data loss.

Package shape:
- `xl/workbook.xml` `<sheets>` lists both; the chartsheet's `<sheet r:id="rId1">` resolves to a
  `.../relationships/chartsheet` relationship → `xl/chartsheets/sheet1.xml`.
- `xl/chartsheets/sheet1.xml` carries `<drawing r:id="rId1"/>` → `xl/drawings/drawing1.xml` →
  `xl/charts/chart1.xml` (a normal line chart). The chart series reference `Sheet1!$A$1` /
  `Sheet1!$A$2:$A$5` with `numCache` 1..4.

## What landed

### Model
- `SheetKind { Worksheet, Chartsheet }` enum + `Sheet.Kind`, `Sheet.IsChartsheet`, and
  `Sheet.ChartsheetChart` (first entry of `Sheet.Charts`). A chartsheet is a `Sheet` with
  `Kind = Chartsheet` carrying its single chart in `Charts` — no separate sheet class, so the
  rest of the app (tabs, workbook ordering, save) treats it uniformly.
  (`src/FreeX.Core.Model/Sheet.cs`)

### Load
- New `XlsxChartsheetReader` (`src/FreeX.Core.IO/XlsxChartsheetReader.cs`) enumerates the
  workbook's `<sheets>` list, detects entries whose relationship targets a chartsheet part, and
  resolves each chartsheet's full-page chart by **reusing the worksheet drawing/chart reader**
  (`XlsxWorksheetDrawingPartReader.ReadParts`) — a chartsheet root carries the same
  `<drawing r:id="..."/>` element a worksheet does.
- `XlsxFileAdapter.LoadCore` reads chartsheets during the package-metadata phase and
  `InsertChartsheets(...)` inserts each as a `Kind = Chartsheet` `Sheet` at its original workbook
  tab index, loading the chart via the existing `XlsxChartPartReader` (with a sheet-name resolver
  so `Sheet1!...` series resolve to the real data sheet's `SheetId`).
  (`src/FreeX.Core.IO/XlsxFileAdapter.cs`)

### Inspector
- `XlsxFeatureInspector` no longer flags `xl/chartsheets/` (path) or `.../chartsheet`
  (relationship-type) as `UnsupportedSheetTypes`; dialog/macro sheets still flag.
  (`src/FreeX.Core.IO/XlsxFeatureInspector.cs`)

### Sheet tab
- No code change needed: `SheetTabListPlanner` enumerates all non-hidden `workbook.Sheets`, so the
  chartsheet appears as a tab ("Chart1") automatically once modeled.

### Render
- New `MainWindow.Chartsheet.cs`: when the active sheet `IsChartsheet`, hide `SheetGrid` and show
  a full-window `Image` (`ChartsheetView`, added to `MainWindow.xaml`) whose `Source` is produced
  by the existing `FreeX.App.UI.ChartRenderer.Render`. The chart's data lives on its source
  worksheet, so the host builds a viewport from that data sheet (`chart.DataRange.Start.Sheet`);
  `ChartRenderer` matches series cells by row/col. The chart is sized to the window and re-rendered
  on resize. Switching back to a worksheet restores the grid.
  (`src/FreeX.App.Host/MainWindow.Chartsheet.cs`, `MainWindow.xaml`, `MainWindow.Viewport.cs`)

### Round-trip
- Modeling the chartsheet as a `Sheet` makes ClosedXML emit a placeholder worksheet for it on
  save, which previously replaced the chartsheet `<sheet>` reference. `XlsxUnsupportedSheetReferencePreserver`
  now reclaims that collision: it re-points the generated `<sheet name="Chart1">` entry at the
  preserved chartsheet relationship and removes the stray worksheet part + its rels + content-type
  override. The chartsheet survives load→edit→save.
  (`src/FreeX.Core.IO/XlsxUnsupportedSheetReferencePreserver.cs`)

## Verification

- `dotnet build FreeX.slnx -c Release` — succeeds.
- `tests/FreeX.Core.IO.Tests` chartsheet + inspector + corpus runner — pass, incl. new
  `XlsxChartsheetLoadTests` (2 sheets incl. "Chart1" with `ChartType.Line`; inspector no longer
  flags `UnsupportedSheetTypes`; chartsheet `<sheet>` reference survives a save after editing the
  worksheet).
- `tests/FreeX.App.UI.Tests` — pass, incl. `ChartsheetRenderTests` (full-window line chartsheet
  renders a non-blank bitmap from cross-sheet data).
- `tools/FreeX.SheetFidelity` on `testchartsheet.xlsx`:
  - Before: sheet count 1, `Kind=UnsupportedSheetTypes` for `xl/chartsheets/sheet1.xml`.
  - After: **Sheet count 2** (Chart1 + Sheet1), **Chart1 Chrts=1**, **No unsupported features
    detected**, round-trip Save SUCCESS.

## Rendered chartsheet vs Excel ground truth

Ground truth (`chartsheet_Chart1.png`): a full-page line chart, title "Value", y-axis 0–4.5,
legend "Value", a single rising line over points 1→4. FreeX now renders the chartsheet full-window
via `ChartRenderer` (line series + title + axes/gridlines from the same `numCache`-backed data),
matching the ground truth's chart type, title, single rising series, and full-page layout.

## Manifest

`test-corpus/manifest.csv` row `public-tealeg-chartsheet`: tags changed from
`chartsheet unsupported-sheet-types` to `chartsheet charts` (the file now loads a real chart and
no longer warns).
