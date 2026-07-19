# FreeP bevel preset depth probe rejection - 2026-07-17

## Fixture

`tools/FreeP.RenderCompare/corpus/11-bevel3d.pptx`, slide 1, matched
1280x720 PowerPoint COM and FreeP WPF captures.

## Probe

The renderer temporarily increased the visible front-wedge fraction from the
accepted generic `0.40` calibration to `0.65` only for the default/circle and
`relaxedInset` bevel presets. `cross`, `softRound`, contour-only, scene-camera,
and non-3D shapes were left on the existing path.

The candidate was rejected. Using the identical PowerPoint PNG (SHA-256
`86B6B6D16927D720300A845BE7FADAF98A5C12882127D4127FD7BBFCE7D4661B`) for
both renders, whole-page mean channel error moved from `1.3231%` to `1.3645%`.
The targeted bevel ROIs also regressed:

| ROI | Accepted | Candidate |
|---|---:|---:|
| Circle bevel `(70,70)-(355,275)` | 2.4951% | 2.6965% |
| Relaxed inset `(405,70)-(690,275)` | 3.9604% | 4.4217% |
| Angle + extrusion `(738,70)-(1020,275)` | 1.7655% | 1.7655% |
| Cross + Scene3D `(40,310)-(385,515)` | 4.6440% | 4.6440% |
| Contour + depth `(400,310)-(690,515)` | 2.9851% | 2.9851% |

The small gains outside the target bevels did not offset the target regressions,
so the source change was reverted. This rejects simple preset-scoped depth as a
model for PowerPoint's remaining 3-D bevel difference; future work needs
shape-aware material/lighting geometry rather than wider front strips.

## Verification

- Focused `Bevel3dTests`: 21/21 after the compiling probe and again with `--no-build`.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Candidate render used matching PowerPoint COM export and `composite/wpf-composite-renderer` capture provenance.
- Product source was reverted cleanly after the negative probe.
