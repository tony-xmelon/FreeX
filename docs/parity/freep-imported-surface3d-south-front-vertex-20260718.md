# FreeP imported Surface3D south-front vertex - 2026-07-18

## Scope

The imported 3x3 Surface3D COM mesh had a dark-orange south/front facet that
was narrower and lower than PowerPoint. The correction is limited to the
imported text-metrics signature and moves the shared `(series=0, category=2)`
vertex `+7 DIP` horizontally and `-2 DIP` vertically. Other chart families
and the Avalonia planner are unchanged.

## Matched COM evidence

Fresh 1280x720 PowerPoint exports and rebuilt Release artifacts were used for
the candidate and same-artifact baseline:

| Metric | Baseline | Candidate |
| --- | ---: | ---: |
| WPF whole page | 2.6185% | 2.6101% |
| Surface ROI `(560,90)-(1030,310)` | 5.2272% | 5.1524% |
| Tight mesh ROI `(590,105)-(980,300)` | 6.4293% | 6.3276% |
| Dark-orange ROI `(750,170)-(920,270)` | 3.8051% | 3.3514% |
| Avalonia vs PowerPoint | 2.3288% | 2.3201% |

The PowerPoint export SHA-256 was identical between captures. Exact `#B76026`
pixels moved from `3851` with bbox `(781,187)-(897,254)` to `4106` with bbox
`(781,187)-(904,254)`, toward PowerPoint's `4962` pixels and bbox
`(768,185)-(904,255)`.

Independent `06-charts` and `18-chart-types` controls were byte-identical for
all WPF and Avalonia slides.

## Verification

- Focused `ChartBaselineCorpusTests|ChartRenderPlannerTests`: 198/198.
- Presentation focused Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 1/1 target slide and 4/4 slides per control.

Process rule: for an imported 3-D chart, calibrate the shared facet vertex
that owns the color-mask residual, and require target ROI, whole-page,
cross-host, and byte-stable unrelated-chart evidence before accepting.
