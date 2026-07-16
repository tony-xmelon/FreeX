# FreeP Imported Surface3D Perspective - 2026-07-16

## Scope

Align imported PowerPoint Surface3D vertices with the projected chart frame
while preserving the existing authored-surface projection. The imported path
now uses the frame's deeper rear axis and perspective-shortened category span;
the front category span remains unchanged.

The imported diagonal-face lighting floor is retained in the same slice so the
second triangle in a cell does not inherit the first triangle's near-row
falloff.

## Evidence

- 22-chart-baseline-depth.pptx, slide 1, is compared with the checked-in
  PowerPoint reference at 1280x720.
- The imported rear-left vertex now lands at the projected depth wall
  (x=124 in the normalized 360-wide plot), and the first-cell triangle
  regression records the new x=62.0 and x=194.8 vertices.
- WPF mean channel diff improved from 4.4396% to 4.3677%.
- Avalonia mean channel diff improved from 4.4217% to 4.3482%.
- Both renders remain 1280x720.

## Verification

    dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
    dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1

Focused chart tests passed 181/181; the build completed with 0 warnings and
0 errors. Retained renders and heatmaps are under
artifacts/freep-surface-perspective-candidate-20260716/.
