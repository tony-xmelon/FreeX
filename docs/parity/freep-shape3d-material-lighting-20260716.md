# FreeP Scene3D Material Lighting Parity

Date: 2026-07-16

## Change

Solid fills on shapes with `a:scene3d` now receive the small face-color lift
that PowerPoint applies during its default material and light pass. Gradient,
pattern, picture, and non-3D fills are unchanged.

The source theme colors in `11-bevel3d.pptx` are darker than the colors in the
PowerPoint export. Applying the lift during composition keeps the authored
theme color intact while matching the rendered 3D face more closely.

## COM evidence

RenderCompare at 1280x720, fresh PowerPoint export:

| Corpus | WPF vs PowerPoint | Avalonia vs PowerPoint |
| --- | ---: | ---: |
| `11-bevel3d` before | 1.9143% | 1.7829% |
| `11-bevel3d` after | 1.3635% | 1.2290% |

The non-3D control deck `18-chart-types` remained stable:

| Corpus | WPF vs PowerPoint | Avalonia vs PowerPoint |
| --- | ---: | ---: |
| `18-chart-types` after | 1.0696% | 1.0343% |

The change does not attempt to model extrusion depth or camera projection;
those remain separate parity work.

## Verification

- `Bevel3dTests`: 21 passed.
- RenderCompare build: 0 warnings, 0 errors.
- COM-backed `11-bevel3d` and `18-chart-types` renders completed successfully.
