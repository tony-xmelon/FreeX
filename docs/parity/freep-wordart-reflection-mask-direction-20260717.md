# FreeP WPF WordArt reflection mask direction

Date: 2026-07-17

## Finding

The imported `13-wordart.pptx` reflection uses a negative Y scale (`sy=-1`).
WPF's opacity mask was left in the untransformed direction, so the reflection
became darker away from the glyph instead of fading away from it. The WPF
reflection mask now reverses its gradient direction for the transformed copy;
the shared effect model and Avalonia path remain unchanged.

## Verification

Fresh 1280x720 comparison against the persistent PowerPoint COM capture:

- WPF whole page: `1.7121%` to `1.6546%`
- WPF Arch Up reflection ROI `(718,285)-(1095,310)`: `5.7088%` to `0.6645%`
- WPF Arch Up region `(718,225)-(1095,315)`: `5.8595%` to `4.2993%`
- Avalonia WordArt output: unchanged at `1.5077%` vs PowerPoint
- `08-effects.pptx` WPF and Avalonia no-reflection controls: byte-stable

Focused `WordArtTests` passed `29/29`; focused WPF `SlideCanvasTests` passed
`34/34`; and the `FreeP.RenderCompare` Release build completed with zero
warnings and errors.
