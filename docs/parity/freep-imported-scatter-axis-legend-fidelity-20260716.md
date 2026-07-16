# FreeP imported scatter axis and legend fidelity

Date: 2026-07-16

Corpus: `tools/FreeP.RenderCompare/corpus/18-chart-types.pptx`

## Evidence

PowerPoint COM export of slide 2 (`Scatter`, `lineMarker`) uses a `0..4.5` Y axis in `0.5` steps, draws ten horizontal gridlines, and leaves the X axis without vertical gridlines. Its single legend item uses a diamond marker and preserves the complete `Bubbles` label. Slide 4 (`Bubble`) uses a `0..50` Y axis in `5` steps, the same horizontal-only grid treatment, and a circular `Series1` legend marker. The bubble chart has no `c:bubbleSize` data, so PowerPoint keeps the axes and legend but renders no bubbles.

## Change

FreeP now:

- distinguishes imported single-series line-marker scatter charts from the existing smooth-scatter baseline;
- applies the PowerPoint single-scatter and bubble plot insets and axis intervals;
- maps the imported scatter/bubble gridline flag to the X value axis, avoiding unwanted vertical gridlines;
- renders shared planner-owned scatter/bubble grids with the imported `#898989` stroke;
- preserves full imported scatter and bubble legend labels with diamond or circle marker swatches;
- avoids drawing a duplicate generic chart grid for scatter-like scenes.

## Fresh 1280x720 comparison

The candidate was rendered through the WPF and Avalonia paths and compared with a fresh PowerPoint COM export:

| Deck | WPF average | Avalonia average | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `18-chart-types.pptx` | `0.8568%` | `0.3047%` | `0.8280%` |

Per-slide Avalonia-vs-PowerPoint diffs were `0.5970%`, `0.7906%`, `1.1969%`, and `0.7274%` for slides 1 through 4.

The existing smooth-scatter baseline `22-chart-baseline-depth.pptx` remained at `0.9722%` Avalonia and `3.5906%` Avalonia-vs-PowerPoint for its single-slide comparison.
