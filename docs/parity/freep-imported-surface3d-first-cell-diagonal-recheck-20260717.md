# FreeP imported Surface3D first-cell diagonal recheck

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

After the imported chart-title-band correction, a fresh PowerPoint COM target
showed the blank low-band cell's color partition still assigning too much of
the middle fold to the blue triangle. Rechecking the exact first cell against
the current target favors the standard `0-3` and `1-3` triangle pair, including
the blank cell, instead of the older special-case `0-2` split.

The planner now uses the same imported complete-cell triangulation for the
blank and nonblank cells. The semantic blank vertex fallback and all authored
Surface3D geometry remain unchanged.

## Measurement

At 1280x720 against the same fresh PowerPoint COM capture:

| Render | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | `2.7199%` | `2.7091%` |
| FreeP Avalonia vs PowerPoint | `2.4001%` | `2.3887%` |

The improvement is localized to the first blank-cell facet partition; the
remaining larger residual is the broader rasterized Surface3D mesh.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests"` — 192 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` — 0 warnings, 0 errors.
- Final WPF and Avalonia renders completed with healthy pixel-diversity checks.
