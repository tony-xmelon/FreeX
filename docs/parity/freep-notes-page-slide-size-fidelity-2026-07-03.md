# FreeP Notes Page Slide Size Fidelity - 2026-07-03

Scope: bounded FreeP notes-page preview/rendering workflow-depth slice after command-surface parity. This slice avoids FreeX, FreeW, chart data-table text styling, table-cell editing, comments mutation execution, and presenter recording/ink work.

## Starting Point

- `docs/parity/avalonia-wpf-cross-app-dashboard.json` reports FreeP command-surface parity as green and keeps notes-page preview/rendering in the workflow-depth backlog.
- `docs/parity/freep-notes-page-preview-workflow-2026-07-02.md` introduced the shared `PresentationNotesPagePreviewPlanner`.
- Notes-page PDF rendering now flows through `PresentationNotesPagePdfExporter`, but the preview thumbnail box and the portable slide page renderer still assumed the default 16:9 slide size.

## Improvement

- `PresentationNotesPagePreviewPlanner` now fits the notes-page slide thumbnail using `Presentation.SlideSizeCxEmu` and `Presentation.SlideSizeCyEmu`, so 4:3 and custom-size decks do not render as 16:9 inside the notes page.
- `PresentationPdfExporter.BuildDocument` now renders slide PDF pages at the modeled presentation size, while preserving the existing default-size `BuildSlidePage(Slide)` overload for callers that intentionally render a standalone 16:9 slide.
- `PresentationNotesPagePdfExporter` now maps the slide thumbnail from the modeled-size slide page, so WPF and Avalonia notes-page exports share the same slide-size-aware geometry through the common presentation layer.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs` covers 4:3 notes-page preview thumbnail geometry.
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs` covers custom-size portable PDF page dimensions and shape geometry.

## Remaining FreeP Workflow-Depth Gaps

- PowerPoint-authoritative visual baselines still require a machine with `PowerPoint.Application` COM registered.
- Rich inline table/text editing, modern comments/review mutation, reading-order workflow execution, full proofing/accessibility execution, presenter recording/ink execution, native print preview, video export, and PowerPoint-measured visual fidelity remain outside this slice.
