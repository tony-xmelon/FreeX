# FreeP imported scatter grid geometry

Date: 2026-07-16

## Scope

The PowerPoint COM corpus deck `22-chart-baseline-depth.pptx` contains a two-series
`smoothMarker` scatter chart whose plot geometry differs from the generic scatter
defaults. The imported chart uses 11 horizontal gridlines at five-unit spacing,
while retaining six value labels at ten-unit spacing. Its plot also begins three
pixels higher than the prior FreeP imported-scatter placement at the 1280x720
comparison size.

FreeP now applies those defaults only when all of these conditions hold:

- the chart is imported and uses the large Office text metrics;
- the chart is a scatter chart with `smoothMarker` style; and
- it contains more than one series.

The one-series `lineMarker` scatter in deck 18 and authored scatter charts retain
their existing grid and geometry behavior.

## COM comparison

At 1280x720, deck 22 improved from the current main baseline as follows:

| Metric | Before | After |
| --- | ---: | ---: |
| FreeP WPF residual | 4.2669% | 3.8661% |
| FreeP Avalonia vs PowerPoint | 4.1944% | 3.8085% |

Control runs after the change:

- deck 18 (`18-chart-types.pptx`): average Avalonia vs PowerPoint `1.0513%`; slide 2 `1.0058%`;
- deck 19 (`19-chart-labels.pptx`): slides `1.6266%`, `0.8095%`, and `2.3249%`, unchanged from the prior control.

Artifacts are in:

`artifacts/freep-surface3d-scatter-final-20260716`

## Verification

Focused planner and corpus tests: 182 passed.

The COM comparison was run with:

`dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore -- --avalonia-compare ... --width 1280 --height 720`
