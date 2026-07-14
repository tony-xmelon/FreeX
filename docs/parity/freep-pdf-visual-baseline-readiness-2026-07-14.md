# FreeP PDF Visual Baseline Readiness Evidence

Date: 2026-07-14

## Scope

This slice advances the broader PowerPoint-authoritative PDF visual-baseline lane without requiring local PowerPoint COM:

- `PresentationPdfVisualBaselineReadinessPlanner` emits one host-neutral readiness contract for portable slide PDF, full-page raster PDF, 3-up handout PDF, and notes-page PDF output.
- Each row records the shared planner, shared route, PDF content type, page count, slide range summary, and a stable manifest fingerprint.
- WPF and Avalonia receive identical manifest fingerprints for every row, proving they share the same PDF/export package contract before any host captures a baseline.
- Every row marks PowerPoint PDF/PNG baselines as `n/a/deferred-powerpoint-com-pdf-and-png-baseline`; local readiness does not claim Microsoft PowerPoint visual parity.

## Evidence

Focused regression coverage:

- `freep/FreeP.App.Presentation/PresentationPdfVisualBaselineReadinessPlanner.cs`
  - Shared rows for `PortableSlidePdf`, `FullPageSlidesRasterPdf`, `HandoutPdf`, and `NotesPagePdf`.
  - `RequiresPowerPointComForLocalEvidence == false`.
  - `RequiresPowerPointComForAuthoritativeBaseline == true`.
- `freep/FreeP.App.Presentation.Tests/PresentationPdfVisualBaselineReadinessPlannerTests.cs`
  - Normal deck coverage pins source-name normalization, route order, matching WPF/Avalonia fingerprints, full-page page counts, handout pagination, notes-page PDF routing, and deferred PowerPoint baselines.
  - Empty-deck coverage keeps the portable placeholder page explicit while package-backed rows correctly report no slides.

## Remaining Work

Authoritative PowerPoint PDF and PNG baseline capture still requires a COM-capable host with `PowerPoint.Application` registered. The next PDF/export fidelity work is to run the readiness manifest against representative real decks on that host, save PowerPoint-exported PDFs/PNGs beside WPF/Avalonia outputs, and add actual visual diffs for slide PDF, handout PDF, notes-page PDF, transparency/effects, gradients, clipping, picture rendering, and text metrics.
