# FreeP Table-Cell Rich Editor Fidelity - 2026-07-03

Scope: bounded FreeP table editing workflow-depth slice. This avoids FreeX, FreeW, chart scene work, print/export/backstage, and PowerPoint COM baseline claims.

## Improved

- `TableCellEditPlanner.BeginEdit` now emits renderer-neutral rich editor state for the active table cell: concatenated plain text, run offsets, per-run font family, size, bold, italic, underline, strikethrough, color, suggested editor style, initial-selection style, and mixed-formatting flags.
- Shared planner coverage pins newline-aware multi-paragraph run offsets and the current collapsed-selection policy: collapsed selections use the whole-cell style/format fallback until a renderer-neutral caret-run policy is introduced.
- The Avalonia table-cell overlay consumes that shared plan through `AvaloniaTableCellEditAdapter`, tags the live editor with exact rich run metadata, and projects the suggested style onto the in-canvas editor instead of opening every cell as an unstyled plain-text box.
- Avalonia refreshes the shared rich plan after active table-cell formatting commands while the overlay is open, so subrange formatting state remains visible to adapters/tests even when the platform TextBox cannot display mixed inline formatting.
- WPF evidence remains source-hygiene based: the table-cell editor uses shared `BeginEdit`, a `RichTextBox` backed by `FlowDocument` conversion, and shared `CommitRichText` for command creation.

## Remaining

- Avalonia still does not have a true editable rich-text control equivalent to the WPF `RichTextBox`; mixed inline runs are modeled and adapter-visible, but the TextBox can only project one suggested editor style at a time.
- PowerPoint-authoritative visual baselines for rich table-cell editing were not generated on this machine.

## Evidence

- `TableCellEditPlannerTests.BeginEdit_MixedRichRuns_ReturnsRendererNeutralRichTextPlan`
- `TableCellEditPlannerTests.PlanRichTextEdit_MultiParagraphRuns_OffsetsIncludeNewlineSeparator`
- `TableCellEditPlannerTests.PlanRichTextEdit_SelectionAcrossParagraphBoundary_ReportsMixedSelectionStyle`
- `TableCellEditPlannerTests.PlanRichTextEdit_CollapsedSelection_UsesWholeCellFallbackStyle`
- `TableCellEditPlannerTests.PlanFontFamily_CollapsedSelection_FallsBackToWholeCell`
- `SlideCanvasAvaloniaTests.TableCellTextEditor_OpenMixedRuns_ProjectsSharedRichPlanOntoOverlay`
- `CanvasEditingTests.InCanvasTableCellEditor_ProjectsSharedInitialSelectionPlan`
