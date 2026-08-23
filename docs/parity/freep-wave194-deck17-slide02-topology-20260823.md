# FreeP Wave194 deck17 slide02 topology evidence

Date: 2026-08-23

This slice closes the evidence gap for the current FreeP residual without
making a speculative renderer change.

## What the Office deck says

The committed `17-bullets-autofit.pptx` corpus slide 02 is a two-text-shape
layout with:

- a title shape using `spAutoFit`, an inherited run font, and the effective
  theme font `Aptos Display` from `theme.majorLatin` at 28 pt, with the text
  `Autofit Shrink Demo`
- a body shape using `noAutofit`, an inherited run font, and the effective
  theme font `Aptos` from `theme.minorLatin` at 18 pt, with one column, no
  bullets, and eight one-run paragraphs

The loaded FreeP model therefore reports `run.FontFamily == null` for both
shapes; the effective faces are resolved from the committed Office theme, not
from an explicit run-level font override. The retained topology evidence makes
both values explicit as `rawRunFontFamily` and `effectiveFontFamily`, together
with `fontFamilySource`. The Office theme carries `Aptos Display` as the major
Latin face and `Aptos` as the minor Latin face. The retained topology evidence
is recorded in
[`topology.json`](./evidence/freep-wave194-deck17-slide02-topology-20260823/topology.json).

The evidence is bound to the complete source corpus file, not only the Office
reference PNG:

- path: `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`
- raw whole-file SHA-256:
  `f4fc0c9e3d048cac3e0c7fe3d929029238448ff05281be542df105a46c6c88ea`

## Why no runtime change

Wave193 already showed that the largest current residual stays at slide 02 with
`3.0587%` WPF/Office, `2.5360%` Avalonia/Office, and `2.9091%`
WPF/Avalonia. This topology evidence rules out the investigated structural,
autofit, and theme-inheritance hypotheses. The visual residual remains
unresolved: without renderer-level evidence, this slice does not establish
host font or raster behavior as its cause.

## Retained evidence

The retained Wave193 bundle still provides the current-source comparison
counts and metrics:

- `106/106` current-source WPF/Avalonia renders
- `159/159` Office/pair comparisons
- `1.0309% / 0.9962% / 0.6097%` aggregate WPF/Office, Avalonia/Office, and
  WPF/Avalonia averages
- `3.0587% / 2.5360% / 2.9091%` target slide 02 residuals

The Office PNG provenance remains pinned by the committed reference bundle:

- `docs/parity/evidence/avalonia-parity-wave193-freep-evidence-20260823/references.json`
- `docs/parity/evidence/avalonia-parity-wave193-freep-evidence-20260823/images.json`

## Decision

No renderer code is changed in Wave194. The evidence slice now documents the
exact Office-authored topology, pins the source PPTX and retained reference
hashes, and leaves the visual cause unresolved without introducing a
fixture-specific runtime change.
