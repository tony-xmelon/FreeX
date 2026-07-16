# FreeP Imported Chart Grid and Surface Frame Parity

Date: 2026-07-16

## Scope

This slice matches the strongest remaining stroke residuals in the imported
chart baseline deck `22-chart-baseline-depth.pptx`:

- the smooth multi-series scatter chart uses opaque black gridlines;
- the imported 100%-stacked column chart uses opaque black gridlines; and
- the imported Surface3D projected frame uses an opaque black stroke.

The rules are keyed to the imported text-metrics signatures and chart families,
so the imported combo chart and classic authored chart defaults remain unchanged.

## COM Evidence

Fresh PowerPoint exports and FreeP renders were captured at 1280x720.

| Comparison | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint, deck 22 | 3.8493% | 3.6767% |
| Avalonia vs PowerPoint, deck 22 | 3.7911% | 3.5957% |
| WPF vs Avalonia, deck 22 | 0.9702% | 0.9730% |

The imported combo control `19-chart-labels.pptx` was unchanged:

- WPF deck average: `1.5007%`;
- Avalonia vs PowerPoint deck average: `1.5103%`.

The chart-types control `18-chart-types.pptx` completed successfully with
WPF slide residuals `0.6172%`, `1.0170%`, `1.2423%`, and `1.4018%`.

## Verification

- `ChartBaselineCorpusTests` and `ChartRenderPlannerTests`: 183 passed.
- `FreeP.RenderCompare` build: 0 warnings, 0 errors.
- PowerPoint COM exports completed for decks 18, 19, and 22.
