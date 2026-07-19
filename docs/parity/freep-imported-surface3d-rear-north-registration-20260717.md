# FreeP imported Surface3D rear-North registration - 2026-07-17

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh's rear-row/North
vertex placed the high-band green facet too high in both renderers. The
imported 3x3 path now applies a `+14 DIP` Y correction only to that vertex.
The accepted blank-cell corrections, authored Surface3D geometry, and other
chart types remain unchanged.

## Matched COM evidence

Fresh current-main controls and candidate renders were compared with the
persistent 1280x720 PowerPoint export:

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6467% | 2.6388% |
| WPF Surface `(560,90)-(1030,310)` | 5.4463% | 5.3761% |
| WPF tight mesh `(590,105)-(980,300)` | 6.7244% | 6.6289% |
| WPF high-band `(670,110)-(960,190)` | 7.2272% | 6.9140% |
| Avalonia whole page | 2.3536% | 2.3451% |
| Avalonia Surface | 5.3999% | 5.3243% |
| Avalonia tight mesh | 6.7244% | 6.6215% |
| Avalonia high-band | 7.0488% | 6.7114% |

The low-band fold and stock, scatter, and stacked-chart controls were stable.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 197/197.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel-diversity checks.
- Build servers shut down after verification.
