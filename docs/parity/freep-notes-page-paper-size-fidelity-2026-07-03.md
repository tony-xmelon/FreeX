# FreeP Notes Page Paper Size Fidelity - 2026-07-03

Scope: bounded FreeP notes-page preview/rendering workflow-depth slice after notes-page preview and slide-size fidelity landed. This slice avoids FreeX, FreeW, chart work, comments mutation execution, rich table/text editing, and presenter recording/ink work.

## Starting Point

- `docs/parity/freep-notes-page-preview-workflow-2026-07-02.md` introduced the shared `PresentationNotesPagePreviewPlanner` and WPF/Avalonia host evidence.
- `docs/parity/freep-notes-page-slide-size-fidelity-2026-07-03.md` made the notes-page slide thumbnail respect `p:sldSz`.
- The model still ignored `presentation.xml` `p:notesSz`, the writer always emitted a fixed notes-page size, and shared preview/PDF rendering defaulted to fixed print-page dimensions instead of the deck's modeled notes-page canvas.

## Improvement

- `Presentation` now models `NotesPageSizeCxEmu` and `NotesPageSizeCyEmu` with PowerPoint-compatible defaults.
- `PptxPackageReader` reads `p:notesSz`, and `PptxPackageWriter` writes the modeled notes-page size back to `presentation.xml`.
- `PresentationNotesPagePreviewPlanner` resolves notes-page bounds from the modeled notes-page size unless a caller explicitly overrides page dimensions.
- `PresentationNotesPagePdfExporter` uses the same modeled notes-page bounds, so WPF and Avalonia notes-page PDF plans share the imported/custom page size.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs` covers modeled notes-page preview/PDF dimensions and `p:notesSz` PPTX roundtrip.
- `freep/FreeP.App.Host.Tests/NotesSlideTests.cs` covers WPF host notes-pane preview refresh with custom notes-page bounds.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers Avalonia host notes-pane preview refresh with the same custom notes-page bounds.

## Remaining FreeP Workflow-Depth Gaps

- PowerPoint-authoritative visual baselines still require a machine with `PowerPoint.Application` COM registered.
- Rich inline table/text editing, modern comments/review mutation, reading-order workflow execution, full proofing/accessibility execution, presenter recording/ink execution, native print preview, video export, and PowerPoint-measured visual fidelity remain outside this slice.
