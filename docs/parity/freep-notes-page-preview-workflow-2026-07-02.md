# FreeP Notes Page Preview Workflow - 2026-07-02

Scope: bounded FreeP notes/preview workflow-depth slice after table picker and slide-pane affordance evidence landed. This avoids FreeW, FreeX, PowerPoint COM baselines, table-cell overlay work, comments mutation execution, and export writer changes.

## Starting Point

- `docs/parity/freep-table-picker-workflow-2026-07-02.md` records the shared table picker workflow as complete.
- `docs/parity/freep-new-slide-pane-affordance-evidence-2026-07-02.md` records the Avalonia bottom `+ New Slide` affordance as complete and keeps notes-page rendering in the remaining workflow-depth list.
- `docs/planning/freep-powerpoint-parity-status-2026-06-27.md` lists notes-page rendering under export/print/backstage depth and already records notes-page print descriptors.
- `docs/parity/avalonia-wpf-cross-app-dashboard.md` is generated; its FreeP next-slice wording needed a refresh because it still pointed at picker and generic slide-pane work that now has dated evidence.

## Improvement

- Added `PresentationNotesPagePreviewPlanner` in `FreeP.App.Presentation` so notes-page preview range, title, extracted speaker-note lines, placeholder text, and slide/notes page geometry are shared.
- WPF and Avalonia refresh `LastNotesPagePreviewPlan` from the existing notes-pane workflow, including programmatic `EditingSession.SetCurrentSlideNotesText` changes and slide changes.
- The generated cross-app dashboard now points FreeP workflow-depth work at notes-page preview/rendering, richer inline editing, modern comments/review, and presenter recording/ink execution instead of already-landed picker work.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationExportPlannerTests.cs` covers current-slide notes-page range, title/text extraction, geometry ordering, and empty-deck behavior.
- `freep/FreeP.App.Host.Tests/NotesSlideTests.cs` covers WPF host consumption of the shared notes-page preview plan.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers Avalonia host consumption of the shared notes-page preview plan.

## Remaining FreeP Workflow-Depth Gaps

- Actual notes-page PDF/print rendering remains a follow-up; this slice creates the shared preview policy and host evidence without changing export writer output.
- PowerPoint-authoritative visual baselines still require a machine with `PowerPoint.Application` COM registered.
- Rich inline table/text editing, modern comments/review mutation, reading-order workflow execution, full proofing/accessibility execution, presenter recording/ink execution, native print preview, video export, and PowerPoint-measured visual fidelity remain outside this slice.
