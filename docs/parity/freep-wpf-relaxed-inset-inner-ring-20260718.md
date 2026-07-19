# FreeP WPF relaxed-inset bevel inner ring

This slice addresses the imported `11-bevel3d.pptx` `BevelRelaxed` shape. The
PowerPoint raster contains a second shaded material band between the outer
highlight wedge and the orange front face. FreeP's generic bevel path stopped
after the outer wedge, leaving the inset bevel visibly too shallow.

## Change

- WPF adds a second shaded inner ring only when the authored bevel preset is
  `relaxedInset`.
- Avalonia remains on its previous path because the same polygon rasterization
  regressed its matched control; renderer-specific evidence is kept separate.
- Circle, angle, cross, contour, ordinary outlines, and all non-relaxed bevel
  presets are unchanged.

## Fresh matched COM evidence

The WPF candidate and baseline use the same current Release renderer family,
`1280x720` PowerPoint COM export, and `composite/wpf-composite-renderer`
provenance. The final candidate was rebuilt before the last render.

| ROI | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.2939% | 1.2920% | -0.0019 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.9216% | 2.8993% | -0.0222 pp |
| Circle bevel `(40,50)-(370,290)` | 1.8406% | 1.8406% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 3.4573% | 3.4573% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

The same probe improved WPF but regressed Avalonia's relaxed-inset ROI
`3.0362% -> 3.0500%`, so it was reverted from Avalonia. WPF controls
`08-effects`, `13-wordart`, and `07-customgeom` remained byte-identical.

## Verification

- Focused `Bevel3dTests`: 21 passed, 0 failed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release`: 0 warnings, 0 errors.
- Final WPF render completed successfully after the final Release build.
