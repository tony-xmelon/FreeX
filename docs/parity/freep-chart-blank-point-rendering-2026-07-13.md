# FreeP Chart Blank Point Rendering - 2026-07-13

Scope: bounded FreeP chart fidelity slice for PowerPoint-authored `c:dispBlanksAs` display semantics on modeled chart data. FreeP already round-trips the chart-level setting; this slice moves the setting into shared render primitive planning so both WPF and Avalonia consume the same behavior.

Implemented evidence:

- `ChartRenderPlanner` resolves null modeled values through `ChartShape.DisplayBlanksAs`, defaulting to PowerPoint-style `gap` when the setting is absent.
- Column and bar primitives keep `gap`/`span` conservative by skipping null bars, and `zero` materializes a zero-height or zero-width rectangular primitive for the blank category.
- Line primitives keep `gap` as a segment break, render `zero` as an explicit zero-valued point with adjacent segments and markers, and render `span` as a line segment connecting the neighboring nonblank points without drawing a marker at the blank slot.
- Area primitives keep `gap` as separate contiguous filled area primitives, render `zero` as a zero-valued point in one filled area, and render `span` as one filled area connecting the neighboring nonblank points.
- Scatter line primitives preserve missing X values as gaps, but when X exists they honor blank Y values for `zero` and `span` through the same shared point/segment planner.

Verification coverage:

- `freep/FreeP.App.Presentation.Tests/ChartRenderPlannerTests.cs`
- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartRenderPlannerTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`

Remaining work:

- Pie and doughnut charts continue to ignore null and nonpositive values as no-sweep slices. This matches the conservative existing primitive model and avoids inventing a visible wedge for a blank point.
- Bubble charts still require authored X/Y coordinates before a bubble can be planned; this slice does not infer missing X coordinates or broaden bubble-size fallback semantics.
- Radar null handling remains unchanged because the current closed polygon primitive has no gap-aware segment contract. A later radar-specific slice should add PowerPoint-backed visual evidence before changing that behavior.
- PowerPoint-authoritative bitmap baselines remain deferred to a machine with registered `PowerPoint.Application` COM.
