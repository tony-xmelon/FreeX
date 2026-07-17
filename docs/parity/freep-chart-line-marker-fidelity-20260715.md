# FreeP chart line-marker fidelity - 2026-07-15

## Scope

The PowerPoint corpus deck `06-charts.pptx`, slide 2, is a two-series line chart with chart-level markers enabled. The source chart has no per-series marker symbols, so PowerPoint supplies its default marker sequence and line-chart axis scale.

## Changes

- Imported line-marker charts now use the PowerPoint default marker sequence: diamond, square, X, and triangle, repeating for additional series. Stock-chart fallback lines use the chart-specific sequence observed in the PowerPoint baseline: diamond, square, triangle, and X.
- Explicit series and point marker styles still take precedence over the automatic sequence.
- Imported line-marker charts use a larger default marker radius and the heavier imported line stroke used by the reference chart.
- Imported line-marker charts without explicit axis bounds use a six-interval nice range, matching the reference chart's `0..120` value axis with `20` major units for this corpus case.

## Verification

- `dotnet build freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release`: passed, 0 warnings, 0 errors.
- Focused presentation tests (`ChartBaselineCorpusTests` and `ChartRenderPlannerTests`): 178 passed.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore`: passed, 0 warnings, 0 errors.
- WPF render of `06-charts.pptx` at 1280x720: `1.8320%` mean channel diff on `slide-02` against `tools/FreeP.RenderCompare/corpus/pptx-ref/06-charts/slide-02.png`.
- Avalonia render of `06-charts.pptx` at 1280x720: `1.8649%` mean channel diff on `slide-02` against the same reference.

## Stock fallback follow-up - 2026-07-17

The imported stock fallback in `22-chart-baseline-depth.pptx` uses a
chart-specific marker order: diamond, square, triangle, and X. FreeP now keeps
that order separate from the generic imported line-marker sequence, which
remains diamond, square, X, and triangle.

Fresh PowerPoint COM comparison at 1280x720:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint | 3.0040% | 2.9981% |
| Avalonia vs PowerPoint | 2.9192% | 2.9178% |

Evidence is retained under `artifacts/freep-line-marker-fidelity-20260715/`.
