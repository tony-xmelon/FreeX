# FreeP Imported Combo Legend Line Key - 2026-07-16

## Scope

Imported combo charts with a secondary line series now retain PowerPoint's
line-style legend key. Column-series keys remain filled swatches; line-series
keys draw the series stroke through the swatch and a centered square marker.

## Evidence

- `19-chart-labels.pptx`, slide 3, contains the imported clustered-column and
  secondary-axis line combo used by the PowerPoint baseline.
- The shared chart plan now marks imported line legend items explicitly, and
  both WPF and Avalonia renderers consume that marker instead of treating every
  legend key as a rectangle.
- WPF mean channel diff improved from `2.3670%` to `2.2654%`.
- Avalonia mean channel diff improved from `2.4691%` to `2.3552%`.
- All renders remained `1280x720` and matched the reference dimensions.

## Verification

```text
dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartLabelsCorpus_ImportedComboUsesPowerPointOverlayAndLegendStyling" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Retained candidate renders and heatmaps are under
`artifacts/freep-combo-legend-line-candidate-20260716/`.
