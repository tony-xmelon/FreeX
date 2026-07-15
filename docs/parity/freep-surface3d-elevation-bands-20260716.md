# FreeP Imported Surface3D Elevation Bands - 2026-07-16

## Scope

The PowerPoint reference for `22-chart-baseline-depth.pptx` slide 1 uses
discrete elevation bands for the imported `Surface3D` chart. The previous
rounding rule collapsed the fixture's lower surface into the wrong color
bands. The shared planner now uses explicit imported thresholds for blue,
orange, green, and the high yellow band while authored surface charts retain
their existing interpolation path.

## Evidence

- PowerPoint reference facet probes show one blue lower triangle, four orange
  triangles, and three green triangles in the eight imported render facets.
- WPF mean channel diff: `4.5555%`, down from `4.5656%`.
- Avalonia mean channel diff: `4.5369%`, down from `4.5465%`.
- The focused corpus test asserts the eight-facet color sequence and existing
  blank-cell topology, projected frame, diagonal, and outline behavior.

## Verification

```text
dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release --no-restore
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal"
```

The final WPF/Avalonia renders and heatmaps are retained under
`artifacts/freep-surface3d-baseline-fidelity-20260716/final/`.
