# PivotTable Timeline Source Sheet And Layout Fidelity - 2026-06-23

This pass continues Windows-local PivotTable parity against desktop Microsoft Excel for the in-scope native PivotTable surface. External connections, Data Model pivots, and OLAP pivots remain excluded.

## Change

Native Excel timelines are stored as workbook-level timeline/cache parts plus a DrawingML `timeslicer` shape anchored on a worksheet. FreeX already parsed the drawing anchor and shape name, but the timeline model did not retain the source sheet that owned the drawing. As a result, visual filtering could only show timelines connected to a pivot table name on the active sheet; an Excel-authored timeline with missing or indirect pivot connection metadata could be dropped even when its native drawing was anchored on the visible sheet.

This slice:

- Stores `TimelineModel.SourceSheetName` from the native timeline drawing metadata.
- Includes anchored timelines on the active sheet even when `SourcePivotTableName` is absent or not enough to prove the connection.
- Adds source-sheet state to the native visual filter cache invalidation snapshot.
- Renders WPF native timelines through the shared `TimelineLayoutBuilder` geometry, including date label, selected range, and start/end handles, rather than the old hardcoded middle selection rectangle.

## Verification

Focused tests:

```powershell
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~SlicerTimelinePlannerTests" --logger "trx;LogFileName=pivot-timeline-planner-tests.trx" --verbosity minimal
```

Result: `21 passed`, `2 skipped` benchmark tests.

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~RenderNativeControls_ReusesPixelsPerDipAcrossClippedTextCalls" --logger "trx;LogFileName=pivot-timeline-gridview-source-tests.trx" --verbosity minimal
```

Result: `1 passed`.

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~XlsxAdapter_LoadsSlicerTimelineDrawingAnchorsAndShapeNames" --logger "trx;LogFileName=pivot-timeline-reader-tests.trx" --verbosity minimal
```

Result: `1 passed`.

Visual compare:

```powershell
dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-layout-next-20260623\generated-excel-pivots\Excel_native_pivot_slicer_timeline_001.xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out C:\Users\ali\freex-xlsx-verify\visual\pivot-native-timeline-source-sheet-20260623\slicer-timeline-after-layout --threshold 25 --pixel-tolerance 8
```

Result: rendered `1`, skipped `0`, errors `0`, exact Excel/FreeX dimensions `1490x338`, nearest-neighbor diff `2.4%`, exact changed pixels `39.13%`.

Full native PivotTable corpus visual run:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-timeline-source-sheet-20260623\full-after-timeline-layout`

Result: all `10` native PivotTable fixtures rendered, errors `0`, and every Excel/FreeX PNG pair matched dimensions exactly. One-decimal nearest-neighbor diffs remained:

| Fixture | Diff |
| --- | ---: |
| Basic row/column | `5.8%` |
| Calculated field/item | `2.2%` |
| Date grouping | `7.5%` |
| Filters/sorts | `3.3%` |
| Grouping/show values | `4.4%` |
| Layout options | `6.8%` |
| Multiple pivots one cache | `2.0%` |
| Report filters | `3.7%` |
| Slicer/timeline | `2.4%` |
| Table source filters | `4.4%` |

## Remaining

FreeX is still not at 100% native PivotTable visual fidelity. This slice makes timeline ownership and geometry more faithful, but the slicer/timeline fixture's headline diff is unchanged at one decimal. The residual gap is dominated by simplified slicer/timeline chrome, PivotTable field-button chrome, Excel-vs-WPF text rasterization, row/column metrics, and remaining PivotTable style-element granularity.
