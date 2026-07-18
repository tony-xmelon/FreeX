# FreeP WPF soft-edge inner feather - 2026-07-18

## Scope

`08-effects.pptx` contains an imported round-rectangle with `a:softEdge
rad="101600"`. The shared planner correctly preserves the authored radius,
but WPF paints its concentric soft-edge pens centered on the contour before
the opaque shape fill. That makes the visible feather predominantly an outer
halo, while PowerPoint keeps the feather mostly inside the authored shape
bounds.

## Change

The WPF shape compositor now narrows the outer spread of shape soft-edge pens
to `20%` of the shared stroke width. This is renderer-local: shared effect
metadata, the Avalonia compositor, text soft edges, and ordinary shape fills
are unchanged.

## Evidence

Fresh 1280x720 PowerPoint COM and WPF Release captures:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF whole page | 1.3797% | 1.2723% |
| Soft-edge ROI `(930,80)-(1250,350)` | 6.6401% | 5.4943% |
| Raw center-row outer bbox | `(949,1237)` | `(957,1228)` |
| PowerPoint raw center-row outer bbox | `n/a` | `(959,1227)` |

The `12-fills` and `22-chart-baseline-depth` WPF PNG controls are SHA-256
identical before and after. `13-wordart` is also SHA-256 identical. Avalonia
`08-effects` remains unchanged at `1.4705%`.

## Verification

- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- Focused `SlideCanvas_GlowAndSoftEdgeRuns_DoesNotThrow`: 1/1.
- Fresh PowerPoint COM comparison: 1/1 slide, 1280x720.
