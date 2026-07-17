# FreeP imported Surface3D low-row shading

Date: 2026-07-17

## Finding

PowerPoint's imported `22-chart-baseline-depth.pptx` Surface3D mesh uses a darker orange fill for the first low-row triangular facet. FreeP was assigning the brighter orange used by the adjacent facet, leaving a large color mismatch along the left side of the surface.

## Change

`ChartRenderPlanner.ResolveImportedSurfaceFacetColor` now assigns `#D5702C` to the `(seriesIndex: 0, categoryIndex: 0, triangleIndex: 1)` facet. The existing rear-to-front painter order and calibrated point registration are unchanged.

## Evidence

At 1280x720, a fresh PowerPoint COM comparison improved the WPF mean channel diff from `3.0701%` to `3.0684%`. Avalonia moved from `0.9704%` to `0.9703%` against WPF, and Avalonia versus PowerPoint improved from `2.9903%` to `2.9885%`.

Projection sweeps around the accepted imported lift and Y registration did not improve the result; the best sampled point remained the committed `lift=170`, `offsetY=-9` geometry.
