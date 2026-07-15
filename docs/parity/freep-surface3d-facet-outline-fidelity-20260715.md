# FreeP Surface3D Facet Outline Fidelity - 2026-07-15

## Scope

Imported PowerPoint Surface3D charts previously rendered each opaque triangulated
facet with a semi-opaque white outline. The outline is not present in the
PowerPoint reference and creates bright diagonal seams across the colored faces.
The shared planner now keeps those imported Surface3D facet strokes transparent.
Classic and authored surface charts retain their existing white facet outline.

## Evidence

- Focused chart tests: `180 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- `22-chart-baseline-depth` WPF mean channel diff: `4.5764%`, down from `4.5828%`.
- `22-chart-baseline-depth` Avalonia mean channel diff: `4.5574%`, down from `4.5634%`.
- Surface quadrant WPF diff: `6.3915%` to `6.3619%`.
- Prior combo control remained unchanged: WPF `2.3670%`, Avalonia `2.4691%` on `19-chart-labels` slide 3.

## Verification Commands

```text
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal"
dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release --no-restore
```

Retained WPF/Avalonia renders and heatmaps are under
`artifacts/freep-imported-grid-styling-20260715/`.
