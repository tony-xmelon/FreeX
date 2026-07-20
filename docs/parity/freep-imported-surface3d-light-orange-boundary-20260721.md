# FreeP imported Surface3D light-orange boundary parity

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D has a sparse 3-by-3
mesh, one missing low-band vertex, and no authored `view3D`, material, wall,
or mesh settings. The first complete cell is split into two PowerPoint-colored
triangles. Exact-color masks showed that the light-orange face was truncated
at the value-axis side in both FreeP hosts; changing the shared camera or the
cell diagonal was not justified.

The planner now moves only the low-left vertex of that light-orange render
triangle by `-36` normalized plot units in X. The shared logical point and all
other facets remain unchanged, so the correction stays confined to the
imported, vary-colors, 3-by-3 Surface3D owner.

## Matched evidence

Fresh 1280x720 PowerPoint export and current Release FreeP artifacts:

| Measure | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.6082% | 2.6046% |
| Avalonia whole slide | 2.3183% | 2.3146% |
| Surface ROI (540,70)-(1040,330) | 5.2516% | 5.2262% |
| Unrelated chart ROI (30,80)-(520,330) | 4.5818% | 4.5818% |

The exact `#F18032` mask moved from WPF bbox `(675,187)-(793,251)` to
`(628,187)-(793,253)`, toward PowerPoint's `(604,185)-(787,228)`. The
candidate was also checked in Avalonia; it improved the same whole-slide
comparison and did not alter the unrelated chart region.

## Guard

`ChartBaselineDepthCorpus_RegistersImportedLightOrangeFacetBoundary` locks
the owner-local planned vertex. Keep this correction separate from shared
Surface3D camera/projection constants; any further facet change must rerun
both hosts with a fresh PowerPoint export and score the full slide plus the
surface and unrelated-chart regions.
