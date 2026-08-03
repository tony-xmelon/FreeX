# Avalonia/WPF Parity Wave 130 Integration

Date: 2026-08-03

## Integrated Slices

- FreeX About now uses the shared Avalonia About host through a thin app
  wrapper. Fresh current-source WPF and Linux Docker/Xvfb captures are both
  560x420 at approximately 96 DPI. The canonical triage score is `0.107196`;
  this is the truthful replacement for the stale `0.084615` baseline, not a
  claimed raster improvement.
- FreeW Backstage Open now applies a route-scoped 17-DIP WPF-like scrollbar
  profile. Fresh paired evidence reduced the changed-pixel ratio from
  `15.1131%` to `12.8074%` and mean channel delta from `11.8908` to `11.2620`
  while preserving `semanticDifference: null`.
- FreeP equation arrays now share separator-aware `maxDist` and `objDist`
  parsing and layout across WPF and Avalonia, including opposing alignment
  splits, nested-width handling, and conservative malformed-value behavior.

## Evidence State

- FreeX has 94 WPF and 94 Avalonia manifest surfaces with 94 paired IDs, zero
  blank captures, zero expected-size mismatches, and zero scale-aware logical
  dimension mismatches.
- The fresh About pair reduces raw pixel-dimension mismatches from 22 to 21;
  the remaining 21 normalize by capture DPI.
- The cross-app dashboard retains zero actionable command gaps for FreeX,
  FreeW, and FreeP. These are coverage metrics, not a claim of complete visual
  parity.

## Focused Verification

- FreeX About and shared-shell suites: 92 focused tests passed.
- FreeW Backstage focused suite: 40 tests passed; fresh WPF and Avalonia
  captures both passed the content gate.
- FreeP equation-array suites: 339 shared presentation, 45 WPF, and 46
  Avalonia tests passed.
- Dialog visual evidence and cross-app dashboard generators both pass their
  freshness checks.

## Residuals

- FreeX About retains expected cross-toolkit text rasterization and native
  scrollbar differences at the new current-source baseline.
- FreeW Backstage Open remains honestly classified as a genuine visual
  mismatch despite the measured scrollbar improvement.
- FreeP equation-array parity is structural and render-plan parity; exact
  PowerPoint font metrics and authoritative raster identity remain outside
  this slice.

The parity goal remains active. Wave 130 closes these bounded residuals and
does not claim complete cross-app visual parity.
