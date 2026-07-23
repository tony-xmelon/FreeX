# FreeP imported Surface3D green-face overlays

## Scope

The imported default Surface3D path now adds five WPF-only green-face registration overlays after the shared mesh underpaint. The guard is the existing imported default signature: Surface3D, inherited text metrics, no authored `view3D`, three categories, three series, varying colors, and the exact 3x3 values used by the PowerPoint baseline. Shared planner facets and Avalonia output are unchanged.

## Evidence

Fresh `RenderCompare` captures used the same 1280x720 frame and PowerPoint export for each run:

| Fixture | WPF before | WPF after | Avalonia after | Avalonia-vs-PP |
| --- | ---: | ---: | ---: | ---: |
| `22-chart-baseline-depth` | 2.4862% | 2.4723% | 1.2603% | 2.2959% |
| `26-chart-surface3d-default-tall-frame` | 2.5606% | 2.5530% | 1.1665% | 2.3455% |
| `25-chart-surface3d-view3d` control | 2.7614% | 2.7614% | 1.6102% | 2.9275% |

The target's manual surface crop also improved from 4.1931% to 4.0538%. The explicit-camera control remains on its general projection path and is byte-stable at the rendered comparison level.

## Verification

- `ChartBaselineDepthCorpusDeck_ExercisesSharedPlannerDecisions`: 1/1 compile run.
- Same focused test with `--no-build`: 1/1.
- `FreeP.RenderCompare` Release consuming artifact: 0 warnings/errors.
- PowerPoint export: 1/1 slide for every comparison.

This is a WPF imported-default calibration, not a general Surface3D mesh model. Authored camera/view settings remain separate work.
