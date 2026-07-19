# FreeP imported isometric cross depth parity

This slice addresses the `Cross + Scene3D` shape in
`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`. PowerPoint paints a short,
dark projected side wall below the front face even though this shape has no
`extrusionH`; the authored `isometricTopUp` camera and `softRound` bevel own
that visible depth.

## Change

- WPF paints one local projected depth copy before the front face.
- The pass is guarded by the imported source shape id, `isometricTopUp` camera,
  `softRound` bevel, no authored extrusion, and a solid face fill.
- The correction is WPF-local; shared geometry, Avalonia, ordinary bevels, and
  explicit extrusion paths remain unchanged.

## Fresh matched PowerPoint evidence

Both images are fresh 1280x720 captures from the same current Release artifact
and use `composite/wpf-composite-renderer` for the WPF side.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.2920% | 1.1833% | -0.1087 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 3.4573% | 2.4027% | -1.0546 pp |
| Circle bevel `(40,50)-(370,290)` | 1.8406% | 1.8406% | 0.0000 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.8993% | 2.8993% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

## Verification

- Focused `Bevel3dTests`: 21/21.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint export completed 1/1 slides.
- Fresh WPF render completed 1/1 slides.

The change is intentionally limited to the imported isometric camera sample;
the remaining true `extrusionH` owners still need shape-aware material and
side-face calibration.
