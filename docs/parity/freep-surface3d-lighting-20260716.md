# FreeP Imported Surface3D Lighting

Date: 2026-07-16

## Scope

Match the default PowerPoint lighting of imported `Surface3D` facets in
`22-chart-baseline-depth.pptx` while preserving the existing projected frame,
blank-cell fallback, triangulation, and authored-surface path.

## Evidence

PowerPoint COM reports the imported chart's default 3-D view as:

- `Rotation=20`
- `Elevation=15`
- `Perspective=30`
- `HeightPercent=100`
- `DepthPercent=100`

Reference pixel probes show the near-left surface facets close to the theme
base colors, darker shading across the front row, and a moderate rear-row
falloff. FreeP now applies a topology-aware imported lighting factor to each
facet color. Authored surfaces do not enter this path.

## Verification

- Focused chart tests: `181 passed, 0 failed`.
- RenderCompare build: `0 warnings, 0 errors`.
- `22-chart-baseline-depth.pptx` WPF mean channel diff: `4.4396%`, down from
  `4.5555%`.
- `22-chart-baseline-depth.pptx` Avalonia mean channel diff: `4.4217%`, down
  from `4.5369%`.
- Both renders are `1280x720` and dimensions match the PowerPoint reference.

Evidence artifacts:

- `artifacts/freep-surface3d-lighting-20260716/final-wpf/`
- `artifacts/freep-surface3d-lighting-20260716/final-avalonia/`

