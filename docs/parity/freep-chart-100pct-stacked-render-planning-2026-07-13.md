# FreeP 100% Stacked Chart Render Planning Evidence - 2026-07-13

## Scope

This slice moves one type-specific chart decision into the shared FreeP chart render planner: `ColumnStacked100` and `BarStacked100` now normalize each stacked category to the full plot height or width before WPF and Avalonia consume the planned primitives.

## Evidence

- `ChartRenderPlanner.ComputePrimaryValueAxisRange` uses a default `0..1` axis range for 100% stacked charts when the authored package does not specify value-axis bounds.
- `ChartRenderPlanner.BuildColumnPrimitives` resolves `ColumnStacked100` segment heights from the absolute per-category total.
- `ChartRenderPlanner.BuildBarPrimitives` resolves `BarStacked100` segment widths from the absolute per-category total.
- `ChartRenderPlanner.BuildDataLabelPlans` anchors 100% stacked column labels against the same normalized shared geometry.

## Validation

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --filter ChartRenderPlannerTests --configuration Release -m:1 /nr:false`

## Notes

This is no-COM shared render-planning evidence. It does not claim a PowerPoint-authoritative visual baseline. WPF and Avalonia remain thin primitive consumers for this path; broader chart visual baselines and other type-specific decisions remain follow-up work.
