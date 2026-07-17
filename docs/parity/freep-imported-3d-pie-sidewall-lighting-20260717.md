# FreeP imported 3-D pie sidewall lighting

Date: 2026-07-17

## Scope

The imported 3-D pie oracle derived from `06-charts.pptx` uses distinct
PowerPoint lighting roles for the visible Alpha, Beta, and Gamma sidewalls.
FreeP previously applied one angle-only factor to every imported slice, making
the large Beta wall too dark and the Alpha wall too light.

## Change

The renderer-neutral planner now exposes the measured imported slice lighting
factors. WPF and Avalonia consume the same policy; authored and non-imported
3-D pie paths retain their existing behavior.

## Fresh COM comparison

At `1280x720` on the temporary `pieChart` -> `pie3DChart` PowerPoint oracle:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF 3-D pie slide | 4.1639% | 4.1322% |
| Avalonia vs PowerPoint, 3-D pie slide | 4.2016% | 4.1704% |
| WPF four-slide average | 2.0874% | 2.0794% |
| Avalonia vs PowerPoint, four-slide average | 2.0348% | 2.0270% |

## Verification

- Focused chart planner/baseline tests pass.
- `FreeP.RenderCompare` Release build completes with 0 warnings and 0 errors.
- PowerPoint exports all four oracle slides without repair or hang.
