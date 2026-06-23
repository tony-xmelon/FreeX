# PivotTable Medium13 Body Fill Fidelity - 2026-06-23

## Scope

This pass continues local native PivotTable parity against desktop Microsoft Excel for the in-scope feature surface. External connections, Data Model pivots, and OLAP pivots remain excluded.

The patch targets an Excel-authored `PivotStyleMedium13` mismatch in the native visual corpus. FreeX previously modeled the style's body fill as the default workbook background and applied that body style before considering native row and column stripes. Excel renders Medium13 with a pale Accent5 body fill while preserving stronger Accent5 row and value-column stripe fills.

## Fixed Disparity

`PivotStyleMedium13` now uses a pale Accent5 body fill (`Accent5` tint `0.95`) and keeps the stronger Accent5 stripe fill (`Accent5` tint `0.9`). Loaded PivotTable style application now lets native stripe elements win over the body element for striped cells, so the body fill no longer blocks row or first-value-column stripes under `preserveExistingVisualStyles`.

The focused regression covers the expected Excel-like mix:

- row stripe cells use `Accent5` tint `0.9`;
- non-striped body cells use `Accent5` tint `0.95`;
- native first-value-column stripe cells use `Accent5` tint `0.9`;
- adjacent non-striped body cells continue to use `Accent5` tint `0.95`.

## Evidence

Focused test command:

```powershell
dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotTableRefreshServiceTests" --logger "trx;LogFileName=pivot-style-metrics-focused.trx" --verbosity minimal
```

Focused test result: `151 passed`, `1 skipped`.

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

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-style-metrics-20260623\full-after-medium13-body-fill-sync`

All ten fixtures rendered with `Errors: 0` and exact Excel/FreeX PNG dimensions. The layout-options fixture improved from `6.9%` to `6.8%`; the visible gain is a modest but real pale body-fill match in the Medium13 table body. Residual differences in that fixture are now dominated by text weight/rasterization, PivotTable button chrome, expand/collapse glyph details, and spacing.

## Remaining Gaps

FreeX is still not at 100% visual fidelity for native PivotTables. The current largest normalized diffs are date grouping (`7.5%`), layout options (`6.8%`), and basic row/column (`5.8%`). The next slices should target GridView typography/metrics, PivotTable field-button chrome, expand/collapse glyph rendering, and date-grouping presentation.

