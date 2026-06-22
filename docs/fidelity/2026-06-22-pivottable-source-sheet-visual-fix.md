# PivotTable Source Sheet + Report Filter Button Fidelity

Date: 2026-06-22

Scope: local worksheet/data-table PivotTables only. External connections, Data Model, and OLAP remain intentionally out of scope.

## Disparity

Native Excel-authored PivotTables whose cache source sheet differs from the PivotTable sheet loaded with `PivotTableModel.SourceRange` bound to the PivotTable sheet. The PivotTable UI then read visible report-filter/body cells as if they were source headers, which produced fallback captions such as `Field3` and prevented native report-filter dropdown buttons from targeting Excel's selected-value cells above the PivotTable body.

Concrete fixture:

- Workbook: `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots\Excel_native_pivot_report_filters_001.xlsx`
- Before diagnostic report: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-report-filter-diagnostics-20260622\freex\REPORT.txt`
- Before target summary: `Page:B4:Field3; Row:A5:Field2; Column:B4:Field5`

## Fix

- `XlsxPivotTableReader` now carries the pivot cache `SourceSheetName` into the pending native PivotTable model.
- Native PivotTable materialization resolves `SourceRange` against the cache source sheet when that sheet exists, falling back to the PivotTable sheet only when the cache source sheet is absent.
- `FreeX.SheetGridImageCompare` reports planned PivotTable dropdown targets in `REPORT.txt`, so visual parity runs can distinguish planner/caption failures from renderer styling failures.

## Evidence

Focused semantic tests:

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~XlsxPivotTableNativeIoSemanticTests
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotHeaderDropdownPlannerTests
```

Both focused lanes passed.

Visual recheck:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
$xlsx = 'C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots\Excel_native_pivot_report_filters_001.xlsx'
$out = 'C:\Users\ali\freex-xlsx-verify\visual\pivot-native-report-filter-sourcefix-20260622'
dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out $out --threshold 25
```

After target summary:

```text
Page:B2:Channel; Page:E2:Region*; Row:A5:Category; Column:B4:Month
```

This matches Excel's native report-filter selected-value cells for the page fields. The visual comparison remains `OK` under the existing threshold with exact dimensions (`681x194`), but the mean diff remains about `8.8%`.

Native corpus recheck:

```powershell
$base = 'C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out = 'C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-sourcefix-20260622'
Get-ChildItem $base -Filter *.xlsx | Sort-Object Name | ForEach-Object {
  dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Result: all 10 native PivotTable corpus workbooks rendered successfully with exact Excel/FreeX PNG dimension matches and `OK` status under the current threshold. Worst residual mean diff in this run was `10.5%` on `Excel_native_pivot_date_grouping_003.xlsx`; `Excel_native_pivot_layout_options_002.xlsx` followed at `10.3%`. The corpus summary was written to `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-sourcefix-20260622\summary.json`.

## Remaining Visual Gaps

- PivotTable column width/content clipping still differs from Excel in the report-filter fixture.
- PivotTable style granularity, body/header fill, font metrics, and row/column sizing remain visible contributors to the residual diff.
- The current diff gate is still a mean-pixel threshold; it is useful for trend detection but should not be treated as proof of pixel-perfect fidelity.
