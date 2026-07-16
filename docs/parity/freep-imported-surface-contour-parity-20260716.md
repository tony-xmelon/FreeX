# FreeP Imported Surface3D Contour Parity

Date: 2026-07-16

## Scope

The imported `Surface3D` chart in `22-chart-baseline-depth.pptx` uses the
projected frame and surface wireframe, but does not render the value-derived
contour overlays used by FreeP's authored surface path. The shared planner now
suppresses contour primitives only for imported Surface3D charts; authored
surface charts retain their existing contour behavior.

## COM Evidence

Fresh PowerPoint exports and FreeP renders were captured at 1280x720, using the
previous imported-chart stroke correction as the control.

| Comparison | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint, deck 22 | 3.6767% | 3.6712% |
| Avalonia vs PowerPoint, deck 22 | 3.5957% | 3.5906% |
| WPF vs Avalonia, deck 22 | 0.9730% | 0.9722% |

Removing the imported wireframe as a separate probe worsened the residual and
was discarded.

## Verification

- `ChartBaselineCorpusTests` and `ChartRenderPlannerTests` cover imported and authored contour behavior.
- `FreeP.RenderCompare` was rebuilt successfully with 0 warnings and 0 errors.
- PowerPoint COM export completed for the authoritative deck.
