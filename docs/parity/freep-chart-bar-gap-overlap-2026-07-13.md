# FreeP Bar Gap And Series Overlap Evidence - 2026-07-13

## Scope

Bounded PowerPoint chart parity for `c:gapWidth` and `c:overlap` on 2-D bar and column charts.

## Implemented

- `ChartShape.BarGapWidthPercent` and `ChartShape.BarOverlapPercent` preserve authored bar/column spacing metadata.
- `PptxChartReader` reads `c:gapWidth/@val` and `c:overlap/@val` from `c:barChart`, clamped to the PowerPoint slider ranges.
- `PptxChartWriter` writes authored gap width and overlap values back into `c:barChart` before axis references.
- `ChartRenderPlanner` resolves one shared bar-cluster spacing plan for column primitives, horizontal bar primitives, and their data-label bounds, so WPF and Avalonia consume the same renderer-neutral geometry.
- `SlideCloner` preserves the spacing metadata when duplicating chart shapes.

## Evidence

- `ChartRenderPlannerTests.ResolveBarClusterSpacing_DefaultMatchesExistingPowerPointClusterGeometry`
- `ChartRenderPlannerTests.BuildColumnPrimitives_UsesAuthoredGapWidthAndOverlap`
- `ChartRenderPlannerTests.BuildBarPrimitives_UsesAuthoredGapWidthAndOverlap`
- `ChartRenderPlannerTests.BuildDataLabelPlans_ColumnLabelsFollowAuthoredGapWidthAndOverlap`
- `ChartTests.RoundTrip_ColumnChart_GapWidthAndOverlapPreservedInPackageAndModel`
- `ChartTests.SlideCloner_ChartPreservesTypeSpecificChartMetadata`

## Limitations

This is OOXML round-trip and shared render-planning evidence. It does not claim PowerPoint-authoritative visual parity because no PowerPoint COM visual baseline was produced in this lane. 3-D bar/column spacing and broader type-specific chart visual decisions remain follow-up work.
