# FreeP imported Surface3D painter order

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`

## Finding

PowerPoint paints the imported Surface3D rear rows before the nearer rows. FreeP's facet geometry was already calibrated, but the original series-major order let rear green facets overwrite pixels belonging to the nearer dark-orange fold. The render-only facet list now orders imported facets by descending series index and ascending category index; logical `Facets` and point topology remain unchanged.

## Measurement

At 1280x720 with a fresh PowerPoint COM export:

| Render | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | 3.1236% | 3.1232% |
| FreeP Avalonia vs PowerPoint | 3.0412% | 3.0408% |
| Avalonia internal comparison | 0.9706% | 0.9706% |

The axis-tick candidate was discarded separately because it regressed WPF to `3.1250%` and Avalonia to `0.9708%`.

## Boundary

The remaining Surface3D residual is dominated by projected mesh geometry and boundary-wall placement. This change only corrects painter ownership at overlapping projected facets; it does not claim full PowerPoint raster parity.
