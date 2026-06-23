# PivotTable Timeline Visual Anchor Fidelity - 2026-06-23

This pass continued Windows-local PivotTable parity against desktop Microsoft Excel. External connections, Data Model pivots, and OLAP pivots remain excluded.

## Fixed Disparity

The Excel-authored native slicer/timeline fixture stores the visible timeline drawing as DrawingML 2012 `<timeslicer>` markup and stores timeline range state under nested `<state><selection>` / `<state><bounds>` nodes. FreeX previously recognized `<slicer>` and `<timeline>` drawing links only, and read only root timeline-cache date attributes. As a result, the visual harness included the slicer but clipped or omitted the timeline object from `--pivot-sheet-ranges`.

`XlsxSlicerTimelineMetadataReader` now:

- resolves DrawingML `<timeslicer name="...">` anchors to `TimelineModel.DrawingAnchor`;
- reads nested timeline selected/bounds dates and normalizes them to `yyyy-MM-dd`;
- keeps the existing slicer/timeline metadata and fallback behavior unchanged.

## Evidence

Focused fixture:

```powershell
dotnet run --no-build --project tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release -- C:\Users\ali\freex-xlsx-verify\excel-smoke\pivot-native-layout-next-20260623\generated-excel-pivots\Excel_native_pivot_slicer_timeline_001.xlsx --pivot-sheet-ranges --export-excel-pngs --fail-on-dimension-mismatch --out C:\Users\ali\freex-xlsx-verify\visual\pivot-native-timeline-visual-20260623\after-reader-fix --threshold 25 --pixel-tolerance 8
```

Result: `Errors: 0`; capture expanded to `Pivot Slicer Timeline!A1:P14 (SheetUsedRangeWithNativeVisualFilters)` and the normalized mean diff improved from `3.3%` to `2.4%`.

Full native PivotTable visual corpus after the fix:

| Fixture | Diff |
| --- | ---: |
| Basic row/column | 5.8% |
| Calculated field/item | 2.2% |
| Date grouping | 7.5% |
| Filters/sorts | 3.3% |
| Grouping/show values | 4.4% |
| Layout options | 6.9% |
| Multiple pivots one cache | 2.0% |
| Report filters | 3.7% |
| Slicer/timeline | 2.4% |
| Table source filters | 4.4% |

Evidence root: `C:\Users\ali\freex-xlsx-verify\visual\pivot-native-timeline-visual-20260623\full-after-reader-fix`.

## Remaining Gaps

FreeX is still not at 100% visual fidelity for native PivotTables. The timeline fixture now includes both native visual filter objects, but residual image differences remain from simplified slicer/timeline chrome, PivotTable field-button chrome, Excel-vs-WPF text rasterization, row/column sizing, and PivotTable style element granularity.

The next visual slices should target the largest remaining corpus deltas: date grouping (`7.5%`), layout options (`6.9%`), and basic row/column (`5.8%`).

## Verification

```powershell
dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter XlsxSlicerTimelineMetadataReaderTimelineTests
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release
```

Focused test result: `1 passed`. Tool build result: `0 warnings`, `0 errors`.
