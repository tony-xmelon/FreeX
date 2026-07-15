# FreeP Imported Pie Fidelity

Date: 2026-07-16

## Scope

Align the imported automatic-title pie frame used by `06-charts.pptx` slide 3 with the PowerPoint COM reference. The slide has no data labels, so the imported-pie plot-frame branch in `ChartRenderPlanner.BuildFramePlan` owns the circle size and placement.

## COM Evidence

At 1280x720, the exact color-mask bounds were:

| Render | Bounds | Center |
| --- | --- | --- |
| PowerPoint COM | `x=323..857, y=136..671` | `(590.0, 403.5)` |
| FreeP WPF | `x=322..860, y=133..671` | `(591.0, 402.0)` |
| FreeP Avalonia | `x=322..859, y=133..670` | `(590.5, 401.5)` |

The final pixel residual for slide 3 is `0.6601%` for WPF and `0.6696%` for Avalonia. The previous WPF residual was `3.3533%`.

## Change

The imported automatic-title pie plot now uses a measured right offset of `6.5` DIP, a `9.0` DIP upward correction, and a `62.0` DIP height extension. The corpus regression expectation in `ChartBaselineCorpusTests` records the resulting frame.

## Verification

- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore`
- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~ChartRenderPlannerTests"`
- WPF and Avalonia renders of `06-charts.pptx` at `1280x720`, compared against `tools/FreeP.RenderCompare/corpus/pptx-ref/06-charts/slide-03.png`

The neighboring `06-charts` slides remained stable in the same render pass.
