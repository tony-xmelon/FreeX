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
| FreeP WPF vs Avalonia | 0.9706% | 0.9706% |
| FreeP Avalonia vs PowerPoint | 3.0412% | 3.0408% |

The axis-tick candidate was discarded separately because it regressed WPF vs PowerPoint to `3.1250%` and WPF vs Avalonia to `0.9708%`.

## WPF mesh pass - 2026-07-18

The imported boundary faces are appended to the render-only facet list, so
PowerPoint's mesh wireframe must be painted before the facets for those opaque
boundary faces to retain ownership of shared pixels. FreeP WPF now paints the
wireframe before the imported render facets; the projected frame remains under
the mesh.

Fresh PowerPoint COM comparison at 1280x720:

| Metric | Before | After |
| --- | ---: | ---: |
| FreeP WPF vs PowerPoint | 2.9981% | 2.9887% |
| FreeP WPF vs Avalonia | 0.9710% | 0.9780% |
| FreeP Avalonia vs PowerPoint | 2.9178% | 2.9178% |

`ChartBaselineCorpusTests`: 23 passed. The remaining residual is still
dominated by projected mesh geometry and boundary-wall registration; this
follow-up corrects painter ownership without claiming full Surface3D raster
parity.

## Avalonia mesh pass - 2026-07-17

Avalonia had been painting the imported wireframe after opaque render facets,
while WPF and PowerPoint paint the wireframe first. The Avalonia renderer now
uses the same order: projected frame, wireframe, opaque facets, then contours.
This keeps shared mesh strokes behind the boundary faces that own the pixels.

Fresh matching-compositor comparison at 1280x720 against the cached PowerPoint
export for slide 1:

| Metric | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Avalonia Surface ROI (512,60)-(1024,330) | 4.9717% | 4.9145% | -0.0572 pp |
| Avalonia tight Surface ROI (560,90)-(980,300) | 6.3237% | 6.2341% | -0.0896 pp |
| Avalonia whole page | 2.3715% | 2.3629% | -0.0086 pp |
| WPF whole page | 2.6976% | 2.6976% | 0.0000 pp |

`SlideCanvasAvaloniaTests`: 68 passed. A fresh PowerPoint COM export completed
without repair for the one-slide corpus. The remaining Surface3D residual is
still dominated by projected mesh geometry and boundary-wall registration.

## Boundary

The remaining Surface3D residual is dominated by projected mesh geometry and boundary-wall placement. This change only corrects painter ownership at overlapping projected facets; it does not claim full PowerPoint raster parity.
