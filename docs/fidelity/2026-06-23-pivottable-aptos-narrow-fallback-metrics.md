# PivotTable Aptos Narrow Fallback Metrics - 2026-06-23

This pass continues Windows-local PivotTable parity against desktop Microsoft Excel for the in-scope native PivotTable surface. External connections, Data Model pivots, and OLAP pivots remain excluded.

## Change

Excel can render `Aptos Narrow` from its Office font set even when WPF cannot enumerate that face from the system font collection. FreeX previously fell back to `Arial Narrow` when the Arial Narrow font files were present. That preserved narrow text width, but the WPF render was visibly lighter than Excel across the native PivotTable corpus.

FreeX now prefers `Calibri` with a condensed stretch for unavailable `Aptos Narrow`. On this machine WPF enumerates `Calibri`, while `Aptos Narrow` is unavailable to WPF; `Calibri` condensed better matches Excel's rendered text weight than `Arial Narrow` and improves the largest PivotTable visual deltas without changing capture dimensions.

## Verification

Focused font tests:

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter "FullyQualifiedName~GridViewThemeFontResolutionTests|FullyQualifiedName~GridViewTextDecorationTests" --logger "trx;LogFileName=pivot-grid-font-fallback-tests.trx" --verbosity minimal
```

Result: `44 passed`.

Full native PivotTable corpus visual run:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-grid-metrics-20260623\full-calibri-condensed-rebased`

Result: all `10` native PivotTable fixtures rendered, errors `0`, and every Excel/FreeX PNG pair matched dimensions exactly.

| Fixture | Previous | Current |
| --- | ---: | ---: |
| Basic row/column | `5.8%` | `5.6%` |
| Calculated field/item | `2.2%` | `2.2%` |
| Date grouping | `7.5%` | `7.0%` |
| Filters/sorts | `3.3%` | `3.2%` |
| Grouping/show values | `4.4%` | `4.2%` |
| Layout options | `6.8%` | `6.6%` |
| Multiple pivots one cache | `2.0%` | `2.0%` |
| Report filters | `3.7%` | `3.7%` |
| Slicer/timeline | `2.4%` | `2.4%` |
| Table source filters | `4.4%` | `4.4%` |

## Remaining

FreeX is still not at 100% native PivotTable visual fidelity. The remaining largest diffs are still date grouping (`7.0%`), layout options (`6.6%`), and basic row/column (`5.6%`). The next higher-value areas are PivotTable style element granularity, expand/collapse glyph geometry, field-button chrome, and row/column/text placement details that are not solved by font fallback alone.
