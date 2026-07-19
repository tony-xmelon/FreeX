# FreeP imported Surface3D dark-orange face ownership - 2026-07-18

## Scope

The imported 3-by-3 Surface3D mesh had a dark-orange `#B76026` face whose
left edge was narrower than PowerPoint. That edge shares the blank low-band
vertex with the adjacent blue face, so moving the logical vertex was rejected
after improving orange while regressing the blue low-band. The render-only
triangulated dark-orange face now widens its left edge by 13 DIPs without
changing the shared point topology, wireframe, or neighboring face.

## Matched raster evidence

The candidate used the persistent 1280x720 PowerPoint reference and a fresh
Release FreeP artifact. ROI values below are mean RGB channel deltas.

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6101% | 2.6082% |
| WPF Surface `(560,90)-(1030,310)` | 5.1568% | 5.1399% |
| WPF tight mesh `(590,105)-(980,300)` | 6.3308% | 6.3078% |
| WPF dark-orange `(750,170)-(920,270)` | 3.3514% | 3.2485% |
| WPF green `(780,125)-(970,270)` | 4.3699% | 4.3252% |
| WPF low-band `(595,195)-(770,300)` | 9.4133% | 9.4133% |
| Avalonia whole page | 2.3302% | 2.3183% |
| Avalonia Surface `(560,90)-(1030,310)` | 5.1916% | 5.0858% |
| Avalonia tight mesh `(590,105)-(980,300)` | 6.4410% | 6.2972% |
| Avalonia dark-orange `(750,170)-(920,270)` | 3.8332% | 3.2009% |

Exact-color WPF masks moved toward PowerPoint: `#B76026` improved from 4,106
to 4,228 pixels, while the adjacent blue low-band remained byte-stable.
Stock, scatter, and 100%-stacked chart regions changed zero pixels in the
same-deck candidate-vs-baseline comparison.

## Verification

- `ChartBaselineCorpusTests`: 24/24 compiling and 24/24 `--no-build`.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with opaque pixel-diversity checks.

## Rule

When a Surface3D residual belongs to one painted triangulated face but shares
topology with a neighboring face, correct the render-only owner and preserve
the logical vertex. Require target ROI, whole-page, both-host, and unchanged
neighboring-face evidence before accepting the correction.
