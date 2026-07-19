# FreeP imported relaxed-inset material ramp

This slice addresses the imported `BevelRelaxed` shape in
`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`. PowerPoint's
`relaxedInset` face has a bright orange edge highlight, a dark inner ring, and
separate side/bottom falloff. The existing generic WPF wedge path preserved the
shape but not that material raster.

## Change

- WPF paints the measured core and four relaxed-inset material bands after the
  generic bevel pass.
- The pass is guarded by source shape id 4, the `orthographicFront` camera,
  `relaxedInset` bevel, the authored 26.67-DIP extrusion signature, and a
  solid fill.
- The shared compositor, Avalonia, circle/angle/contour/cross paths, and other
  extrusion signatures are unchanged.

## Fresh matched PowerPoint evidence

Both images are fresh 1280x720 captures from the same current Release artifact
and use `composite/wpf-composite-renderer` for the WPF side.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.1564% | 1.1034% | -0.0530 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.8993% | 2.2829% | -0.6164 pp |
| Circle bevel `(40,50)-(370,290)` | 1.5277% | 1.5277% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 2.4027% | 2.4027% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

## Verification

- Focused `Bevel3dTests`: 21/21 with the no-server retry.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF render completed 1/1 slides.

The remaining `BevelAngle` and contour/depth material owners remain separate;
this correction is not generalized to arbitrary `extrusionH` values.
