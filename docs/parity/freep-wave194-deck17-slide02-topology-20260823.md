# FreeP Wave194 deck17 slide02 topology evidence

Date: 2026-08-23

This slice closes the evidence gap for the current FreeP residual without
making a speculative renderer change.

## What the Office deck says

The committed `17-bullets-autofit.pptx` corpus slide 02 is a two-text-shape
layout with:

- a title shape using `spAutoFit`, `Aptos Display`, 28 pt, and the text
  `Autofit Shrink Demo`
- a body shape using `noAutofit`, `Aptos`, 18 pt, one column, no bullets, and
  eight one-run paragraphs

The Office theme carries `Aptos Display` as the major Latin face and `Aptos`
as the minor Latin face. The retained topology evidence is recorded in
[`topology.json`](./evidence/freep-wave194-deck17-slide02-topology-20260823/topology.json).

## Why no runtime change

Wave193 already showed that the largest current residual stays at slide 02 with
`3.0587%` WPF/Office, `2.5360%` Avalonia/Office, and `2.9091%`
WPF/Avalonia. The retained probes rejected the broader typography swaps that
would have been needed for a general renderer correction, so the current
remaining delta is still best explained as host font/raster variance rather
than a topology bug.

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
exact Office-authored topology and the retained reference hashes, which closes
the concrete gap without introducing a fixture-specific runtime hack.
