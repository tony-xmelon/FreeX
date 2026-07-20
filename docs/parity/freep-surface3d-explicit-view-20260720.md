# FreeP Surface3D Explicit View3D Slice

Date: 2026-07-20

## Scope

PowerPoint COM saved a second copy of the Surface3D baseline with authored
`c:view3D` settings: `rotX=25`, `rotY=35`, `perspective=54`, `depthPercent=125`,
and `rAngAx=0`. The source deck is committed as
`tools/FreeP.RenderCompare/corpus/25-chart-surface3d-view3d.pptx`.

The imported 3x3 Surface3D path previously applied its measured default frame,
boundary facets, vertex offsets, and lighting whenever imported text metrics
were present. That made an authored camera ineffective. The planner now keeps
those corrections only when `view3D` is absent; authored views use the general
projection/frame/facet/color path while retaining imported text metrics for
labels and chart chrome.

## Evidence

All images are 1280x720 and were produced by the same Release RenderCompare
artifact and a fresh PowerPoint COM export.

| Case | WPF vs PowerPoint | Avalonia vs PowerPoint | Avalonia vs PowerPoint before |
| --- | ---: | ---: | ---: |
| Explicit `view3D` deck | 3.8984% | 1.1290% | 1.1132% |
| Default `22-chart-baseline-depth` control | 2.5856% | 1.0919% | 1.0906% |

The explicit-view WPF result improved from `4.2302%` to `3.8984%`. The
default control remained on its existing calibrated route. The small Avalonia
increase is retained as a known cross-host residual; this slice is a dispatch
correction, not a claim of complete Surface3D camera parity.

Reference SHA-256:

- Deck: `0D15BE3933462FD010688AFFB6D5E3C6E24762E2BB1BCC80025D2CFB6EF5718A`
- PowerPoint PNG: `5DFD1BDA600B75915D4468F49541A1CB710B3CE4C123ED1F37DF945D7FB0B9DF`

## Verification

- `dotnet build freep/FreeP.App.Presentation/FreeP.App.Presentation.csproj --configuration Release --no-restore`
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~BuildSurfaceGeometryPlan"`
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore`
- Fresh COM comparisons for the explicit-view deck and the default control.
