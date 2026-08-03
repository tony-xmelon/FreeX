# Avalonia parity Wave 122 integration

Date: 2026-08-03

## Accepted slices

- FreeX: aligned the Evaluate Formula dialog around shared WPF/Avalonia
  layout metrics and a shared D6 / `SUM(D2:D5)` / 469 capture fixture.
  Fresh paired evidence is 600x360 at 96 DPI, with a targeted changed-pixel
  result of 1.7639% and a canonical deterministic triage score of 0.025.
- FreeW: recaptured all four Legal Notices tabs on Windows and Linux. The
  structure, wrapping, tabs, viewport, scrollbar, focus border, and Close
  button are already aligned. Two attempted typography/geometry changes
  worsened most states and were reverted; only the evidence note was retained.
  The remaining delta is native WPF ClearType versus Avalonia/Skia text
  rasterization, not an unresolved structural layout defect.
- FreeP: carried OMML document-level `m:defJc` through the shared model,
  package reader, parser, layout, and compositor. Omitted or val-less
  justification resolves to `CenterGroup`, while local `m:jc` overrides the
  inherited document default. Shared, WPF, and Avalonia tests cover the same
  behavior.

## Generated evidence

The canonical dialog visual summary and cross-app dashboard were regenerated
after integration:

- 94 WPF and 94 Avalonia FreeX dialog screenshot surfaces are paired.
- There are no WPF-only or Avalonia-only surface IDs.
- All paired PNGs pass the nonblank gate.
- There are no scale-aware logical-size or expected-size mismatches.
- There are no unresolved high-delta candidates at the 0.4 triage threshold.
- `dialog.EvaluateFormula` now has matching 600x360, 96-DPI evidence and a
  deterministic triage score of 0.025.

These inventory and triage results establish coverage and comparable evidence;
they are not a claim that every pixel is identical across native renderers.

## Focused verification

- FreeX Evaluate Formula services/host/Avalonia tests: 13/13 passed.
- FreeX WPF and Avalonia Release builds: passed with 0 warnings and 0 errors.
- FreeW Legal Notices Avalonia tests: 12/12 passed.
- FreeW Legal Notices WPF tests: 9/9 passed.
- FreeW Linux route captures: 4/4 completed and nonblank.
- FreeP shared presentation/math tests: 292/292 passed.
- FreeP WPF OMML tests: 2/2 passed.
- FreeP Avalonia OMML tests: 2/2 passed.

## Integration gates

- Repository preflight: passed.
- Full `Release` solution build: passed with 0 warnings and 0 errors.
- Default test solution: 36,224 tests represented; 36,089 passed, 134 skipped,
  and one OS-clipboard test failed during the parallel all-up run.
- The exact failing clipboard test passed 1/1 in a fresh isolated host. This is
  shared OS clipboard-state contention, not a product failure in Wave 122.

## Remaining parity work

Generated command and FreeX dialog route coverage remains complete for current
inventories. Remaining work is fidelity and workflow depth: additional
WPF-authoritative whole-window and dialog alignment, broader physical Linux
interaction coverage, real Word and PowerPoint baselines on capable hosts,
additional SmartArt and OMML families, and hardware-backed media workflows.
