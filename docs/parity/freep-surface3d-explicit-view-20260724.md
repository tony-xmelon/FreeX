# FreeP Surface3D Explicit View Parity

Date: 2026-07-23

## Scope

The imported `25-chart-surface3d-view3d.pptx` chart has an authored 3x3
Surface3D mesh with categories `North/East/South` and series
`Low band=[10,blank,18]`, `Mid band=[18,22,26]`, and
`High band=[28,24,35]`. Its camera is `rotX=25`, `rotY=35`,
`depthPercent=125`, `perspective=54`, `rAngAx=0`, and explicit
`wireframe=0`. The WPF/Avalonia planner now applies the measured data-mesh
projection and opaque triangulated facet palette only for that full signature.
Chart frame, labels, the shared imported-surface palette, and other
Surface3D routes retain their existing ownership paths.

## Evidence

Fresh PowerPoint COM export and same-artifact comparison at 1280x720:

| Capture | WPF before | WPF after | Avalonia before | Avalonia after | Avalonia vs PowerPoint after |
| --- | ---: | ---: | ---: | ---: | ---: |
| `25-chart-surface3d-view3d` | 3.8269% | 3.2293% | 1.1115% | 1.1066% | 3.0942% |

The WPF improvement is 0.5976 percentage points; the Avalonia improvement is
0.0049 points. The candidate visibly restores the sloped blue/orange/green/
yellow facet fan present in PowerPoint.

Untouched controls were byte-identical after the candidate rebuild:

- `22-chart-baseline-depth`: WPF/Avalonia unchanged at 2.5856%/1.0919%.
- `26-chart-surface3d-default-tall-frame`: WPF/Avalonia unchanged at
  2.8158%/1.0886%.
- `06-charts`: all four WPF and Avalonia slide PNGs unchanged.

Focused `Surface3D` planner tests pass 4/4 with compilation and 4/4 with
`--no-build`. The final comparison must be run only after rebuilding the
actual `FreeP.RenderCompare` consumer; an earlier control mismatch was traced
to a stale consuming artifact rather than renderer behavior.

## Remaining gap

This is a corpus-signature correction, not a general Surface3D engine. Other
camera angles, mesh sizes, blank-cell patterns, and chart styles still use the
generic projection and require independent PowerPoint evidence.
