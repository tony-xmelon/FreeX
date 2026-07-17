# FreeP imported Style 2 column/bar legend key geometry

Date: 2026-07-18

## Scope

PowerPoint's imported Style 2 clustered-column and clustered-bar charts use
14-DIP legend keys, 37-DIP row spacing, and a label baseline above FreeP's
generic 8-DIP/28-DIP legend fallback. The column and bar charts also anchor
their legend block at different horizontal offsets.

The shared chart planner now recognizes only imported Style 2 clustered-column
and clustered-bar charts for this geometry. Other chart families and authored
styles retain their existing legend policy.

## Fresh PowerPoint COM comparison

Corpus: `tools/FreeP.RenderCompare/corpus/06-charts.pptx`, rendered at
1280x720 with a fresh PowerPoint COM export.

| Slide | WPF whole before | WPF whole after | Legend ROI before | Legend ROI after |
| --- | ---: | ---: | ---: | ---: |
| Clustered column / slide 1 | 1.0269% | 0.9817% | 4.6200% | 2.8853% |
| Clustered bar / slide 4 | 1.3062% | 1.2578% | 5.5331% | 3.6720% |

Slides 2 and 3 were unchanged. Plot ROI stayed byte/metric-stable on the
column slide and improved from 1.3860% to 1.3698% on the bar slide. The
`18-chart-types` control deck remained SHA-256 byte-stable on all four WPF and
Avalonia pages.

Fresh COM gate results for `06-charts` were WPF `0.9808/1.2437/0.6227/1.2565%`
and Avalonia-vs-PowerPoint `0.9375/1.1365/0.5751/1.1998%` by slide.

## Verification

- `ChartsCorpus_Style2ColumnAndBarLegendsUsePowerPointKeyGeometry`: passed.
- `ChartBaselineCorpusTests`: 24/24 passed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- PowerPoint COM exported all four slides without repair or hang.
