# PivotTable slicer/timeline visual coverage - 2026-06-22

Scope: Windows-only local/native PivotTable parity against desktop Microsoft Excel. External connections, Data Model, and OLAP remain out of scope.

## What changed

- Added an Excel-authored native PivotTable fixture with a Region slicer and SaleDate timeline.
- Extended `tools/FreeX.ExcelOpenSmoke` validation to accept Excel 2011 timeline/timeline-cache relationship types.
- Extended `tools/FreeX.SheetGridImageCompare` with `--pivot-sheet-ranges`, which compares the visible PivotTable sheet range plus native slicer/timeline drawing anchors.
- Fixed FreeX package repair so workbook-level slicer/timeline extension refs survive generated workbook save paths and use Excel's canonical slicer workbook extension URI casing.

## Disparity fixed

The FreeX-saved slicer/timeline fixture previously failed Microsoft Excel `Workbooks.Open` even though schema validation passed. Package probes narrowed the hard-open failure to `xl/workbook.xml` `extLst`: Excel accepted the same package once the slicer workbook extension URI used Excel's mixed-case spelling:

```xml
{BBE1A952-AA13-448e-AADC-164F8A28A991}
```

The fix canonicalizes that URI in both package metadata merge/repair and authored slicer/timeline writer paths.

## Evidence

Excel save/reopen corpus:

```powershell
dotnet run --project tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj -c Release -- --save-reopen --generate-excel-pivot-corpus-fixtures --out C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f
```

Outcome: `PASS: Excel validated 10/10 workbook(s).`

Visual comparison:

```powershell
$base='C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots'
$out='C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-slicer-timeline-20260622f'
Get-ChildItem $base -Filter '*.xlsx' | ForEach-Object {
  dotnet run --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $_.FullName --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out (Join-Path $out $_.BaseName) --threshold 25
}
```

Outcome: all 10 workbooks rendered and compared without export, render, or dimension failures. The slicer/timeline fixture compared `Pivot Slicer Timeline!A1:K14` using `SheetUsedRangeWithNativeVisualFilters`.

Observed worst raster diffs:

- Basic row/column: `10.5%`
- Calculated field/item: `6.2%`
- Date grouping: `12.6%`
- Filters/sorts: `5.7%`
- Grouping/show values: `5.6%`
- Layout options: `11.3%`
- Multiple pivots/one cache: `5.6%`
- Report filters: `8.4%`
- Slicer/timeline: `5.5%`
- Table source filters: `7.6%`

## Remaining visual gaps

These comparisons are now stable enough to use as a regression lane, but they are not yet 100% pixel fidelity. Remaining measurable raster deltas are mostly from GridView-vs-Excel typography, spacing, and PivotTable style rendering details. Tightening those deltas is the next visual fidelity pass after the package/open parity fixes.
