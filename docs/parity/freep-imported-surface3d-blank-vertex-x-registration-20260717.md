# FreeP imported Surface3D blank-vertex X registration - 2026-07-17

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh's blank low-band
vertex was 20 DIP too far left in the shared projection. The imported 3x3
path now applies a `+20 DIP` X correction to that blank vertex. Its accepted
middle-row/North Y correction, authored Surface3D geometry, and other chart
types remain unchanged.

## Matched COM evidence

Fresh current-main WPF and Avalonia controls were compared with the persistent
1280x720 PowerPoint export:

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6519% | 2.6467% |
| WPF Surface `(560,90)-(1030,310)` | 5.4925% | 5.4463% |
| WPF tight mesh `(590,105)-(980,300)` | 6.7871% | 6.7244% |
| WPF low-band fold `(595,195)-(770,300)` | 10.2892% | 9.6698% |
| Avalonia whole page | 2.3590% | 2.3536% |
| Avalonia Surface | 5.4482% | 5.3999% |
| Avalonia tight mesh | 6.7900% | 6.7244% |
| Avalonia low-band fold | 10.2281% | 9.6056% |

Stock, scatter, and stacked-chart controls were unchanged for both backends.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 197/197.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel-diversity checks.
- Build servers shut down after verification.
