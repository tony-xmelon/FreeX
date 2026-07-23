# FreeP radar grid-color probe rejected - 2026-07-23

## Scope

The current imported radar fixture in `18-chart-types.pptx`, slide 3, uses
nine rings and five categories. The PowerPoint raster's dominant neutral ring
tone was `#898989`, while the current WPF raster's dominant ring tone was
`#BFBFBF`. A bounded shared-planner probe changed only the imported radar
grid/spoke stroke color from `#808080` to `#151515`, preserving the existing
0.5-DIP stroke width and all geometry.

## Result

The probe was built into the consuming Release RenderCompare artifact and
rendered at the same 1280x720 dimensions as the persistent PowerPoint
baseline:

| Host | Baseline | Candidate | Result |
| --- | ---: | ---: | --- |
| WPF slide 3 | 1.0622% | 1.1644% | rejected |
| Avalonia slide 3 | 0.4080% | 1.1151% | rejected |

The WPF radar-plot crop also regressed from `3.3049%` to `3.7471%` mean
channel delta. The candidate's most common neutral raster became `#8A8A8A`,
close to the PowerPoint ring tone, but the complete ring/spoke antialiasing
and geometry remained worse. This confirms that the residual cannot be
accepted from a dominant-color match alone.

The source change was reverted. No radar behavior changed, and no unrelated
chart controls were modified.

## Verification

- Focused imported-radar presentation contract: 1/1 compiled and passed.
- RenderCompare Release build: 0 warnings, 0 errors.
- Both WPF and Avalonia candidate captures were same-host, same-dimension
  renders compared with the existing PowerPoint baseline.

## Process rule

For chart grid calibration, require ring/spoke ROI and full-page evidence for
both active renderers where the shared planner is changed. Exact-color or
dominant-tone alignment is diagnostic only; it is not acceptance evidence when
the rasterized plot regresses.
