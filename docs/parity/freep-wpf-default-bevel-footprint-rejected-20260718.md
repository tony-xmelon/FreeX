# FreeP WPF default bevel footprint probe rejected

This probe tested the imported default bevel in `11-bevel3d.pptx`, whose
`a:bevelT` payload omits `prst` and `h`. The reader already applies DrawingML's
default `h` value, so the experiment changed only the WPF renderer's local
visible bevel-surface fraction from `0.4` to `0.8` for the unnamed/default
bevel path. Named bevel presets and Avalonia were unchanged.

## Fresh matched COM evidence

Candidate and baseline used the same current Release artifact, `1280x720`
PowerPoint COM export, and `composite/wpf-composite-renderer` provenance.

| ROI | Before | Candidate | Delta |
| --- | ---: | ---: | ---: |
| WPF whole page | 1.2913% | 1.3152% | +0.0239 pp |
| Circle/default bevel `(40,50)-(370,290)` | 1.8406% | 2.1186% | +0.2780 pp |
| Relaxed inset `(380,50)-(710,290)` | 2.8993% | 2.8993% | 0.0000 pp |
| Angle + extrusion `(720,50)-(1040,290)` | 1.3289% | 1.3289% | 0.0000 pp |
| Cross + Scene3D `(20,290)-(400,540)` | 3.4573% | 3.4573% | 0.0000 pp |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8248% | 0.0000 pp |

The candidate was rejected and reverted. The raw top-edge scan showed that a
wider band changed the default bevel geometry away from PowerPoint rather than
recovering the missing material raster. Treat default bevel lighting/material
composition as a separate problem from the shared 2-D footprint.

## Verification

- Focused `Bevel3dTests`: 21 passed, 0 failed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` export completed with PowerPoint COM export 1/1.
