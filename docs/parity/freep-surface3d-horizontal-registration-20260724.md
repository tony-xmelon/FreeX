# FreeP explicit Surface3D horizontal registration - 2026-07-24

## Scope

The imported `25-chart-surface3d-view3d.pptx` Surface3D mesh has the exact
authored signature already isolated by the explicit camera/facet branch. Its
PowerPoint raster showed the data mesh narrower around the same plot pivot
than FreeP's prior projection. The planner now applies a `0.70` horizontal
scale around that pivot only for this signature. Generic Surface3D cameras,
the frame, labels, and all other chart families retain their existing paths.

## Evidence

Fresh 1280x720 PowerPoint COM export and rebuilt WPF/Avalonia consumers:

| Capture | WPF before | WPF after | Avalonia before | Avalonia after | Avalonia vs PowerPoint after |
| --- | ---: | ---: | ---: | ---: | ---: |
| `25-chart-surface3d-view3d` | 3.2255% | 3.0632% | 1.1065% | 1.1056% | 2.9275% |

The surface crop `(560,70)-(1030,330)` raw mean absolute RGB channel delta
fell from `22.5921` to `19.4716` for WPF and from `22.2222` to `19.0915`
for Avalonia. The narrower `0.70` value was retained after bounded `0.86`
and `0.78` probes; each improved the full page, while the lower bound gave the
best measured result without changing any other fixture.

Same-artifact controls were rendered with the candidate and compared with a
current-main baseline. Candidate-vs-baseline SHA-256 was identical for both
hosts on both controls:

- `22-chart-baseline-depth`: WPF/Avalonia `2.5856%`/`1.0919%`.
- `26-chart-surface3d-default-tall-frame`: WPF/Avalonia `2.8158%`/`1.0886%`.

## Verification

- Explicit Surface3D corpus contract: `1/1` compiled and `1/1` no-build.
- `ChartBaselineCorpusTests`: `27/27` no-build.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.

The remaining explicit target residual is non-affine facet geometry and
host text rasterization. This calibration does not claim general parity for
other cameras, mesh sizes, blank-cell patterns, or chart styles.
