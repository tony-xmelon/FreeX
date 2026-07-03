# FreeP Notes Page Rich Run Rendering - 2026-07-03

Scope: bounded FreeP notes-page preview/rendering workflow-depth slice after notes-page preview, page sizing, placeholder metadata, list prefixes, and overflow continuation landed. This avoids FreeX, FreeW, comments/review mutation execution, rich table editing, presenter recording/ink execution, and generated cross-app dashboard edits.

## Starting Point

- `PresentationNotesPagePreviewPlanner` already exposed plain editable speaker-note text plus wrapped `NoteLines` for WPF and Avalonia notes-page preview/PDF routes.
- `PresentationNotesPagePdfExporter` consumed those shared lines, but emitted each rendered speaker-note line as one regular black PDF text operation.
- Bold/color run information inside speaker notes was therefore flattened even though the model retained it.

## Improvement

- `PresentationNotesPagePreviewPlan` now carries `StyledNoteLines` beside the existing plain `NoteLines`, preserving per-run bold, italic metadata, and resolved sRGB color while keeping current callers compatible.
- `PresentationNotesPagePdfExporter` renders each styled speaker-note run as its own `PdfText` operation, including bold face selection and run color.
- Existing plain note text, list prefixes, wrapping, placeholder handling, and overflow continuation behavior remain shared and host-neutral for WPF and Avalonia.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs` covers rich speaker-note runs in the shared preview plan and the generated portable PDF operations.

## Remaining FreeP Notes-Page Gaps

- The portable PDF layer currently exposes regular and bold Helvetica faces only, so italic metadata is carried in the shared plan but not yet rendered as an italic PDF face.
- PowerPoint-authoritative visual baselines still require a machine with `PowerPoint.Application` COM registered.
- Exact font-family metrics, theme re-resolution for notes-page run colors, precise bullet hanging-indent geometry, notes master styling, native print preview, and PowerPoint-measured PDF fidelity remain outside this slice.
