# FreeP imported Surface3D point registration refinement

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

A WPF-only sweep against the retained PowerPoint COM PNG showed that the
committed imported Surface3D point registration was still globally low and
slightly left after the projected-axis tick correction. The imported point
offset is now `(x=+3.5, y=-9.0)`; authored Surface3D projections are unchanged.

## Measurement

At 1280x720 against a fresh PowerPoint COM export:

| Metric | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | 3.1083% | 3.0701% |
| FreeP WPF vs Avalonia | 0.9714% | 0.9704% |
| FreeP Avalonia vs PowerPoint | 3.0267% | 2.9903% |

The candidate was selected from a 25-point local registration sweep and then
rechecked with the dual-render PowerPoint comparison.

## Boundary

This is a shared registration correction for the imported Surface3D path. The
remaining residual is concentrated in the facet topology and projected wall
geometry, which require separate evidence.
