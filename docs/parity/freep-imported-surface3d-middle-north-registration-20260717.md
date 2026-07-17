# FreeP imported Surface3D middle-North registration - 2026-07-17

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh had one shared
middle-row/North vertex registered too high by the WPF and Avalonia projection
path. The shared planner now applies a `20` DIP downward correction only to
that vertex in the imported 3x3 Surface3D path. Authored Surface3D charts and
all other chart types are unchanged.

## Matched COM evidence

Fresh current-main controls and candidate renders were compared against the
persistent 1280x720 PowerPoint export:

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6519% | 2.6515% |
| WPF Surface `(560,90)-(1030,310)` | 5.4925% | 5.4895% |
| WPF tight mesh `(590,105)-(980,300)` | 6.7871% | 6.7831% |
| Avalonia whole page | 2.3590% | 2.3585% |
| Avalonia Surface | 5.4482% | 5.4439% |
| Avalonia tight mesh | 6.7900% | 6.7841% |

Stock, scatter, and stacked-chart controls were unchanged for both backends.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 197/197.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel-diversity checks.
- Build servers shut down after verification.
