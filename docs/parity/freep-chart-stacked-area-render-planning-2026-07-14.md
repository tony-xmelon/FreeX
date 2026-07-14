# FreeP Stacked Area Render Planning - 2026-07-14

## Scope

This slice moves the remaining stacked-area band decision into the shared FreeP chart render planner. `ChartType.AreaStacked` now uses category totals for its primary value-axis range and emits renderer-neutral area polygons whose baselines follow the prior stacked series instead of the flat plot baseline used by ordinary area charts.

## Evidence

- `ChartRenderPlanner.ComputePrimaryValueAxisRange` resolves stacked area bounds from per-category positive and negative totals.
- `ChartRenderPlanner.BuildAreaSeriesPrimitives` keeps ordinary area charts on the existing flat-baseline path.
- `ChartType.AreaStacked` now builds cumulative band baselines in shared code before WPF and Avalonia draw the same `ChartAreaSeriesPrimitive` records.
- The WPF and Avalonia slide canvases already consume `BuildAreaSeriesPrimitives`, so no renderer-local stacked-area policy was added.

## Validation

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --filter ChartRenderPlannerTests --configuration Release -m:1 /nr:false`

## Notes

This is no-COM shared render-planning evidence. It does not claim a PowerPoint-authoritative chart visual baseline, exact Office area anti-aliasing, or full authored mixed-sign corpus coverage. Those still require broader real-deck and PowerPoint COM-capable validation.
