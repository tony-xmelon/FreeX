# FreeP explicit Surface3D light-orange face

The authored `25-chart-surface3d-view3d.pptx` Surface3D route already has an
exact camera/signature guard and a WPF-only measured facet path. Its remaining
light-orange `#EB7C30` face was still represented as a narrow three-point
triangle, while the PowerPoint raster owns a broader low polygon. The WPF
facet now uses the measured 11-point footprint for that exact authored camera.

The shared mesh, Avalonia `RenderFacets`, frame, labels, generic Surface3D
camera, and the default `22`/`26` routes are unchanged.

Fresh matching 1280x720 PowerPoint comparisons from the rebuilt Release
consumer:

| Measure | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.7943% | 2.7916% |
| WPF orange-face ROI `(600,150)-(830,240)` | 7.0555% | 6.9381% |
| WPF exact orange pixels | 1,373 | 2,417 |

The target exact-orange mask is 2,498 pixels at `(635,175)-(783,210)`;
the candidate is 2,417 pixels at `(635,175)-(775,210)`. The remaining edge
error is coupled to neighboring projected facets and is not treated as a
scalar color/translation problem.

Controls were unchanged: WPF `22` and `26`, Avalonia `22`, `25`, and `26`
were SHA-256 byte-identical to the current baseline. Focused chart planner
and corpus tests passed `224/224` with compilation and `224/224` with
`--no-build`; the consuming `FreeP.RenderCompare` Release build completed
with zero warnings and errors.
