# PivotTable button placement fidelity pass - 2026-06-22

Scope: Windows-only local/native PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain out of scope.

## What changed

- Corrected PivotTable report-filter dropdown targets so the rendered button is attached to the selected-value cell, matching Excel's page-field UI.
- Added native Excel page-field placement support for workbooks whose PivotTable `TargetRange` excludes the report-filter rows above the body range.
- Added native matrix header support so row-field dropdowns render on the `Row Labels` row while column-field dropdowns remain on the `Column Labels` row.
- Preserved generated FreeX PivotTable behavior by detecting whether the target range starts at page fields or at the PivotTable body.

## Verification evidence

Focused test:

```powershell
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotHeaderDropdownPlannerTests" -v minimal
```

Outcome: `5` passed, `0` failed.

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-button-fidelity-20260622a'
Get-ChildItem $base -Filter '*.xlsx' | Sort-Object Name | ForEach-Object {
  dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all 10 native PivotTable workbooks rendered and compared without export, render, or dimension failures.

| Fixture | Previous diff | Current diff | Notes |
|---|---:|---:|---|
| Basic row/column | `8.5%` | `8.5%` | Row-field button moved from the value-field preamble cell to Excel's `Row Labels` row. |
| Calculated field/item | `6.1%` | `6.1%` | No dimension failures; remaining diff is typography and style granularity. |
| Date grouping | `11.3%` | `11.3%` | Remaining diff is dominated by missing expand/collapse glyphs, grouping indentation, and text metrics. |
| Filters/sorts | `4.7%` | `4.7%` | No dimension failures; remaining diff is field-button chrome and typography. |
| Grouping/show values | `5.3%` | `5.3%` | No dimension failures; remaining diff is total/header styling and typography. |
| Layout options | `10.3%` | `10.3%` | Headers remain hidden as authored; remaining diff is layout-specific styling and group affordances. |
| Multiple pivots / one cache | `5.6%` | `5.6%` | No dimension failures; remaining diff is style granularity and text rendering. |
| Report filters | `8.7%` | `8.7%` | Page-field buttons moved from field-name cells to Excel's selected-value cells, including native blank separator columns. |
| Slicer/timeline | `5.7%` | `5.7%` | No dimension failures; slicer/timeline visual filter chrome remains approximate. |
| Table source filters | `5.3%` | `5.3%` | No dimension failures; remaining diff is field-button chrome and text metrics. |

## Remaining disparities

This is still not 100% pixel fidelity. The button target cells now match the native Excel corpus, but the visible button chrome still differs in size, fill, border, and glyph geometry. The largest remaining actionable gap is grouped/date PivotTable rendering: Excel shows expand/collapse boxes plus grouped-row indentation, while FreeX still renders those rows as plain labels.
