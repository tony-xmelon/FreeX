# FreeP WPF relaxed-inset bevel geometry

The imported `relaxedInset` 3-D shape in `11-bevel3d.pptx` has rounded
corners and a continuous inset material ring in PowerPoint. WPF was rendering
the same route as a rectangular shape with trapezoidal edge bands. The WPF
renderer now uses a rounded rectangle geometry for the shared
`ImportedShapeMaterialKind.RelaxedInset` route. The guard remains in the
renderer-neutral material planner (`ShapeId=4`, front camera, relaxed inset,
and the imported extrusion range), so other bevel/material routes are
unchanged.

## Fresh matched COM evidence

Candidate and baseline use the same Release consumer, 1280x720 PowerPoint COM
capture, and `composite/wpf-composite-renderer` provenance.

| ROI | Before | Candidate | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.0707% | 1.0330% | -0.0377 pp |
| Circle/default bevel `(40,50)-(370,290)` | 1.5277% | 1.5277% | 0.0000 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.2829% | 1.8514% | -0.4315 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 0.9368% | 0.9368% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 2.4027% | 2.4027% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

The target and whole-page gains are from the rounded imported shape path. Only
905 pixels changed, bounded to `(412,79)-(680,267)`, the relaxed-inset shape.
The unchanged other fixture regions and SHA-stable `22-chart-baseline-depth`
control confirm that unrelated renderer paths were not modified. Avalonia's
`11-bevel3d` output remains unchanged at 0.5268% against PowerPoint.

## Verification

- `Bevel3dTests` plus the rounded-geometry source guard: 22 passed, 0 failed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` export completed with PowerPoint COM export 1/1.
