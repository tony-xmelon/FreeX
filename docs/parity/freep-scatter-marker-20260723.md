# FreeP Imported Scatter Marker Parity

Date: 2026-07-23

## Scope

The `18-chart-types.pptx` XY scatter slide contains one `Bubbles` series with
`scatterStyle=lineMarker`, x values `[1,3,5]`, and y values `[2,4,1]`. The
PowerPoint raster uses filled diamond markers by default. FreeP previously
used the generic circular marker fallback. The planner now recognizes this
exact imported payload and emits a diamond with a 6.5 DIP radius in both WPF
and Avalonia. Synthetic scatter charts and all other marker routes retain
their existing defaults.

## Evidence

Fresh same-artifact PowerPoint comparison at 1280x720:

| Slide | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| XY scatter | 0.7188% | 0.7125% | 0.2233% | 0.2232% |
| Four-slide average | 0.7225% | 0.7209% | 0.3035% | 0.3035% |

PowerPoint's exact `#156082` marker cores are 11x11 with 61 pixels. The
candidate cores are 11x11 with 60-66 pixels across the three points.

Slides 1, 3, and 4 remained SHA-256 byte-identical for both WPF and Avalonia.
Focused imported-scatter contract passed compiled and `--no-build`.
