# FreeP stock fallback axis-font probe rejected - 2026-07-19

## Scope

The imported `22-chart-baseline-depth.pptx` stock fallback already routes its
title through the classic Office Arial calibration, while category and value
axis labels use the generic WPF chart-label font path. A WPF-only probe changed
those two label groups to Arial for `ChartScenePlan.UsesStockLineFallback`.
Chart geometry, series strokes, title placement, and all other chart families
were unchanged.

## Matched current-artifact evidence

The actual Release `FreeP.RenderCompare` artifact was rebuilt before rendering.
The persistent PowerPoint reference was the matching 1280x720 PNG.

| Gate | Accepted | Arial-label candidate |
| --- | ---: | ---: |
| WPF whole page | `2.6082%` | `2.6181%` |
| Stock ROI `(40,40)-(530,330)` | `5.0148%` | `5.0086%` |
| Stock plot ROI `(55,95)-(520,310)` | `5.0148%` | `5.0226%` |
| Stock title ROI | `8.4123%` | `8.4123%` |
| `06-charts` controls | SHA-stable | SHA-stable |
| `18-chart-types` controls | SHA-stable | SHA-stable |

The small stock-label ROI improvement was rejected because the complete slide
regressed. The source change was reverted; no renderer behavior was retained.

## Verification

- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Fresh WPF renders completed for the target and both control decks.
- Product source is restored to the accepted baseline after scoring.

## Process rule

Classic chart font ownership cannot be inferred from the already-correct title
path. Require stock ROI and whole-page improvement together; label-only gains
are insufficient when their raster footprint trades against the rest of the
chart.
