# FreeP imported cartesian label geometry

Date: 2026-07-16

## Evidence

Fresh PowerPoint COM exports of `19-chart-labels.pptx` showed imported cartesian
axis-label glyphs using a different placement envelope from authored chart text.
At `1280x720`, the primary value labels ended about `22` pixels before the plot
edge and the top glyphs began about `7` pixels above FreeP's previous plan. The
category labels began about `14` pixels lower in PowerPoint. The combo slide
showed the same vertical relationship on both value axes.

## Change

`ChartRenderPlanner` now gives imported cartesian category labels a `16`-DIP
bottom offset, imported primary value labels a `22`-DIP plot-edge gap, and
imported primary and secondary value labels a `13`-DIP vertical offset. These
are limited to imported text metrics; authored chart label geometry keeps its
existing defaults.

## Fresh COM comparison

At `1280x720`:

| Deck | WPF average | Avalonia average | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `19-chart-labels.pptx` | `1.3774%` | `0.6014%` | `1.3310%` |
| `06-charts.pptx` | `1.1874%` | `0.3729%` | `1.1167%` |
| `18-chart-types.pptx` | `0.8568%` | `0.3047%` | `0.8280%` |
| `22-chart-baseline-depth.pptx` | `3.5904%` | `0.9776%` | `3.4814%` |

The deck19 combo slide improved to `1.6894%` Avalonia-vs-PowerPoint. PowerPoint
COM exported all 12 regression slides successfully without a hang.
