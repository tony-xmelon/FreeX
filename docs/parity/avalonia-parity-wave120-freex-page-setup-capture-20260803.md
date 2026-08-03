# Avalonia/WPF Parity Wave 120: FreeX Page Setup Capture

Date: 2026-08-03

## Scope

This slice completed the fresh same-source WPF and Linux Docker evidence that was
still outstanding after Wave 119 added separate Page Setup margin fields.

## Unblock

The Avalonia visual-capture path was also running the dialog keyboard interaction
contract before closing a captured modal dialog. Page Setup's multi-tab contract
could therefore keep the focused Docker capture open until the external timeout.
Visual capture and interaction validation are separate lanes: visual capture now
renders and closes the dialog, while `interactionOnly: true` continues to run the
full focus, tab-cycle, range-selection, default, cancel, and Escape contract.

A direct headless regression captures all five Page Setup images and verifies that
visual capture does not populate an interaction contract.

## Visual Alignment

The fresh pair exposed stale Avalonia Margins-tab labels and geometry. Avalonia now
reuses the WPF `PageSetup_Header` and `PageSetup_Footer` localization keys, the
WPF 120-DIP label column and 10-DIP content margin, and the WPF checkbox placement.
The redundant `Center on page` heading was removed.

## Evidence

- WPF: current `FreeX.App.Host --parity-capture-target dialog.PageSetup` route.
- Avalonia: current self-contained Linux x64 app in Ubuntu 24.04 Docker/Xvfb.
- Both sides emitted the default, Page, Margins, Header/Footer, and Sheet surfaces.
- Every frame is nonblank and `600x560` pixels at 96 DPI.
- Focused parity-comparer mean-pixel differences range from `2.6155%` to `3.9686%`.
- Generated triage scores range from `0.040` to `0.066`.

The focused comparer reports its expected nonzero process result because a five-
surface input intentionally omits the Name Box contract surface; all five requested
Page Setup surfaces paired successfully and produced no hard regression.

## Verification

- `CaptureParitySurfaces_CapturesPageSetupTabsWithoutRunningInteractionContract`: passed.
- `AvaloniaPageSetupDialogParitySourceTests`: passed.
- `PageSetup_AllTabsCycleForwardAndReverse_AndEscapeCloses`: passed.
- Linux Docker capture: 5/5 surfaces plus manifest in 19 seconds.
- Dialog visual evidence generation: 94 WPF, 94 Avalonia, 94 paired, 0 missing,
  0 nonblank failures, and 0 expected-size mismatches.
