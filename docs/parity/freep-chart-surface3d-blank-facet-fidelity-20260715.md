# FreeP Surface3D Blank-Facet Fidelity - 2026-07-15

This slice improves the shared Surface3D render plan for the PowerPoint-authored
`22-chart-baseline-depth.pptx` corpus deck.

## Changes

- Imported `varyColors` Surface3D facets now use discrete Office-like theme bands
  instead of interpolated muted colors.
- Missing interior grid points remain absent from the semantic `Points` model, but
  the render plan interpolates their position and value from adjacent authored
  points so incomplete cells form a continuous triangulated surface.
- WPF and Avalonia continue to consume the same shared `ChartSurfaceGeometryPlan`.

## Evidence

- PowerPoint reference: `tools/FreeP.RenderCompare/corpus/pptx-ref/22-chart-baseline-depth/slide-01.png`
- WPF render: `artifacts/surface3d-final/wpf/slide-01.png`
- Avalonia render: `artifacts/surface3d-final/avalonia/slide-01.png`
- WPF mean channel diff: `4.5828%` at `1280x720` (previous shared-plan render: `4.8219%`).
- Avalonia mean channel diff: `4.5634%` at `1280x720`.
- The corpus planner contract now expects four logical facets and eight
  render triangles, including the two blank-cell interpolation closures.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests"`
  - 177 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore`
  - 0 warnings, 0 errors.

Exact PowerPoint surface lighting, shading, and all chart-family visual decisions
remain broader follow-up work; this slice specifically closes the blank-cell
coverage and facet-band mismatch in the shared render path.
