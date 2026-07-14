# FreeP PDF Baseline Diff Readiness Evidence

Date: 2026-07-14

## Scope

This slice extends the no-COM FreeP PDF visual-baseline readiness contract so a later PowerPoint-capable host can place comparable artifacts without changing the WPF/Avalonia export path:

- Every baseline row now names deterministic WPF and Avalonia page-raster artifact patterns beside the existing WPF/Avalonia PDF outputs.
- Every baseline row now names the paired WPF-vs-Avalonia diff report and the deferred PowerPoint-vs-WPF / PowerPoint-vs-Avalonia report paths.
- Every row pins the rasterization DPI and a threshold profile that is explicitly marked for manual calibration on a real PowerPoint baseline host.
- The shared manifest fingerprint includes the raster and diff profile metadata, so WPF and Avalonia stay paired on the same PDF/export baseline contract.

## Evidence

Focused regression coverage:

- `freep/FreeP.App.Presentation/PresentationPdfVisualBaselineReadinessPlanner.cs`
  - Adds `wpf-png/{sourceStem}/{evidenceId}/page-NN.png` and `avalonia-png/{sourceStem}/{evidenceId}/page-NN.png` artifact patterns.
  - Adds `diff/wpf-vs-avalonia/{sourceStem}/{evidenceId}.json`, `diff/powerpoint-vs-wpf/{sourceStem}/{evidenceId}.json`, and `diff/powerpoint-vs-avalonia/{sourceStem}/{evidenceId}.json`.
  - Pins `BaselineRasterizationDpi` at `144` and `DiffThresholdProfile` at `pdf-visual-baseline-readiness-v1/manual-calibration-required`.
- `freep/FreeP.App.Presentation.Tests/PresentationPdfVisualBaselineReadinessPlannerTests.cs`
  - Verifies the portable slide PDF, full-page raster PDF, 3-up handout PDF, and notes-page PDF rows keep matching WPF/Avalonia fingerprints.
  - Verifies the new page PNG and diff report paths are source-normalized and route-specific.
  - Verifies the local readiness rows still require no PowerPoint COM while PowerPoint artifacts and visual diffs remain deferred.

## Remaining Work

This is not an authoritative Microsoft PowerPoint visual baseline. A COM-capable host still needs to export the PowerPoint PDFs/PNGs, rasterize WPF/Avalonia PDFs with the pinned contract, calibrate route-specific thresholds on representative decks, and fill the PowerPoint-vs-WPF / PowerPoint-vs-Avalonia diff reports.
