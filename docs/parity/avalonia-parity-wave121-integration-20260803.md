# Avalonia parity Wave 121 integration

Date: 2026-08-03

## Accepted slices

- FreeX: aligned the Format Cells Alignment tab to shared WPF-authoritative
  layout metrics and promoted fresh paired 620x540, 96-DPI evidence. The
  focused mean pixel difference is 2.5714%.
- FreeW: aligned Page Setup field and tab geometry, made the visual-harness
  section-start seed explicit and shared, and verified both hosts render
  `Section start: New page`. Fresh six-state comparison evidence and a
  production Ubuntu 24.04 Docker/Xvfb smoke are recorded in the focused note.
- FreeP: implemented shared OMML `m:smallFrac` parsing, CT_OnOff inheritance,
  package propagation, and script-size numerator/denominator layout for
  stacked, linear, and skewed fractions. Paired WPF/Avalonia renderer tests use
  the same shared render plan; no PowerPoint COM pixel baseline was available.

No evidence-free SmartArt geometry was accepted during this wave.

## Generated evidence

The canonical dialog visual summary and cross-app dashboard were regenerated
from the committed manifests and PNGs after integration:

- 94 WPF and 94 Avalonia dialog screenshot surfaces are paired.
- There are no WPF-only or Avalonia-only surface IDs.
- All paired PNGs pass the nonblank gate.
- There are no scale-aware or expected-size mismatches.
- Format Cells Alignment moved below the leading visual outliers, with its
  deterministic triage score reduced from 0.090 to 0.087. This score is a
  review-prioritization metric, not a visual-parity acceptance threshold.

## Focused verification

- FreeX shared services tests: 5/5 passed.
- FreeX Avalonia capture test: 1/1 passed.
- FreeW Page Setup planner tests: 10/10 passed.
- FreeW Avalonia Page Setup tests: 35/35 passed.
- FreeW WPF Page Setup tests: 4/4 passed.
- FreeP shared presentation/math tests: 275/275 passed.
- FreeP Avalonia math baseline tests: 44/44 passed.
- FreeP WPF math baseline tests: 43/43 passed.

Repository preflight, the full Release build, and the default test solution are
run serially from the integration branch before promotion.

## Remaining parity work

Generated command and dialog route coverage remains complete for the current
inventories. Remaining work is fidelity and workflow depth: additional
WPF-authoritative dialog and whole-window visual alignment, physical Linux
interaction coverage, real Word and PowerPoint baselines on capable hosts,
broader SmartArt and OMML families, and hardware-backed media workflows.
