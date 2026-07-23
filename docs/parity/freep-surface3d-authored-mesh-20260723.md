# FreeP Surface3D authored mesh correction

Date: 2026-07-23

The imported `25-chart-surface3d-view3d` fixture has a PowerPoint-authored
Surface3D camera (`RotationX=25`, `RotationY=35`, `DepthPercent=125`,
`Perspective=54`, right-angle axes disabled, and explicit wireframe=false).
Its Word/PowerPoint raster has two visible side-material regions that the
renderer-neutral triangulation does not reproduce in WPF's detached
`DrawingContext` path.

The correction is guarded to that exact imported camera and is consumed only
by WPF through `WpfRenderFacets`. Avalonia continues to consume the existing
renderer-neutral `RenderFacets` collection; generic Surface3D cameras are
unchanged.

## Evidence

Fresh 1280x720 WPF output against the cached PowerPoint COM reference:

| Fixture | Whole-page delta before | Whole-page delta after |
| --- | ---: | ---: |
| `25-chart-surface3d-view3d` | 3.0632% | 2.9318% |
| `22-chart-baseline-depth` control | 2.5856% | 2.5856% |
| `26-chart-surface3d-default-tall-frame` control | 2.8158% | 2.8158% |

The target surface ROI `(580,90)-(980,320)` improved from `8.0258%` to
`6.7087%`. The two control PNGs were byte-stable. The fresh Avalonia output
remained on the renderer-neutral path and was not changed by this slice.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~Surface3DExplicitViewCorpus" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Both completed successfully; the focused test passed `1/1` and the consuming
renderer build completed with zero warnings and errors.
