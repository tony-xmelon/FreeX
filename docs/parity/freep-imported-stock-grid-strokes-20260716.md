# FreeP Imported Stock Grid Strokes - 2026-07-16

## Scope

Match the black major-grid and axis-tick strokes PowerPoint uses for the
imported stock chart in 22-chart-baseline-depth.pptx. The rule is limited to
imported stock charts; combo, authored, and other chart families retain their
existing stroke resolution.

## Evidence

- PowerPoint reference pixels in the stock plot are black on the major
  horizontal and category grid lines.
- FreeP previously emitted gray #7F7F7F and #BFBFBF antialiased lines.
- The imported stock scene now plans opaque black, 1.0 DIP grid and tick
  strokes.
- WPF mean channel diff improved from 4.3677% to 4.3367%.
- Avalonia mean channel diff improved from 4.3482% to 4.2562%.

## Verification

    dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
    dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1

Retained renders and heatmaps are under
artifacts/freep-stock-grid-candidate-20260716/.
