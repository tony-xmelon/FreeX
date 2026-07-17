# FreeP imported line-marker category centers

Date: 2026-07-17

## Scope

The imported `06-charts.pptx` line-with-markers chart uses category bands. The
previous planner spread four points across the plot edges, while PowerPoint
places each point at the center of its category band.

## Change

- Imported `LineMarkers` charts now use `plot.Width / categoryCount` and place
  each point at `(categoryIndex + 0.5) * stepX`.
- Ordinary line charts and combo override lines retain their existing
  edge-to-edge or category-center behavior.
- A planner regression test covers the four imported category centers.

## ROI evidence

All values are mean RGB channel difference against the persistent matching
PowerPoint COM PNG at 1280 x 720. The chart ROI is `(120,70)-(1190,680)` on
slide 2.

| Renderer | Target ROI before | Target ROI after | Whole slide before | Whole slide after |
| --- | ---: | ---: | ---: | ---: |
| WPF | 2.2941% | 1.4346% | 1.8928% | 1.2841% |
| Avalonia | 2.2167% | 1.3493% | 1.7508% | 1.1365% |

Slides 1, 3, and 4 were unchanged. The full-page improvement is therefore
material and localized to the corrected line-marker chart.

## Verification

- Compiling focused `ChartRenderPlannerTests`: 174 passed, 0 failed.
- Focused `--no-build` planner tests: 174 passed, 0 failed.
- `FreeP.RenderCompare` build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders of `06-charts.pptx` were compared with the
  persistent COM baseline.
