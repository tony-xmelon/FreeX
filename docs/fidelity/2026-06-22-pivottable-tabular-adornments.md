# PivotTable Tabular Row Label Adornment Fidelity

Date: 2026-06-22

Scope: local worksheet/data-table PivotTables only. External connections, Data Model, and OLAP remain intentionally out of scope.

## Disparity

Excel shows expand/collapse boxes on first parent row labels in tabular and outline PivotTable layouts. FreeX previously planned these row-label adornments only for compact layout, so native tabular PivotTables with multiple row fields missed the small parent group boxes even when `showDrill` / `ShowExpandCollapseButtons` was enabled.

Concrete fixture:

- Workbook: `C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots\Excel_native_pivot_layout_options_002.xlsx`
- Baseline visual output: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-corpus-sourcefix-20260622\Excel_native_pivot_layout_options_002\freex\freex_01_Pivot_Layout_NativePivotLayoutOptions.png`
- Recheck visual output: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-adornments-20260622\freex\freex_01_Pivot_Layout_NativePivotLayoutOptions.png`

## Fix

`PivotRowLabelAdornmentPlanner` now handles non-compact multi-row-field PivotTables. For tabular/outline layouts, it emits an expand/collapse adornment on the first row of a repeated parent group when the following row shares the same parent prefix. The existing compact indentation-based path remains unchanged.

## Evidence

Focused test:

```powershell
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotRowLabelAdornmentPlannerTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: passed, `3` tests.

Visual recheck:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
$xlsx = 'C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-corpus-slicer-timeline-20260622f\generated-excel-pivots\Excel_native_pivot_layout_options_002.xlsx'
$out = 'C:\Users\ali\freex-xlsx-verify\visual\pivot-native-layout-adornments-20260622'
dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj -c Release -- $xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out $out --threshold 25
```

Result: exact Excel/FreeX dimensions (`713x314`) and `OK` status under the current threshold. The recheck image shows expand/collapse boxes on `East`, `North`, `South`, and `West`.

## Remaining Visual Gaps

- Mean diff for this fixture remains about `10.3%` because fill placement, row/column stripe granularity, font metrics, and value/text clipping still dominate the pixel comparison.
- The current visual gate is still threshold-based rather than pixel-perfect.
