# FreeP Table-Cell Rich Editor Fidelity - 2026-07-03

Scope: bounded FreeP table editing workflow-depth slice. This avoids FreeX, FreeW, chart scene work, print/export/backstage, and PowerPoint COM baseline claims.

## Improved

- `TableCellEditPlanner.BeginEdit` now emits renderer-neutral rich editor state for the active table cell: concatenated plain text, run offsets, per-run font family, size, bold, italic, underline, strikethrough, color, suggested editor style, initial-selection style, and mixed-formatting flags.
- Shared planner coverage pins newline-aware multi-paragraph run offsets, caret-run style resolution for collapsed selections, selected run ranges, and selected paragraph/list metadata.
- The Avalonia table-cell overlay consumes that shared plan through `AvaloniaTableCellEditAdapter`, tags the live editor with exact rich run metadata, and projects the suggested style onto the in-canvas editor instead of opening every cell as an unstyled plain-text box.
- Avalonia refreshes the shared rich plan after active table-cell formatting commands while the overlay is open, so subrange formatting state remains visible to adapters/tests even when the platform TextBox cannot display mixed inline formatting.
- `InCanvasTableCellRichTextEditPlan` now carries paragraph/list metadata for all paragraphs plus the effective selected paragraphs: offsets, text, alignment, bullet kind/char, auto-number type/start, suppressed state, level, margin, indent, mixed-paragraph flag, and list-format flag.
- Avalonia refreshes that paragraph/list plan after selected table-cell list preset commands, keeping Roman/alpha/bullet result state visible through the same shared adapter evidence while the plain TextBox remains the editing widget.
- WPF evidence remains source-hygiene based: the table-cell editor uses shared `BeginEdit`, a `RichTextBox` backed by `FlowDocument` conversion, and shared `CommitRichText` for command creation.

## Remaining

- Avalonia still does not have a framework-native rich-text control equivalent to the WPF `RichTextBox`. The production overlay now renders mixed inline runs, selected paragraph/list state, list markers, selection rectangles, and caret geometry through the shared rich visual plan while the native TextBox owns keyboard/text input. Rich clipboard formats, broader `FlowDocument`/IME/RTL behavior, advanced inline effects, and PowerPoint-authoritative rich-editor visual baselines remain unproven.
- PowerPoint-authoritative visual baselines for rich table-cell editing were not generated on this machine.

## Evidence

- `TableCellEditPlannerTests.BeginEdit_MixedRichRuns_ReturnsRendererNeutralRichTextPlan`
- `TableCellEditPlannerTests.PlanRichTextEdit_MultiParagraphRuns_OffsetsIncludeNewlineSeparator`
- `TableCellEditPlannerTests.PlanRichTextEdit_SelectionAcrossParagraphBoundary_ReportsMixedSelectionStyle`
- `TableCellEditPlannerTests.PlanRichTextEdit_CollapsedSelection_UsesCaretRunStyle`
- `TableCellEditPlannerTests.PlanRichTextEdit_SelectionReportsParagraphAndListMetadata`
- `TableCellEditPlannerTests.PlanParagraphListPreset_RomanUpperSelection_BuildsUndoableSharedCommand`
- `SlideCanvasAvaloniaTests.TableCellTextEditor_OpenMixedRuns_ProjectsSharedRichPlanOntoOverlay`
- `SlideCanvasAvaloniaTests.TableCellTextEditor_ListPresetSelection_RefreshesSharedParagraphPlan`
- `CanvasEditingTests.InCanvasTableCellEditor_ProjectsSharedInitialSelectionPlan`
