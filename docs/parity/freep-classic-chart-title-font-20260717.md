# FreeP classic chart title font parity

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

PowerPoint's SVG shape export for the imported chart keeps the chart title as
vector text using Arial at 24 CSS pixels, which corresponds to its 18pt
classic chart-title default. The same export uses Calibri for the axis labels.
The chart XML has no authored chart-space text properties, so this is a
classic Office default rather than a deck-specific font override.

FreeP previously routed chart titles through the renderer's general Calibri
fallback. The shared chart plan now carries an optional title font family and
sets it to Arial only for styleless classic Office charts. Explicitly styled
charts retain the renderer default, and axis, legend, and data-label roles are
unchanged.

## Measurement

At 1280x720, compared with the same fresh PowerPoint COM capture:

| Render | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | `3.5690%` | `3.1019%` |

The residual is still dominated by the rasterized Surface3D mesh; the title
change does not alter the mesh geometry or painter order.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartRenderPlannerTests"` — 167 passed.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ChartBaselineCorpusTests"` — 23 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore` — 0 warnings, 0 errors.
- `FreeP.RenderCompare --freep-render ... --width 1280 --height 720` — 1 slide rendered with healthy pixel diversity.
