# FreeP tall default Surface3D frame

The imported `26-chart-surface3d-default-tall-frame` fixture has a two-line
title and a 400x320 chart box, but its Word surface mesh occupies a shorter
lower band than the generic Surface3D frame. The chart has no authored
`c:view3D`; the correction is therefore guarded by the existing imported title
and bounds signature and does not affect explicit-camera charts.

The planner now reserves the measured tall frame at `(x+44, y+95, 280, 171)`.
The regular imported Surface3D frame remains `(x+44, y+57, 280, 221)`.

Fresh 1280x720 matching Word raster comparisons from the rebuilt Release
renderer:

| Fixture | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| 26 tall default Surface3D | 2.7190% | 2.5867% | 2.4792% | 2.3455% |
| 22 default Surface3D control | 2.4862% | 2.4862% | 2.2959% | 2.2959% |
| 25 authored view3D control | 2.7943% | 2.7943% | 2.9275% | 2.9275% |

The focused planner contract compiled and passed again with `--no-build`.
