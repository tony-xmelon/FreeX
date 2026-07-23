# FreeP imported Surface3D default frame grid

## Scope

The WPF imported-default Surface3D route no longer adds the generic wireframe
grid on top of its measured PowerPoint frame. The exact guard remains the
imported default Surface3D signature (`VaryColors`, three categories, three
series, inherited text metrics, and no authored `view3D`). The measured frame
edges, axis ticks, colored facets, explicit-camera route, Avalonia planner,
and shared mesh remain unchanged.

## Evidence

Fresh `RenderCompare` captures used the same 1280x720 frame and PowerPoint COM
export:

| Fixture | WPF before | WPF after | Avalonia after | Avalonia-vs-PP |
| --- | ---: | ---: | ---: | ---: |
| `22-chart-baseline-depth` | 2.4723% | 2.4221% | 1.2461% | 2.2482% |
| `26-chart-surface3d-default-tall-frame` | 2.5530% | 2.5146% | 1.1544% | 2.3087% |
| `25-chart-surface3d-view3d` control | 2.7614% | 2.7614% | 1.6102% | 2.9275% |

The control remains unchanged because authored camera settings stay on the
general projection path. The improvement is WPF-local and does not claim a
general Surface3D mesh or camera model.

## Verification

- `ChartBaselineDepthCorpusDeck_ExercisesSharedPlannerDecisions`: 1/1 after
  updating the frame-segment contract from 45 to 37.
- WPF/Avalonia/PowerPoint exports: 1/1 for each of the three fixtures.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
