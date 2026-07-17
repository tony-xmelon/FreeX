# FreeP Surface3D view3D projection - 2026-07-17

## Scope

FreeP already retained `c:view3D` camera metadata through chart read, clone,
and write paths, but Surface3D rendering ignored those settings and always
used one fixed projection. The shared chart planner now normalizes elevation,
azimuth, perspective, height, and depth against PowerPoint's default
`rotX=15`, `rotY=20`, `perspective=30`, `hPercent=100`, and `depthPercent=100`
camera. Explicit authored Surface3D views therefore change the projected
mesh, while the calibrated imported baseline keeps its existing geometry.

## Verification

- `BuildSurfaceGeometryPlan_UsesAuthoredView3DForSurfaceProjection` verifies
  that authored camera changes move rear points right and upward.
- Surface and chart-baseline focused tests: 27 passed.
- `FreeP.App.Presentation.Tests` Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- COM comparison of `22-chart-baseline-depth.pptx` at `1280x720` remained
  WPF `3.1236%` and Avalonia `0.9706%`.

## Boundary

This closes camera metadata consumption for the shared Surface3D mesh
projection. Full PowerPoint perspective-wall and gridline raster parity for
the imported baseline remains a separate visual slice.
