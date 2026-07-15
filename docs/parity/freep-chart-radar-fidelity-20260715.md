# FreeP imported radar-chart fidelity - 2026-07-15

## Scope

The PowerPoint corpus deck `18-chart-types.pptx`, slide 3, contains a two-series five-category radar chart with a marker-style chart group and a `0..90` value scale.

## Changes

- Imported radar charts now render nine PowerPoint-style rings and the complete `0..90` value-label sequence.
- Radial value labels are carried in the renderer-neutral radar plan and rendered by both WPF and Avalonia.
- Imported radar plots use the larger PowerPoint frame, measured center offsets, full category-label boxes, and angle-specific label spacing so `Speed`, `Power`, `Agility`, `Stamina`, and `Tech` remain readable.
- Imported radar grid/spoke strokes and series stroke weight now match the darker, heavier PowerPoint treatment.
- Authored/non-imported radar charts retain the existing four-ring behavior.

## Verification

- `dotnet build freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release`: passed, 0 warnings, 0 errors.
- Focused presentation tests (`ChartBaselineCorpusTests` and `ChartRenderPlannerTests`): 179 passed.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- WPF render of `18-chart-types.pptx` at 1280x720: `1.2423%` mean channel diff on `slide-03` against `tools/FreeP.RenderCompare/corpus/pptx-ref/18-chart-types/slide-03.png`.
- Avalonia render of `18-chart-types.pptx` at 1280x720: `1.2690%` mean channel diff on `slide-03` against the same reference.

Evidence is retained under `artifacts/freep-radar-fidelity-20260715/`.
