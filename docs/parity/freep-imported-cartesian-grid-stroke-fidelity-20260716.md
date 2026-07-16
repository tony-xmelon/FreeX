# FreeP imported cartesian grid-stroke fidelity

Date: 2026-07-16

## Evidence

Fresh PowerPoint COM exports show imported Office cartesian charts using a full `#898989` major grid stroke. FreeP's previous `0.5`-DIP plan was rasterized as a pale half-coverage line and placed the visible row just above the PowerPoint pixel row. The measured shared correction is a `1.0`-DIP `#898989` stroke plus a `0.5`-pixel planner offset for imported cartesian and secondary-axis combo grids.

## Change

`ChartRenderPlanner` now applies the dark full-width stroke to imported non-pie cartesian charts and imported combo charts, while retaining generic authored-chart defaults. The offset is applied only to planner-owned horizontal major-grid geometry; bars, lines, points, axes, scatter grids, and authored chart geometry are unchanged.

## Fresh COM comparison

At `1280x720`:

| Deck | WPF average | Avalonia average | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `19-chart-labels.pptx` | `1.4604%` | `0.6014%` | `1.4546%` |
| `06-charts.pptx` | `1.2233%` | `0.3729%` | `1.1795%` |

Deck19's combo slide improved to `1.9392%` Avalonia-vs-PowerPoint. Deck06's imported line-marker slide measured `0.2390%` Avalonia-vs-PowerPoint.
