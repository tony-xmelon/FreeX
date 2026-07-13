# FreeP Chart Bubble Sizing Semantics - 2026-07-13

Scope: bounded FreeP chart fidelity slice for PowerPoint-authored bubble sizing metadata. This avoids export/video ownership, renderer-local sizing policy, and unrelated chart families.

Implemented evidence:

- `ChartShape` now carries PowerPoint-default bubble metadata: scale `100`, size representation `area`, and hidden negative bubbles.
- PPTX chart IO reads and writes `c:bubbleScale`, `c:sizeRepresents`, and `c:showNegBubbles` on bubble charts while preserving existing X/Y/size formula-range behavior.
- `ChartRenderPlanner.BuildBubblePrimitivePlan` owns bubble radius and missing-X fallback semantics before WPF or Avalonia consume `ChartBubblePrimitive` values.
- Area mode keeps square-root radius normalization, width mode uses linear radius normalization, bubble scale deterministically changes maximum radius, and hidden negative bubbles are skipped.
- Bubble points without authored `c:xVal` entries now use the zero-based point index as the renderer-neutral X coordinate, matching the shared chart layout engine's existing scatter/bubble fallback.
- Missing Y coordinates remain unplanned; the planner still requires a real vertical value before emitting a bubble primitive.

Verification coverage:

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs`
- `ChartRenderPlannerTests.BuildBubblePrimitivePlan_MissingXCoordinatesUsePointIndexFallback`
- `ChartRenderPlannerTests.BuildBubblePrimitivePlan_MissingYCoordinatesRemainUnplanned`
- `freep/FreeP.App.Host.Tests/ChartTests.cs`

Remaining work:

- PowerPoint-authoritative visual baselines for authored bubble charts still require a machine with registered `PowerPoint.Application` COM.
- This is render-plan evidence only; it does not add a PowerPoint COM visual-baseline capture on this machine.
- Broader chart type-specific visual fidelity remains deferred outside this slice.
