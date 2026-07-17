# FreeP stock baseline hi-low flag - 2026-07-17

## Scope

The `22-chart-baseline-depth.pptx` fixture is intended to exercise
PowerPoint's four-series stock-chart fallback: Open, High, Low, and Close are
rendered as ordinary line-and-marker series. The fixture generator had left
`HasHighLowLines` at its model default, which emitted `c:hiLowLines` and sent
FreeP through the OHLC tick renderer instead.

The fixture now explicitly writes `HasHighLowLines = false`, matching the
existing corpus contract and the PowerPoint baseline.

## COM evidence

At `1280x720` against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF deck 22 mean channel diff | 3.5644% | 3.1236% |

The regenerated deck opens and exports successfully through PowerPoint COM.

## Verification

- `ChartRenderPlannerTests` and `ChartBaselineCorpusTests`: 188 passed.
- `FreeP.GenerateFixtures` Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare --avalonia-compare` completed for all four charts.
