# Excel Dialog Parity Design

Generated: 2026-05-19

## Goal

Bring FreeX closer to Excel for Windows dialog parity by replacing prompt-based local workbook workflows with real WPF dialogs and reusable picker components, while explicitly tracking the larger chart, pivot, and object formatting pane work as a second wave.

## Scope

Wave 1 covers local workbook-editing dialogs where FreeX already has command/model support but still uses `PromptForInput` or simplified text fields:

- Color picker for font color, fill color, sheet tab color, drawing object fill/outline, workbook theme slots, and dialog color fields.
- Border selector/picker for Format Cells and ribbon border workflows.
- Sort dialog and AutoFilter dropdown dialog.
- Go To, Go To Special, Insert Cells, and Delete Cells dialogs.
- Text to Columns, Remove Duplicates, Subtotal, Advanced Filter, Consolidate, and Data Table dialogs.
- Scenario Manager dialog.
- Protect Sheet, Protect Workbook, and Allow Edit Ranges dialogs.
- Data Validation range-picker polish where it can be added without building a new live worksheet selection architecture.

Wave 2 remains explicitly tracked but is not implemented in Wave 1:

- Chart format/edit dialogs or panes: Select Data, Edit Series, Axis Labels, chart elements, chart styles, chart filters, and richer layout/design editing.
- PivotTable Options and richer PivotChart tooling.
- Shape, picture, text box, and object format dialogs or panes.
- Slicer/timeline style and floating-object UI polish.
- Deeper theme/style galleries and named style modification.

Excluded from both waves unless product scope changes:

- Microsoft 365 cloud sharing, coauthoring, presence, templates, and account/service dialogs.
- VBA, Office Scripts, COM add-ins, Power Query, Power Pivot, OLAP, linked data types, IRM, and sensitivity labels.

## Current State

FreeX already has real dialogs for several core flows:

- `FormatCellsDialog.xaml` covers Number, Alignment, Font, Fill, Border, and Protection.
- `DataValidationDialog.xaml` covers validation type, operator, formulas, input message, and error alert state.
- `PageSetupDialog.xaml` covers Page, Margins, and Sheet tabs.
- `FindReplaceDialog.xaml` covers Find and Replace.
- `NamedRangeDialog.xaml`, `CreateNamesFromSelectionDialog.cs`, `GoalSeekDialog.xaml`, `CustomViewsDialog.xaml`, `HeaderFooterDialog.xaml`, `OptionsDialog.xaml`, `WorkbookThemeDialog.xaml`, `ConditionalFormatDialog.cs`, `ManageConditionalFormatsDialog.cs`, and pivot filter/value dialogs already exist.

The largest parity gap is not missing command logic. It is the UX layer still routing many commands through simple string prompts in `MainWindow.xaml.cs`, especially colors, sort/filter, insert/delete cells, Go To, data tools, scenario workflows, and protection.

## Architecture

Wave 1 should add small WPF dialogs with result objects and parser helpers in `FreeX.App.Host`. The dialogs should be thin: gather user choices, validate inputs, expose typed result data, and let existing command handlers execute the current command classes. Core workbook semantics stay in `FreeX.Core.Commands` and `FreeX.Core.Model`.

Shared components should come first:

- A reusable color palette dialog returns `CellColor?` and supports theme-like default swatches, standard colors, custom hex input, and optional clear/no-color.
- A border picker helper converts chosen edge/style/color selections into `StyleDiff` and `CellBorder` values.
- A range input helper validates `GridRange` and `CellAddress` text consistently for dialogs that need worksheet references.
- A checklist option model supports AutoFilter, Remove Duplicates, and similar selector dialogs without duplicating list state behavior.

## UX Principles

- Dialogs should look quiet and Excel-like, using compact WPF controls and the existing FreeX visual language.
- Avoid replacing a single prompt with a giant all-purpose wizard unless Excel uses a wizard, as with Text to Columns.
- Preserve keyboard-friendly OK/Cancel behavior, default buttons, and validation messages.
- Keep results typed. Do not pass raw user strings from dialogs into command handlers when a parsed model can be returned.
- Where Excel has live range-picker collapse behavior, Wave 1 may use a stable range text box plus current-selection button. True live modal collapse/worksheet selection can be layered later if needed.

## Testing

Every implementation task should use TDD:

- Add dialog XAML structure tests for required controls.
- Add STA tests for result mapping where practical.
- Add parser/planner tests for dialog result objects.
- Add handler/source hygiene tests to prove prompt-based workflows were routed through dialogs.
- Run targeted `dotnet test` commands for the touched host tests, then a broader host test run.

## Integration

Use the existing `codex/Modals` isolated worktree. Keep unrelated dirty files untouched, especially `docs/PROJECT_STATUS_REPORT_2026-05-19.md`. Use subagents for independent task slices with non-overlapping write scopes, and integrate through this branch only after build/tests pass.
