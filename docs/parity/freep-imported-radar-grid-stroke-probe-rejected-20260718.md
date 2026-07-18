# FreeP imported radar grid stroke probe rejected - 2026-07-18

## Scope

Fresh PowerPoint COM capture of `18-chart-types.pptx` isolated the imported
radar chart on slide 3. The chart geometry and series registration were
aligned, but the WPF/Avalonia radar grid/spoke raster used a light antialiased
stroke while PowerPoint's dominant grid raster was darker. The shared
imported-radar stroke thickness was probed from `0.5` to `1.0` DIP.

## Matched evidence

| Slide / host | Baseline | 1-DIP probe |
| --- | ---: | ---: |
| WPF slide 1 control | 0.5004% | 0.5004% |
| WPF slide 2 control | 0.7874% | 0.7874% |
| WPF radar slide 3 | 1.2063% | 1.2937% |
| WPF slide 4 control | 0.7395% | 0.7395% |
| Avalonia radar slide 3 | 0.4427% | 0.4588% |

The complete four-slide sequence was freshly exported by PowerPoint for both
captures. The probe was reverted. The darker raw grid color was a valid
diagnostic observation, but thickness alone does not reproduce PowerPoint's
stroke antialiasing contract.

## Process rule

Score chart frame, grid, series, labels, and whole-page metrics separately,
but accept a shared chart stroke change only when both hosts' target chart and
the complete slide sequence improve. Exact-color similarity is diagnostic, not
acceptance evidence, when host antialiasing differs.

## Verification

- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 4/4 slides for baseline and probe.
- Product source restored to the accepted `0.5` DIP baseline.
