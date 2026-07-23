# FreeP Surface3D View3D Dark-Blue Fold

Date: 2026-07-23

PowerPoint's explicit `25/35` Surface3D view kept the near dark-blue fold at
approximately `(712, 213)-(761, 257)` in the 1280x720 reference. The WPF-only
explicit-camera facet was mostly occluded at the previous registration, so the
facet was moved to the measured local plot points `(115, 150)`, `(153, 104)`,
and `(167, 153)`. The guard remains inside the exact imported
`Low band/Mid band/High band`, `North/East/South`, `RotationX=25`, `RotationY=35`,
`DepthPercent=125`, `Perspective=54`, `Wireframe=false` signature.

Matched PowerPoint reference evidence:

- WPF whole-page mean channel delta: `2.8657% -> 2.7943%`.
- WPF surface ROI `(580,80)-(1020,330)`: approximately `5.495% -> 4.900%`.
- Only 1,440 WPF pixels changed, bounded to `(711,209)-(775,257)` in the mesh.
- `26-chart-surface3d-default-tall-frame`: `2.7190%`, unchanged.
- `22-chart-baseline-depth`: `2.4862%`, unchanged.
- Avalonia remains unchanged because it does not consume WPF-only render facets.

The accepted change is renderer-local: shared chart semantics, the renderer-neutral
facets, and generic Surface3D cameras remain unchanged.
