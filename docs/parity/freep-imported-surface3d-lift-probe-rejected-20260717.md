# FreeP imported Surface3D lift probe rejected - 2026-07-17

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh still has a
large projected-surface residual. A single WPF/shared-planner probe reduced
the imported vertical lift term from the current `0.90` ratio / `170` DIP cap
to `0.80` / `150` DIP, leaving authored Surface3D charts unchanged.

## Matched COM evidence

Against the persistent 1280x720 PowerPoint export:

| ROI | Before | Candidate |
| --- | ---: | ---: |
| Whole page | 2.6519% | 2.7806% |
| Surface `(560,90)-(1030,310)` | 5.4925% | 6.6397% |
| Tight mesh `(590,105)-(980,300)` | 6.7871% | 8.3470% |
| Stock control | 4.9794% | 4.9794% |
| Scatter control | 1.8944% | 1.8944% |
| Stacked control | 3.3218% | 3.3218% |

The probe reached the intended imported Surface3D path, but moving all
projected values downward worsened both target mesh ROIs and the whole page.
It was reverted. The remaining error needs facet-specific registration or
topology evidence rather than a global lift adjustment.

## Verification

- Candidate `FreeP.RenderCompare` render completed with healthy pixel diversity.
- Candidate `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Candidate focused planner run: 196 passed, 1 expected assertion failure for the changed lift value.
- Product source was restored to the prior accepted constants before handoff.
