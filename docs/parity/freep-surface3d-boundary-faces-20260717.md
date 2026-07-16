# FreeP imported Surface3D boundary faces

## Scope

The imported PowerPoint Surface3D baseline includes four opaque projected
boundary/material faces that are not represented by the eight top-surface
facets alone. FreeP now emits those faces in the imported Surface3D render
path, while authored surface charts retain their existing geometry.

The measured colors are:

- dark blue #345897
- dark green #8BAB74
- yellow #E7AD00
- rear green #81A16E

The faces use normalized coordinates from the 360x189 imported plot and scale
with the active plot rectangle. Their strokes remain transparent, matching the
PowerPoint reference.

## Evidence

Corpus: tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx,
slide 1, compared with the checked-in PowerPoint export at 1280x720.

| Backend | Before | After |
| --- | ---: | ---: |
| WPF | 3.3121% | 3.1439% |
| Avalonia | 3.1637% | 3.0614% |

The lower blank-cell vertex is registered separately at local Y=163.1,
preserving the semantic missing value while matching PowerPoint's visible
trough.

## Verification

- Focused ChartBaselineCorpusTests and ChartRenderPlannerTests: 188 passed
- RenderCompare Release build: 0 warnings, 0 errors
- Full WPF corpus sweep completed at 1280x720 with all 22 decks rendered successfully.
