# FreeP Surface3D frame fidelity

Date: 2026-07-20
Corpus: `tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`
Reference: `tools/FreeP.RenderCompare/corpus/pptx-ref/22-chart-baseline-depth/slide-01.png`

## Scope

The shared `ChartRenderPlanner` now registers the imported Surface3D value-axis
top at normalized Y=42 and uses PowerPoint's 0.5-unit projected frame stroke.
The coordinates scale from the chart plot, so WPF and Avalonia consume the
same renderer-neutral wall, gridline, axis, and tick primitives at any plot
size. Authored Surface3D charts retain their existing frame geometry, opacity,
and 0.7-unit stroke.

The WPF and Avalonia renderers remain thin consumers of the shared scene plan.
No comparison threshold, reference image, backend-specific geometry, or
single-facet coordinate was changed.

## Evidence

The committed PowerPoint COM reference is 1280x720 and has SHA-256
`162D9EB507140C2E9A593E84B1E0DD0C856208CB7968E8717284DC55671170E4`.
Fresh Release WPF and Avalonia renders were compared against that reference.

| Backend | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.5736% | 2.5546% |
| Avalonia whole slide | 2.3146% | 2.2959% |
| WPF Surface ROI `(560,90)-(1030,310)` | 5.0846% | 4.9152% |
| Avalonia Surface ROI `(560,90)-(1030,310)` | 5.0526% | 4.8853% |
| WPF tight mesh/frame ROI `(590,105)-(980,300)` | 6.2478% | 6.0165% |
| Avalonia tight mesh/frame ROI `(590,105)-(980,300)` | 6.2522% | 6.0239% |

The stock, scatter, and 100%-stacked charts receive no changed planner
primitives. Stock and scatter were byte-stable in both hosts; the Avalonia
stacked control was also byte-stable. Two WPF antialias pixels changed in the
stacked-chart title between independent renders, outside the Surface3D region.
A broad front-plane drop, thicker 1.0-unit frame, front-axis endpoint shifts,
back-right wall shift, and foreground-axis paint reordering were measured and
rejected because they worsened one or both host comparisons.

## Verification

- `ChartBaselineCorpusTests` locks the canonical 360x189 frame registration.
- `ChartRenderPlannerTests` locks arbitrary-size scaling and preserves authored
  Surface3D behavior.
- Both WPF and Avalonia evidence images are nonblank 1280x720 renders.
- Focused corpus and planner tests: 215 passed.
