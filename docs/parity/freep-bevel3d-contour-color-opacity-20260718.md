# FreeP explicit 3-D contour color opacity parity

This slice fixes the imported `11-bevel3d.pptx` `ContourOnly` shape. The DOCX
analogue is not involved: DrawingML `a:contourClr` carries an explicit RGB
color with no alpha channel, while both FreeP renderers were compositing it at
alpha 200. PowerPoint paints the authored contour color opaque.

## Change

- WPF and Avalonia now paint `ResolvedShapeEffects.ContourColor` at alpha 255.
- The change stays in the renderer-local contour path; bevel wedges, extrusion
  geometry, scene-camera projection, and ordinary outlines are unchanged.

## Fresh matched COM evidence

Candidate and baseline use the same current Release artifact, `1280x720`
PowerPoint COM export, and `composite/wpf-composite-renderer` provenance.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.3231% | 1.2939% | -0.0292 pp |
| Circle bevel `(40,50)-(370,290)` | 1.8406% | 1.8406% | 0.0000 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.9216% | 2.9216% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 3.4573% | 3.4573% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 2.1511% | 1.8248% | -0.3263 pp |

Unrelated current WPF control renders for `08-effects`, `13-wordart`, and
`07-customgeom` were byte-identical to the pre-probe corpus renders.

## Verification

- Focused `Bevel3dTests`: 21 passed, 0 failed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release`: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` export: WPF, Avalonia, and PowerPoint completed
  for the target slide.
