# FreeP Imported Stock Grid Raster - 2026-07-16

The imported stock fallback in `22-chart-baseline-depth.pptx` uses PowerPoint's
classic black grid rasterization. The shared planner previously applied the
imported Cartesian half-pixel offset to stock value gridlines, which made the
1-pixel lines land between device rows and render as alternating gray
anti-aliased bands in WPF.

## Change

- Imported stock value gridlines now use their unoffset integer plot rows.
- Other imported Cartesian charts retain the existing half-pixel alignment.
- The corpus contract asserts that the stock value grid starts at the plot
  bottom and ends at the plot top without the imported offset.

## Evidence

Fresh PowerPoint COM export at `1280x720`:

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | `3.5599%` | `3.3505%` |
| Avalonia-vs-PowerPoint | `3.4517%` | `3.2653%` |

The stock-chart ROI improved from `6.8175%` to `5.4453%`; the surface,
scatter, and stacked-chart ROI values were unchanged.

## Verification

- Focused chart planner/corpus tests: `186 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- PowerPoint COM export: `1/1` slide exported without repair or hang.
