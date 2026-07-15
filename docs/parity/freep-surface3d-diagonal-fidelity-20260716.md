# FreeP Imported Surface3D Diagonal Fidelity - 2026-07-16

## Scope

PowerPoint's imported Surface3D reference splits complete cells along the
alternate diagonal. FreeP previously used the `0-2` diagonal for every
triangulated cell, which changed the visible face partition and color regions.
Imported Surface3D render facets now use the `0-3` and `1-3` triangles. Authored
surface charts and incomplete-cell topology remain on their existing paths.

## Evidence

- Focused chart tests: `180 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- `22-chart-baseline-depth` WPF mean channel diff: `4.5656%`, down from `4.5764%`.
- `22-chart-baseline-depth` Avalonia mean channel diff: `4.5465%`, down from `4.5574%`.
- The corpus test verifies the first imported complete cell uses the `0-3` diagonal.

## Verification Commands

```text
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal"
dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release --no-restore
```

Retained WPF/Avalonia renders and heatmaps are under
`artifacts/freep-surface3d-projection-20260716/`.
