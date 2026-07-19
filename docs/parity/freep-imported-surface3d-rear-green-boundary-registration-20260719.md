# FreeP imported Surface3D rear green boundary registration - 2026-07-19

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh contains a small
rear green boundary face that remained visibly undersized after the earlier
mesh and dark-orange boundary registrations. The PowerPoint exact-color mask
for `#8BAB74` covered 1,203 pixels at `(791,139)-(896,202)`; the accepted
FreeP render covered 660 pixels at `(791,140)-(889,198)`.

The imported boundary polygon now uses the measured normalized points
`(201,72)`, `(236,42)`, and `(306,33)`. This is limited to the imported
3-by-3 Surface3D boundary-facet path; authored charts and other imported
chart families are unchanged.

## Matched COM evidence

The PowerPoint export was fresh and matched the persistent baseline hash
`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`.

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6260% | 2.6246% |
| WPF Surface `(560,90)-(1030,310)` | 5.2944% | 5.2818% |
| WPF tight mesh `(590,105)-(980,300)` | 6.5207% | 6.5036% |
| WPF boundary `(590,170)-(920,270)` | 7.0137% | 7.0093% |
| WPF rear face `(780,125)-(970,270)` | 4.9001% | 4.8528% |
| Avalonia whole page | 2.3364% | 2.3350% |
| Avalonia Surface `(560,90)-(1030,310)` | 5.2467% | 5.2338% |
| Avalonia tight mesh `(590,105)-(980,300)` | 6.5160% | 6.4985% |
| Avalonia boundary `(590,170)-(920,270)` | 6.9724% | 6.9679% |
| Avalonia rear face `(780,125)-(970,270)` | 4.7636% | 4.7153% |

Stock, scatter, and 100%-stacked chart crops remained SHA-256 byte-identical
before and after in both WPF and Avalonia.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: `197/197`
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors
- Fresh WPF and Avalonia renders completed with opaque pixel-diversity checks
