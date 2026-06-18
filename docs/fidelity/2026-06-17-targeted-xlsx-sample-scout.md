# Targeted XLSX fidelity sample scout - 2026-06-17

Scope: targeted internet sample search for FreeX fidelity gaps around chartEx/funnel charts, Budget-vs-Actual chart labels, emoji/unicode labels, and legacy form-control chrome/interactivity.

## Added to `fidelity-corpus/manifest.csv`

- Apache POI `BrNotClosed.xlsx`: standalone VML button control.
- Apache POI `InlineString.xlsx`: inline string with an emoji XML entity.
- ClosedXML `sheet-with-form-controls-input.xlsx`: radio buttons, group box, VML drawing anchors, and `xl/ctrlProps` parts.
- Open XML SDK `ActiveXControls-O12-XL-Controls.xlsx`: ActiveX button, checkbox, and list-control chrome.
- PhpSpreadsheet `formscomments.xlsx`: button, list, and checkbox form controls with `fmlaLink` and `fmlaRange` interactivity.
- PhpSpreadsheet `32readwriteComboChart1.xlsx`: combo chart workbook with named-range driven validation dropdown menus.
- PhpSpreadsheet `32complexChartreadwrite.xlsx`: Projected, Actual, Budget, and Forecast chart series.

## Still missing

- Resolved on 2026-06-18: Apache-2.0 OfficeCLI `.xlsx` samples were found with true `application/vnd.ms-office.chartex+xml` / `cx:chartSpace` content under `xl/drawings/extendedCharts/`; those rows are now catalogued in `fidelity-corpus/manifest.csv`.
- Scanned permissive fixture sources included Apache POI, ClosedXML, Open XML SDK, NPOI, ExcelJS, PhpSpreadsheet, qax-os/excelize, and SheetJS. Generator/library sources reviewed included xlsx-kit, mschart, openxlsx2, and encharter.
- LibreOffice has excellent chartEx `.xlsx` fixtures such as `funnel1.xlsx`, `color_funnel.xlsx`, `waterfall.xlsx`, `treemap.xlsx`, `sunburst.xlsx`, and `boxWhisker.xlsx` under `chart2/qa/extras/data/xlsx`, but the GitHub API reports the repository license as GPL-3.0. Those files were not added because the current fidelity corpus gate only allows Apache-2.0, MIT, BSD, CC0-1.0, and Public-Domain rows.
