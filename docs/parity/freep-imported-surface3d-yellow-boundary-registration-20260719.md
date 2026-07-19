# FreeP imported Surface3D yellow boundary registration - 2026-07-19

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh contains a yellow
projected boundary face whose triangle was consistently smaller than the
PowerPoint raster. The exact `#E7AD00` mask covered 586 pixels at
`(900,131)-(954,153)` in PowerPoint and 447 pixels at
`(905,132)-(952,151)` in the accepted FreeP render.

The imported boundary polygon now uses the measured normalized points
`(301,42)`, `(360,25)`, and `(349,50)`. The change is limited to the
imported 3-by-3 Surface3D boundary-facet path; authored charts and all other
boundary faces remain unchanged.

## Matched COM evidence

The PowerPoint export was fresh and matched the persistent baseline hash
`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`.

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6260% | 2.6212% |
| WPF Surface `(560,90)-(1030,310)` | 5.2818% | 5.2515% |
| WPF tight mesh `(590,105)-(980,300)` | 6.5036% | 6.4623% |
| WPF yellow face `(885,115)-(975,175)` | 7.5520% | 6.9701% |
| Avalonia whole page | 2.3364% | 2.3314% |
| Avalonia Surface `(560,90)-(1030,310)` | 5.2338% | 5.2018% |
| Avalonia tight mesh `(590,105)-(980,300)` | 6.4985% | 6.4549% |
| Avalonia yellow face `(885,115)-(975,175)` | 7.3117% | 6.6976% |

The adjacent lower boundary ROI was byte-stable. Stock, scatter, and
100%-stacked chart crops were SHA-256 byte-identical before and after in both
WPF and Avalonia. The exact yellow mask moved to 573 pixels at
`(901,131)-(954,153)`.

## Verification

- `ChartBaselineCorpusTests|ChartRenderPlannerTests`: `197/197`
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors
- Fresh WPF and Avalonia renders completed with opaque pixel-diversity checks
