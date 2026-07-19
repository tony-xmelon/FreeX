# FreeP imported circle bevel material ramp

This slice addresses the imported `BevelCircle` shape in
`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`. PowerPoint paints a flat
`#1B698C` face with a short, graduated four-edge material ramp. The generic
WPF bevel wedges produced a stepped highlight and left the face slightly dark.

## Change

- WPF paints the measured face core and four edge gradients for the exact
  imported circle signature.
- The pass is guarded by source shape id 3, the `orthographicFront` camera, an
  unnamed top bevel, no authored extrusion, and a solid fill.
- The shared compositor, Avalonia, named bevel presets, and authored extrusion
  paths are unchanged.

## Fresh matched PowerPoint evidence

Both images are fresh 1280x720 captures from the same current Release artifact
and use `composite/wpf-composite-renderer` for the WPF side.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.1833% | 1.1564% | -0.0269 pp |
| Circle bevel `(40,50)-(370,290)` | 1.8406% | 1.5277% | -0.3129 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.8993% | 2.8993% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 2.4027% | 2.4027% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

## Verification

- Focused `Bevel3dTests`: 21/21.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint export completed 1/1 slides.
- Fresh WPF render completed 1/1 slides.

The remaining named bevel and authored extrusion owners require their own
material/side-face evidence; this change deliberately does not generalize to
them.
