# FreeP Chart Edge Manual Layout - 2026-07-06

## Scope

This slice extends renderer-neutral chart manual layout planning for PPTX chart `c:manualLayout` values that use `edge` modes or mixed `factor`/`edge` modes.

## Behavior

- `xMode` and `yMode` values are resolved as proportional offsets inside the chart base rectangle.
- `wMode="factor"` and `hMode="factor"` remain proportional width and height values.
- `wMode="edge"` and `hMode="edge"` resolve as right and bottom edge coordinates inside the same base rectangle.
- Resolved rectangles are clamped to the base rectangle and ignored when they collapse to a non-positive area.

## Coverage

The shared `ChartRenderPlanner` now applies these rules to both plot-area and legend manual layouts, so WPF and Avalonia remain thin consumers of the same planned chart bounds. Reader/writer coverage from the previous factor-mode slice already preserves `edge` mode metadata; this slice does not add new package IO behavior.

## Verification

Focused verification for this slice:

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~ChartRenderPlannerTests`
- `git diff --check`

## Remaining Work

No PowerPoint COM visual baseline was required or run for this no-COM slice. Exact PowerPoint placement may still need visual tuning once a COM-capable baseline lane is available, especially for nuanced `layoutTarget` differences.
