# FreeP imported Surface3D front-category projection - 2026-07-18

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D mesh uses a wider
projected front category span than the earlier shared estimate. The imported
projection now uses a normalized front-category width of `301.5` pixels,
while authored Surface3D charts keep their existing geometry policy.

This keeps the projected frame unchanged and moves only the imported mesh
category points, including the blank-cell fallback triangles.

## COM evidence

At 1280x720 against a fresh PowerPoint export:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF deck 22 mean channel diff | 3.1292% | 3.1236% |

## Verification

- `ChartBaselineCorpusTests` covers the updated imported blank-cell points.
- `FreeP.RenderCompare` Release build completed with 0 warnings and 0 errors.
- PowerPoint COM export and WPF comparison completed successfully.
