# FreeP explicit Surface3D material parity - 2026-07-23

## Scope

The imported `25-chart-surface3d-view3d.pptx` chart has the exact authored
3x3 Surface3D signature already handled by the explicit camera/facet branch:
`North/East/South`, `Low band=[10,blank,18]`, `Mid band=[18,22,26]`,
`High band=[28,24,35]`, `rotX=25`, `rotY=35`, `depthPercent=125`,
`perspective=54`, and explicit `wireframe=0`.

This slice keeps the existing geometry, frame, labels, and generic surface
palette unchanged. It gives only that exact branch the lighter PowerPoint
facet materials measured from the same 1280x720 COM capture.

## Evidence

Fresh current-artifact PowerPoint export and WPF/Avalonia comparison:

| Capture | WPF before | WPF after | Avalonia before | Avalonia after | Avalonia vs PowerPoint after |
| --- | ---: | ---: | ---: | ---: | ---: |
| `25-chart-surface3d-view3d` | 3.2293% | 3.2255% | 1.1066% | 1.1065% | 3.0903% |

For the surface crop `(560,70)-(1030,330)`, the raw mean absolute RGB channel
delta fell from `22.6652` to `22.5921` for WPF and from `22.2972` to
`22.2222` for Avalonia. The WPF candidate changed 24,996 pixels, all inside
the target chart signature's surface region.

Same-artifact controls were rendered once with the palette removed and once
with the candidate restored. Candidate-vs-baseline SHA-256 was identical for
both hosts on both controls:

- `22-chart-baseline-depth`: WPF/Avalonia `2.5856%`/`1.0919%`.
- `26-chart-surface3d-default-tall-frame`: WPF/Avalonia `2.8158%`/`1.0886%`.

## Verification

- Explicit Surface3D corpus contract: `1/1` compiled and `1/1` no-build.
- `ChartBaselineCorpusTests`: `27/27` no-build.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.

The remaining target residual is still primarily mesh geometry/rasterization
and host text rendering; this slice does not claim general Surface3D parity
for other cameras, mesh sizes, blank patterns, or chart styles.
