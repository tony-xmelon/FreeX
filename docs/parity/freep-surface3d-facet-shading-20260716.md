# FreeP Imported Surface3D Facet Shading - 2026-07-16

The imported `Surface3D` corpus chart uses PowerPoint's projected-face shading
for `varyColors`. The previous shared planner selected a color from each
triangle's average value, which collapsed the rear green facets into one tone
and assigned the first rear-row face the wrong orange band.

The imported Surface3D path now preserves the eight COM-observed facet tones:
blue, light orange, dark orange, orange, and four distinct green shades.
Authored surface charts retain value-based color interpolation.

## Evidence

- Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`
- PowerPoint COM reference: `tools/FreeP.RenderCompare/corpus/pptx-ref/22-chart-baseline-depth/slide-01.png`
- Render size: `1280x720`

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | `3.8627%` | `3.8493%` |
| Avalonia | `0.9703%` | `0.9702%` |

The exact color sequence is asserted by `ChartBaselineCorpusTests`, while the
semantic blank point remains absent from `Points` and the existing interpolated
render fallback remains unchanged.

## Verification

```text
dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Focused presentation tests passed `183/183`; the RenderCompare build completed
with `0` warnings and `0` errors.
