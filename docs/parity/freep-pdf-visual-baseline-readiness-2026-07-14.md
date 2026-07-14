# FreeP PDF Visual Baseline Readiness Evidence

Date: 2026-07-14

## Scope

This slice advances the broader PowerPoint-authoritative PDF visual-baseline lane without requiring local PowerPoint COM:

- `PresentationPdfVisualBaselineReadinessPlanner` emits one host-neutral readiness contract for portable slide PDF, full-page raster PDF, 3-up handout PDF, and notes-page PDF output.
- Each row records the shared planner, shared route, PDF content type, page count, slide range summary, and a stable manifest fingerprint.
- Each row now records source-normalized manifest, WPF PDF, Avalonia PDF, PowerPoint PDF, and PowerPoint slide-PNG artifact paths. This gives a later COM-capable baseline host a deterministic capture layout without changing local no-COM behavior.
- WPF and Avalonia receive identical manifest fingerprints for every row, proving they share the same PDF/export package contract before any host captures a baseline.
- Every row marks PowerPoint PDF/PNG baselines as `n/a/deferred-powerpoint-com-pdf-and-png-baseline`; local readiness does not claim Microsoft PowerPoint visual parity.

## Evidence

Focused regression coverage:

- `freep/FreeP.App.Presentation/PresentationPdfVisualBaselineReadinessPlanner.cs`
  - Shared rows for `PortableSlidePdf`, `FullPageSlidesRasterPdf`, `HandoutPdf`, and `NotesPagePdf`.
  - `RequiresPowerPointComForLocalEvidence == false`.
  - `RequiresPowerPointComForAuthoritativeBaseline == true`.
  - Source names are normalized into artifact stems, for example `Quarter Review.pptx` -> `Quarter-Review`, so `manifest/{sourceStem}/{evidenceId}.json`, `wpf-pdf/{sourceStem}/{evidenceId}.pdf`, `avalonia-pdf/{sourceStem}/{evidenceId}.pdf`, `powerpoint-pdf/{sourceStem}/{evidenceId}.pdf`, and `powerpoint-png/{sourceStem}/{evidenceId}/slide-NN.png` are stable.
- `freep/FreeP.App.Presentation.Tests/PresentationPdfVisualBaselineReadinessPlannerTests.cs`
  - Normal deck coverage pins source-name normalization, source-bound artifact paths, route order, matching WPF/Avalonia fingerprints, full-page page counts, handout pagination, notes-page PDF routing, and deferred PowerPoint baselines.
  - Empty-deck coverage keeps the portable placeholder page explicit while package-backed rows correctly report no slides.
- `tools/Generate-FreePCommandParityInventory.ps1`
  - Adds `freep.export.pdf-visual-baseline-readiness` as a generated workflow-evidence row, separating no-COM readiness from still-deferred PowerPoint visual parity.

## Remaining Work

Authoritative PowerPoint PDF and PNG baseline capture still requires a COM-capable host with `PowerPoint.Application` registered. The next PDF/export fidelity work is to run the readiness manifest against representative real decks on that host, save PowerPoint-exported PDFs/PNGs beside WPF/Avalonia outputs, and add actual visual diffs for slide PDF, handout PDF, notes-page PDF, transparency/effects, gradients, clipping, picture rendering, and text metrics.
