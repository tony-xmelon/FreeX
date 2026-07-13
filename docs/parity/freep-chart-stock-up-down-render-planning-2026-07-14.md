# FreeP Stock Chart Up/Down Render Planning - 2026-07-14

## Scope

This slice moves one stock-chart type-specific visual decision into the shared FreeP chart render planner: open/close tick primitives now carry a renderer-neutral price-move classification so WPF and Avalonia consume the same rising, falling, unchanged, and unknown stock-point policy.

## Evidence

- `ChartRenderPlanner.BuildStockPrimitivePlan` still owns high/low stems plus open and close ticks.
- Open and close ticks now carry `ChartStockPriceMove` metadata resolved from the authored open and close values.
- The shared planner assigns deterministic tick strokes for rising, falling, unchanged, and unknown moves before either renderer draws the line segments.
- WPF now routes `ChartType.Stock` through `BuildStockPrimitivePlan` instead of the generic line renderer, matching Avalonia's shared-plan consumption path.

## Validation

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --filter "ChartRenderPlannerTests|RendererNeutralDedupPlannerTests" --configuration Release -m:1 /nr:false`

## Notes

This is no-COM shared render-planning evidence. It does not claim a PowerPoint-authoritative visual baseline or full candlestick/up-down-bar fidelity. A PowerPoint baseline still requires a host with registered `PowerPoint.Application` COM.
