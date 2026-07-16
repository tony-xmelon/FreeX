# FreeP Imported 100% Stacked Grid Edges - 2026-07-16

The imported `ColumnStacked100` chart in
`22-chart-baseline-depth.pptx` includes two registered vertical plot-edge
strokes in addition to its category-center gridlines. FreeP's bars and
horizontal value grid already align closely, but the shared grid plan omitted
those two edge strokes.

## Change

- Imported 100% stacked column charts now add the two PowerPoint-aligned
  vertical plot-edge strokes.
- The edge registration is isolated to the imported percent-stacked layout;
  authored and other chart families retain their existing grid behavior.
- The corpus contract covers the two additional vertical grid primitives and
  their registered X coordinates.

## Evidence

Fresh PowerPoint COM export at `1280x720`:

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | `3.3505%` | `3.3449%` |
| Avalonia-vs-PowerPoint | `3.2653%` | `3.2599%` |

The stacked-chart ROI improved from `4.8227%` to `4.7884%`.

## Verification

- Focused chart planner/corpus tests: `186 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- PowerPoint COM export: `1/1` slide exported without repair or hang.
