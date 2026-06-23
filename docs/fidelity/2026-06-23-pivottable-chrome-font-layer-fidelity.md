# PivotTable Chrome And Font Layer Fidelity - 2026-06-23

## Scope

This pass continues local native PivotTable parity against desktop Microsoft Excel for the in-scope feature surface. External connections, Data Model pivots, and OLAP pivots remain excluded.

The patch addresses two correctness gaps found while investigating the remaining visual deltas:

- PivotTable field dropdown buttons now have PivotTable-specific chrome instead of reusing worksheet AutoFilter button geometry and colors.
- Loaded PivotTable style application now preserves existing fill and border channels independently while still applying meaningful PivotTable font styling, including clearing stale theme font colors when applying explicit PivotTable font colors.

## Fixed Disparities

Pivot header dropdown buttons are now rendered with their own 17px button rectangle, border, gradient, and glyph path. Worksheet AutoFilter chrome remains unchanged. Expand/collapse glyphs now use a slightly larger 10px box with lighter Excel-like border/fill and pixel-snapped plus/minus strokes.

Loaded PivotTables can arrive from Excel with cell-local fills or borders already materialized. FreeX previously treated any existing visual style as a reason to skip the whole PivotTable visual style layer, which could skip header/total bold and font colors. The style merger now preserves existing fill and border channels separately, but still applies PivotTable font layers when the target style carries visible font semantics.

## Evidence

Focused tests:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivot-style-font-layer-tests.trx" --verbosity minimal
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter "FullyQualifiedName~GridViewPivotHeaderDropdownSourceTests" --logger "trx;LogFileName=pivot-chrome-ui-tests.trx" --verbosity minimal
```

Results:

- PivotTable focused style tests: `152 passed`, `1 skipped`.
- PivotTable chrome UI tests: `3 passed`.

Visual compare tool build:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

Build result: `0 warnings`, `0 errors`.

Full native PivotTable visual corpus after the fix:

| Fixture | Diff |
| --- | ---: |
| Basic row/column | 5.8% |
| Calculated field/item | 2.2% |
| Date grouping | 7.5% |
| Filters/sorts | 3.3% |
| Grouping/show values | 4.4% |
| Layout options | 6.8% |
| Multiple pivots one cache | 2.0% |
| Report filters | 3.7% |
| Slicer/timeline | 2.4% |
| Table source filters | 4.4% |

Evidence root:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-chrome-metrics-20260623\full-after-font-chrome`

All ten fixtures rendered with `Errors: 0` and exact Excel/FreeX PNG dimensions.

## Remaining Gaps

The one-decimal visual diffs did not improve versus the Medium13 body-fill baseline. This is useful negative evidence: the remaining largest deltas are not primarily caused by field-button rectangle size or the loaded-style early-return bug.

The next highest-value slice should implement deeper built-in PivotTable style element semantics, especially font weight/color and border/fill behavior for body item labels, value cells, compact grouped parent rows, subtotal rows, and grand totals. After that, reassess GridView font-family/default-theme handling and text rasterization.

