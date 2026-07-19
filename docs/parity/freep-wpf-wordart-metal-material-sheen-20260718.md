# FreeP WPF WordArt metal material sheen

Date: 2026-07-18

## Finding

The imported `13-wordart.pptx` ArchUp body stores `a:sp3d prstMaterial="metal"`.
FreeP preserved that value through the model and shared text layout, but both
renderers previously painted the authored solid fill without a material face
pass. The Word raster has a cool upper-face sheen that was missing from WPF.

## Change

- `ResolvedShapeEffects` now carries `PrstMaterial` through the shared effect plan.
- The shared text-effect planner emits a bounded metallic highlight gradient only
  for the exact `metal` material.
- WPF consumes that pass after the face fill and before the outline.
- Avalonia leaves the pass unpainted until its own material calibration is measured;
  `softEdge` and all non-material text paths are unchanged.

## Matched COM evidence

Fresh 1280x720 PowerPoint COM export, current Release artifact, and
`composite/wpf-composite-renderer` provenance:

| ROI | WPF before | WPF after | Delta |
| --- | ---: | ---: | ---: |
| WordArt whole page | 1.3614% | 1.3383% | -0.0231 pp |
| ArchUp `(690,215)-(1130,335)` | 2.7883% | 2.3849% | -0.4034 pp |
| ArchUp tight `(718,227)-(1096,315)` | 4.2598% | 3.6194% | -0.6404 pp |

The Avalonia image remained byte-identical to its pre-probe render and its
PowerPoint comparison remained `1.5077%`. The no-material `11-bevel3d` and
`08-effects` controls continued through their existing paths.

## Verification

- Focused `WordArtTests`: 31/31.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh `13-wordart`, `11-bevel3d`, and `08-effects` COM comparisons completed.
