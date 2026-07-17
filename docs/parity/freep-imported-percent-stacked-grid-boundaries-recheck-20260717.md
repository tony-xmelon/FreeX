# FreeP imported percent-stacked grid boundaries recheck

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

The current PowerPoint COM target registers the imported 100%-stacked category
grid at four shifted plot boundaries: `x=602, 741, 879, 1017` at 1280x720.
FreeP was drawing three shifted category-center lines in addition to the two
outer edges, producing `x=602, 652, 790, 928, 1017`.

The shared planner now emits the four boundary strokes at the measured
positions and rounds the interior coordinates upward to match PowerPoint's
raster registration. Bar slots, horizontal value gridlines, and authored
percent-stacked charts are unchanged.

## Measurement

At 1280x720 against the same fresh PowerPoint COM capture:

| Render | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | `2.7091%` | `2.6873%` |
| FreeP Avalonia vs PowerPoint | `2.3887%` | `2.3668%` |
| WPF stacked-chart ROI | `4.0657%` | `3.9202%` |

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests"` — 192 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` — 0 warnings, 0 errors.
- Final WPF and Avalonia renders completed with healthy pixel-diversity checks.
