# FreeP surface grid rendering - 2026-07-14

Scope: bounded FreeP chart fidelity slice for imported PowerPoint surface and
3-D surface charts. This keeps the change inside chart render planning and the
two slide-canvas consumers; it does not claim PowerPoint-authoritative contour
or perspective geometry.

What changed:

- WPF now routes `ChartType.Surface` and `ChartType.Surface3D` through the same
  shared `ChartRenderPlanner.BuildSurfaceCellPrimitives` plan already consumed
  by Avalonia, instead of reusing column primitives.
- `ChartRenderPlanner` surface-cell planning preserves the series/category grid
  coordinates when a modeled cell is blank, so missing points do not reflow the
  visual matrix.
- Renderer-neutral source guards now require both slide canvases to consume the
  shared `ChartSurfaceCellPrimitive` path.

Verification:

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs`
- `ChartRenderPlannerTests.BuildSurfaceCellPrimitives_MapsSeriesAndCategoriesToValueGrid`
- `ChartRenderPlannerTests.BuildSurfaceCellPrimitives_SkipsBlankCellsWithoutReflowingGrid`
- `RendererNeutralDedupPlannerTests.WpfAndAvaloniaSlideCanvases_UseRendererNeutralAreaScatterBubbleRadarAndStockPlanning`

Remaining gaps:

- PowerPoint-authoritative surface chart visual baselines.
- True contour/wireframe and 3-D perspective surface geometry.
- Larger real-deck corpus coverage for imported surface charts.
