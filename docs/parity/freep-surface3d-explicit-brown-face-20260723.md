# FreeP explicit Surface3D brown-face parity - 2026-07-23

## Scope

The imported `25-chart-surface3d-view3d.pptx` Surface3D branch already has
PowerPoint-matched camera, horizontal registration, and the measured facet
palette. Its remaining large local material mismatch was the dark-brown
`#B35E24` near-left fold face. PowerPoint's exact-color mask contained `3,332`
pixels at `(751,177)-(814,259)`, while WPF's existing projected triangle
contained only `569` pixels at `(796,206)-(856,256)`.

The WPF-only exact imported-camera branch now uses a five-vertex measured
brown face. The shared mesh, Avalonia facets, frame, labels, and every other
facet remain unchanged.

## Evidence

Fresh matching 1280x720 PowerPoint comparison:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF whole slide | `2.9318%` | `2.8657%` |
| WPF surface ROI `(580,90)-(980,320)` | `6.7087%` | `6.0468%` |
| WPF brown ROI `(740,170)-(830,265)` | `15.7095%` | `8.9224%` |

The candidate brown mask contains `2,537` exact pixels at
`(752,185)-(812,258)`. The neighboring WPF controls remained SHA-256 stable:

- `22-chart-baseline-depth`
- `26-chart-surface3d-default-tall-frame`

Avalonia remains on the shared renderer-neutral facet path; its PowerPoint
comparison remains `2.9275%` for the explicit-camera deck.

## Verification

- `ChartBaselineCorpusTests`: `31/31` compiled and passed.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- WPF target and both neighboring controls rendered from the rebuilt consumer.
- The explicit brown-face vertex contract is asserted in
  `ChartBaselineCorpusTests`.

This is a signature-scoped WPF correction, not a general Surface3D topology
model; other cameras and mesh shapes remain independently gated.
