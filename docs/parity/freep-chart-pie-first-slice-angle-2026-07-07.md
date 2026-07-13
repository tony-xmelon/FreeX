# FreeP Pie And Doughnut First-Slice Angle Evidence - 2026-07-07

## Scope

Bounded PowerPoint chart parity for `c:firstSliceAng` on `c:pieChart` and `c:doughnutChart`.

## Implemented

- `ChartShape.FirstSliceAngleDegrees` preserves authored first-slice angle metadata.
- `PptxChartReader` reads `c:firstSliceAng/@val` for pie and doughnut charts only.
- `PptxChartWriter` writes `c:firstSliceAng` for pie and doughnut charts when the model carries an authored value, preserving schema order around `c:dLbls` and `c:holeSize`.
- `ChartRenderPlanner` starts shared `ChartPieSlicePrimitive` planning from the authored angle for both pie and doughnut charts, so WPF and Avalonia continue to consume the same renderer-neutral primitives.

## Evidence

- `ChartRenderPlannerTests.BuildPieSlicePrimitives_UsesAuthoredFirstSliceAngle`
- `ChartRenderPlannerTests.BuildDoughnutSlicePrimitives_UsesAuthoredFirstSliceAngleForEveryRing`
- `ChartTests.RoundTrip_PieChart_FirstSliceAnglePreservedInPackageAndModel`
- `ChartTests.RoundTrip_PieChart_AbsentFirstSliceAngleStaysAbsentAndDefault`
- `ChartTests.RoundTrip_DoughnutChart_FirstSliceAnglePreservedInPackageAndModel`
- `ChartTests.SlideCloner_ChartPreservesTypeSpecificChartMetadata`

## Limitations

This is OOXML round-trip and shared render-planning evidence. It does not claim PowerPoint-authoritative visual parity because no PowerPoint COM visual baseline was produced in this lane.
