# FreeP Notes Page List Rendering - 2026-07-03

Scope: bounded FreeP notes-page preview/rendering workflow-depth slice after notes-page preview, slide-size fidelity, paper-size fidelity, and overflow continuation landed. This slice avoids FreeX, FreeW, chart work, comments mutation execution, rich table/text editing, presenter recording/ink work, and generated dashboard edits.

## Starting Point

- `docs/parity/freep-notes-page-preview-workflow-2026-07-02.md` introduced the shared `PresentationNotesPagePreviewPlanner` consumed by WPF and Avalonia.
- `docs/parity/freep-notes-page-slide-size-fidelity-2026-07-03.md` made the notes-page slide thumbnail respect the modeled slide size.
- `docs/parity/freep-notes-page-paper-size-fidelity-2026-07-03.md` made preview/PDF page bounds respect `p:notesSz`.
- Shared notes-page PDF rendering already wrapped long lines and continued overflow onto additional pages, but bulleted and auto-numbered speaker-note paragraphs were flattened into plain lines.

## Improvement

- `PresentationNotesPagePreviewPlanner` now derives preview/PDF note lines from the modeled `TextBody` paragraphs instead of only from flattened note text.
- Character bullets, nested bullet indentation, and auto-number prefixes are preserved in `PresentationNotesPagePreviewPlan.NoteLines`.
- `PresentationNotesPagePdfExporter` consumes the same prefixed `NoteLines`, so WPF and Avalonia notes-page PDF output share the list rendering behavior without host-specific code.
- `PresentationNotesPagePreviewPlan.NotesText` remains plain editable speaker-note text, preserving the existing notes-pane editing workflow.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs` covers bulleted and auto-numbered speaker notes in the shared preview plan and in the portable PDF draw operations.

## Remaining FreeP Notes-Page Gaps

- PowerPoint-authoritative visual baselines still require a machine with `PowerPoint.Application` COM registered.
- Rich speaker-note typography, exact bullet hanging-indent geometry, notes master/header/footer placeholders, native print preview, and PowerPoint-measured PDF fidelity remain outside this slice.
