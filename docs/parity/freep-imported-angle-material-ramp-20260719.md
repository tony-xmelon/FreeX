# FreeP imported angle material ramp

This slice addresses the imported `BevelAngle` shape in
`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`. PowerPoint's green ellipse
uses a narrow `orthographicFront` material ramp around its front face. The
generic WPF bevel path rendered a broad bright edge instead.

## Change

- WPF paints the measured green core and four narrow material bands after the
  generic bevel pass.
- The pass is guarded by source shape id 5, the `orthographicFront` camera,
  `cross` bevel, the authored 53.33-DIP extrusion signature, and a solid fill.
- The shared compositor, Avalonia, circle/relaxed/cross/contour paths, and
  other extrusion signatures are unchanged.

## Fresh matched PowerPoint evidence

Both images are fresh 1280x720 captures from the same current Release artifact
and use `composite/wpf-composite-renderer` for the WPF side.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.1034% | 1.0707% | -0.0327 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 0.9368% | -0.3921 pp |
| Circle bevel `(40,50)-(370,290)` | 1.5277% | 1.5277% | 0.0000 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.2829% | 2.2829% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 2.4027% | 2.4027% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

## Verification

- Focused `Bevel3dTests`: 21/21 with the no-server retry.
- WPF Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF render completed 1/1 slides.

This is intentionally not a general extrusion calibration; the remaining
contour/depth owner needs separate side-face evidence.
