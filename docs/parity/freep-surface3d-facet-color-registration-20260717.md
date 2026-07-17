# FreeP imported Surface3D facet color registration - 2026-07-17

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D chart uses vary-colors
faces whose color assignment follows the projected face registration. FreeP's
shared planner assigned the fourth top-surface triangle to the dark-orange
face, but the PowerPoint reference places the green band on that projected
facet.

The imported mapping now assigns `(series 0, category 1, triangle 1)` to
`#97BD80`. Other imported facet colors and the four measured boundary faces
are unchanged.

## COM evidence

At 1280x720 against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF deck 22 mean channel diff | 3.1353% | 3.1292% |
| Surface ROI mean channel diff | 8.9942% | 8.9119% |

The change is scoped to imported 3x3 Surface3D charts with vary-colors data;
authored surface charts retain their existing color policy.

## Verification

- `ChartBaselineCorpusTests` covers the imported facet color sequence.
- `FreeP.RenderCompare` Release build completed with 0 warnings and 0 errors.
- PowerPoint COM export and WPF comparison completed successfully.
