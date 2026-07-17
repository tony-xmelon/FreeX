# FreeP imported chart title-band geometry

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

Fresh PowerPoint COM pixels showed that FreeP's imported chart titles used the
wrong vertical band. The top stock and Surface3D titles were about 5 pixels
too high, while the lower scatter and 100%-stacked titles were about 8 pixels
too low at 1280x720.

The shared frame planner now uses the measured imported offsets: 11 logical
units for stock/Surface3D and 12 logical units for other imported chart
families. Authored charts and the existing non-imported title policy are
unchanged.

## Measurement

At 1280x720 against the same fresh PowerPoint COM capture:

| Render | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | `3.0810%` | `2.7199%` |
| FreeP Avalonia vs PowerPoint | `2.9309%` | `2.4001%` |

The remaining largest residual is the rasterized Surface3D mesh itself; this
slice changes only chart-title placement.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartRenderPlannerTests"` — 169 passed.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ChartBaselineCorpusTests"` — 23 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` — 0 warnings, 0 errors.
- WPF and Avalonia 22-deck renders completed with healthy pixel-diversity checks.
