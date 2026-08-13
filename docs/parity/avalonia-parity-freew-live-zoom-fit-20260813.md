# FreeW live zoom-fit parity — 2026-08-13

## Closed gap

The Avalonia Zoom dialog used fixed representative factors for **Page width**, **Text width**, and
**Whole page** even though the WPF host derives those choices from the live viewport and document page
geometry. Avalonia's quick **One Page** and **Page Width** ribbon actions already computed live factors,
so the dialog produced different results from both WPF and its own adjacent commands.

## Shared authority

`ZoomDialogPlanner.BuildFitFactors` now owns the page-relative fit policy. WPF and Avalonia supply only
their measured viewport width and height. Both hosts use the returned `ZoomDialogFitFactors`, and the
Avalonia dialog no longer contains fallback percentages.

## Verification

- `FreeW.App.Presentation.Tests`: live Letter-page geometry and degenerate viewport coverage.
- WPF host: Release compile, zero warnings and errors.
- Avalonia app and test assembly: Release compile, zero warnings and errors.
- No UI tests or capture lanes were run on this machine.
