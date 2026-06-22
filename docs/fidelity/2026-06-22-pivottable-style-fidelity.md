# PivotTable style fidelity pass - 2026-06-22

Scope: Windows-only local/native PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain out of scope.

## What changed

- Updated built-in PivotTable style materialization to use the workbook theme colors for the modern Office theme instead of falling back to older blue Office palettes.
- Added corpus-backed mappings for the native PivotTable styles exercised by the Excel-generated corpus:
  - `PivotStyleMedium4`, `PivotStyleMedium5`, `PivotStyleMedium6`, `PivotStyleMedium7`, `PivotStyleMedium9`, `PivotStyleMedium10`, `PivotStyleMedium13`, and `PivotStyleLight16`.
  - Preserved legacy behavior for `PivotStyleMedium2`, `PivotStyleMedium17`, and `PivotStyleDark7`, which are covered by existing tests and differ from the modern corpus mapping.
- Improved loaded native matrix header styling so the Excel-authored "value field / Column Labels" preamble and the following "Row Labels / item labels" row are styled as PivotTable header rows.
- Updated `tools/FreeX.SheetGridImageCompare` so off-screen visual comparison renders PivotTable header dropdown buttons through `PivotHeaderDropdownPlanner.BuildTargets`, matching the WPF host pipeline.

## Verification evidence

Focused tests:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" -v minimal
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~ExcelOpenSmokeReportSchemaTests" -v minimal
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -v minimal
```

Outcomes:

- PivotTable refresh/style tests: `145 passed`, `1 skipped`.
- Excel smoke/schema harness tests: `13 passed`.
- SheetGridImageCompare build: succeeded with `0` warnings and `0` errors.

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-style-fidelity-20260622j'
Get-ChildItem $base -Filter '*.xlsx' | Sort-Object Name | ForEach-Object {
  dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all 10 workbooks rendered and compared without export, render, or dimension failures.

| Fixture | Previous diff | Current diff | Notes |
|---|---:|---:|---|
| Basic row/column | `10.5%` | `8.5%` | Modern `PivotStyleMedium9` teal palette now renders; residual is mostly field-button chrome, font metrics, and value/body text weight/spacing. |
| Calculated field/item | `6.2%` | `6.1%` | Modern `PivotStyleMedium7` green family now renders; residual includes text metrics and PivotTable field buttons. |
| Date grouping | `12.6%` | `11.3%` | Modern `PivotStyleMedium6` purple family now renders; residual is dominated by grouped row expand/collapse glyphs and indentation. |
| Filters/sorts | `5.7%` | `4.7%` | Modern `PivotStyleMedium10` orange family is closer; residual includes field-button chrome and font metrics. |
| Grouping/show values | `5.6%` | `5.3%` | `PivotStyleLight16` now follows the modern Office accent mapping; residual is mostly typography and total/header fine styling. |
| Layout options | `11.3%` | `10.3%` | Modern `PivotStyleMedium13` purple family now renders; residual includes layout-specific fills, borders, and expand/collapse glyphs. |
| Multiple pivots / one cache | `5.6%` | `5.6%` | Legacy `Medium2`/`Dark3` behavior preserved; residual is mostly style granularity and text rendering. |
| Report filters | `8.4%` | `8.7%` | Harness now renders PivotTable dropdown buttons; residual includes report-filter button placement/chrome and typography. |
| Slicer/timeline | `5.5%` | `5.7%` | Harness now renders PivotTable dropdown buttons; slicer/timeline visual filter chrome remains a separate contributor. |
| Table source filters | `7.6%` | `5.3%` | Modern `PivotStyleMedium4` green family now renders; residual includes field-button chrome and text metrics. |

## Remaining disparities

This is still not 100% pixel fidelity. The remaining actionable visual gaps are:

- PivotTable field-button chrome: FreeX now renders buttons in the visual harness, but the button size, gradient, border, glyph position, and active-filter glyph still differ from Excel.
- Grouped/date PivotTables: Excel renders expand/collapse boxes and group indentation that FreeX does not yet match.
- PivotTable style granularity: the current renderer uses a compact palette model, while Excel applies more specific style elements for headers, subtotals, grand totals, blank footprint cells, and some body cells.
- Text rendering: Excel and FreeX still differ in font metrics, antialiasing, boldness, and alignment in PivotTable cells.
- Native slicer/timeline chrome: the visual filter objects render and compare, but their Excel styling is still approximate.
