# FreeP Rich Table-Cell Editing Shared Visual Contract - 2026-07-27

## Scope

This is a bounded FreeP table-cell rich-editing slice. It covers the modeled mixed-run and
paragraph-edit behavior that can be proven locally in WPF and Avalonia. It does not claim that
Avalonia has a framework-native `RichTextBox` or that PowerPoint-authoritative rich-editor raster
baselines are available.

## Production behavior

- WPF continues to edit through `RichTextBox` and `FlowDocument` conversion.
- Avalonia uses a native transparent `TextBox` for keyboard focus, text input, IME, clipboard,
  and local text undo, while `AvaloniaRichTextEditingSurface` renders the shared run and
  paragraph model, selection rectangles, caret geometry, and list markers.
- `InCanvasRichTextEditBuffer` applies text replacement against the rich model. It preserves
  run boundaries and run formatting, paragraph metadata, list metadata, soft breaks, and the
  active typing style instead of rebuilding a single plain run.
- Both hosts route table-cell start, navigation, formatting, commit, and cancel through
  `TableCellEditPlanner`; no renderer-specific keyboard or transaction policy was added.
- The Avalonia visual plan now uses `PresentationListMarkerContinuationState`, the same shared
  marker-sequencing contract used by slide composition. Explicit numbering restarts, nested
  levels, and non-numbered boundaries therefore remain visible while the cell is being edited.

## Focused evidence

- Shared visual-plan coverage: `InCanvasRichTextVisualPlannerTests`.
- Shared rich-buffer coverage: `InCanvasRichTextEditBufferTests` and `TableCellEditPlannerTests`.
- WPF mixed-run, paragraph, selection, and caret coverage: `RichTextEditorTests`.
- Avalonia mixed-run, selection/caret, soft-break, keyboard, commit/cancel, and table-cell
  overlay coverage: `AvaloniaRichTextEditorTests` and `SlideCanvasAvaloniaTests`.

## Residual parity gap

Avalonia still has a custom rich editing surface over a native `TextBox`, not a framework-native
rich editing widget equivalent to WPF `RichTextBox`. Rich clipboard formats, the full WPF
`FlowDocument` feature set, broader IME/RTL behavior, advanced inline effects, and
PowerPoint-authoritative list-gallery/rich-editor visual baselines remain unproven.
