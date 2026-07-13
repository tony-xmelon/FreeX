# FreeP Chart Blank Point Rendering - 2026-07-13

Scope: bounded FreeP chart fidelity slice for PowerPoint-authored `c:dispBlanksAs` display semantics on modeled chart data. FreeP already round-trips the chart-level setting; this slice moves the setting into shared render primitive planning so both WPF and Avalonia consume the same behavior.

Implemented evidence:

- `ChartRenderPlanner` resolves null modeled values through `ChartShape.DisplayBlanksAs`, defaulting to PowerPoint-style `gap` when the setting is absent.
- Column and bar primitives keep `gap`/`span` conservative by skipping null bars, and `zero` materializes a zero-height or zero-width rectangular primitive for the blank category.
- Line primitives keep `gap` as a segment break, render `zero` as an explicit zero-valued point with adjacent segments and markers, and render `span` as a line segment connecting the neighboring nonblank points without drawing a marker at the blank slot.
- Area primitives keep `gap` as separate contiguous filled area primitives, render `zero` as a zero-valued point in one filled area, and render `span` as one filled area connecting the neighboring nonblank points.
- Scatter line primitives preserve missing X values as gaps, but when X exists they honor blank Y values for `zero` and `span` through the same shared point/segment planner.
- Radar primitives now use a renderer-neutral path-list contract for null points: absent or explicit `gap` emits deterministic open segments around blanks, `zero` materializes the blank spoke at chart center, and `span` bridges the neighboring nonblank spokes. Both WPF and Avalonia consume the same `primitive.Paths` list.
- Pie and doughnut primitives now make the conservative no-sweep policy explicit for null, zero, and negative values while preserving original point identity for visible slices. This keeps point colors, point styles, and pie data labels aligned with their authored category indexes after skipped points.

Verification coverage:

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs`
- `ChartRenderPlannerTests.BuildRadarPrimitivePlan_DisplayBlanksAsGap_BreaksSegmentsAroundBlankPoint`
- `ChartRenderPlannerTests.BuildRadarPrimitivePlan_DefaultDisplayBlanksAsGap_BreaksSegmentsAroundBlankPoint`
- `ChartRenderPlannerTests.BuildRadarPrimitivePlan_DisplayBlanksAsZero_MaterializesBlankPointAtCenter`
- `ChartRenderPlannerTests.BuildRadarPrimitivePlan_DisplayBlanksAsSpan_BridgesBlankPoint`
- `ChartRenderPlannerTests.BuildPieSlicePrimitives_NullAndNonpositiveValuesHaveNoSweepAndPreservePointIdentity`
- `ChartRenderPlannerTests.BuildPieSlicePrimitives_AllNullOrNonpositiveValuesReturnNoVisibleSlices`
- `ChartRenderPlannerTests.BuildDoughnutSlicePrimitives_NullAndNonpositiveValuesHaveNoSweepPerRing`
- `ChartRenderPlannerTests.BuildDataLabelPlans_PieLabelsPreserveOriginalCategoriesAfterNoSweepPoints`
- `RendererNeutralDedupPlannerTests.WpfAndAvaloniaSlideCanvases_UseRendererNeutralAreaScatterBubbleAndRadarPlanning`
- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartRenderPlannerTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`

Remaining work:

- Bubble charts still require authored X/Y coordinates before a bubble can be planned; this slice does not infer missing X coordinates or broaden bubble-size fallback semantics.
- PowerPoint-authoritative bitmap baselines for radar and pie/doughnut blank-point cases remain deferred to a machine with registered `PowerPoint.Application` COM. This lane is shared render-planning and renderer-consumption evidence, not a COM-backed visual baseline.
