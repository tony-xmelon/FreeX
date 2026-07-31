# FreeP multi-selection transform parity Wave 87

Date: 2026-07-31

## Implemented

WPF multi-selection moves now use the shared canvas drag-start reducer already used by
Avalonia. A sub-threshold pointer movement no longer commits a move or creates an undo
step in WPF, and WPF resize and rotate gestures now use the same start and commit gates.
Capture-loss, Escape cancellation, preview cleanup, and stale-release behavior remain on
the existing host paths.

## Verification

- WPF paired multi-selection transform test: passed.
- Avalonia paired multi-selection transform test: passed.
- Full focused FreeP WPF host tests: 1,861/1,861 passed.
- Full focused FreeP Avalonia rendering tests: 199/199 passed.

## Residuals

Multi-selection resize and rotate handles remain single-selection-only in both hosts; this
wave aligns drag threshold semantics for the existing multi-selection move workflow.
