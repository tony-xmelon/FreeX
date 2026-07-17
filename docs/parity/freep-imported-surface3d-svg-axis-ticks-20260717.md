# FreeP imported Surface3D SVG axis ticks

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

PowerPoint's SVG shape export keeps the imported Surface3D axis ticks as
vector paths even though the colored mesh is embedded as a raster image. The
export exposes 21 minor value-axis ticks, 5 major value-axis ticks, and 6
front-category ticks, including the value-axis's slight projected slope.

FreeP now emits those 32 imported-frame tick strokes in normalized plot
coordinates. Authored Surface3D charts keep their existing frame policy.

## Measurement

At 1280x720 against a fresh PowerPoint COM export:

| Metric | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | 3.1232% | 3.1083% |
| FreeP WPF vs Avalonia | 0.9706% | 0.9714% |
| FreeP Avalonia vs PowerPoint | 3.0408% | 3.0267% |

Both FreeP renderers move closer to the PowerPoint reference; the small
WPF/Avalonia divergence increase comes from their different line rasterizers.

## Boundary

The remaining Surface3D residual is primarily colored mesh registration and
projected boundary placement. This slice addresses the exported axis strokes
only and does not claim full Surface3D raster parity.
