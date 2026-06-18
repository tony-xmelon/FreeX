# XLSX chart and pivot corpus growth - 2026-06-18

Scope: internet sample search for richer FreeX fidelity rows focused on real ChartEx/cx charts, chart-heavy workbooks, chartsheets, and PivotTable package diversity.

## Added to `fidelity-corpus/manifest.csv`

- OfficeCLI `charts-extended.xlsx`: Apache-2.0 extended chart suite with fourteen `application/vnd.ms-office.chartex+xml` parts under `xl/drawings/extendedCharts/`; observed `cx:chartSpace` content includes funnel, treemap, sunburst, histogram, and box/whisker layouts.
- OfficeCLI `charts-histogram.xlsx`: Apache-2.0 statistical chart suite with twenty nine ChartEx content-type parts and sizeable histogram/Pareto source data.
- OfficeCLI `charts-boxwhisker.xlsx`: Apache-2.0 box-and-whisker workbook with eight ChartEx content-type parts plus ChartEx style/color sidecars.
- OfficeCLI `charts-advanced.xlsx`, `charts-combo.xlsx`, `sales-dashboard.xlsx`, and `budget-tracker.xlsx`: additional Apache-2.0 chart/drawing/dashboard coverage.
- OfficeCLI `pivot-tables.xlsx`: Apache-2.0 PivotTable suite with seventeen pivot table definitions and five cache definition/record sets.
- ClosedXML `PivotTables.xlsx`: MIT workbook with ten pivot table definitions backed by structured source table parts.
- ClosedXML.Report `tPivot5_Static.xlsx`: MIT static pivot template with one PivotTable and cache record package parts.
- Open XML SDK `Pivot2.xlsx`, `pivot5.xlsx`, `RelationalPivotA1.xlsx`, and `OlapPivotA3.xlsx`: MIT native pivot variants including relational and OLAP pivot package shapes.
- Open XML SDK `ChartSheet.xlsx` and `Axis Title-O12-XL-ChartProperties.xlsx`: MIT chartsheet and axis-title chart package coverage.
- PhpSpreadsheet `chart-with-and-without-overlays.xlsx`: MIT overlay and non-overlay chart coverage.

## Verification Notes

The selected files were downloaded to a scratch folder and inspected as ZIP/OpenXML packages before cataloguing. The committed change adds manifest metadata only; the workbook binaries remain download-on-demand through `tools/Fetch-FidelityCorpus.ps1` into the ignored `fidelity-corpus/files/` directory.
