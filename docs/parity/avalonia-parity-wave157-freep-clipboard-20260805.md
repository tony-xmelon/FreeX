# Avalonia FreeP Inline Table Clipboard Wave 157

## Closed

- Added one renderer-level clipboard bridge on `AvaloniaInCanvasTextEditor` for the active rich
  shape or table-cell editor. It delegates to the existing `AvaloniaRichTextEditor` clipboard
  payload and edit-buffer transaction, so cut/copy/paste do not introduce a second host model.
- Routed Avalonia `MainWindow` ribbon clipboard commands and global keyboard fallbacks through
  that bridge whenever rich in-canvas editing is active. When no rich editor is active, the
  existing serialized `AvaloniaPresentationClipboardService` shape/slide path remains the
  fallback.
- The child editor's existing keyboard handler continues to own Ctrl+C/Ctrl+X/Ctrl+V, matching
  WPF `InCanvasTableCellEditor`'s `PreviewKeyDown` plus `WpfRichTextClipboardAdapter` behavior.
- Rich selection payloads continue to use `InCanvasRichClipboardPlanner` and the existing local
  edit transaction. Structural commands still commit the child editor through the shared
  planner before changing the table, preserving cancel and undo boundaries.

## Evidence

- `FreeP.App.Rendering.Avalonia.Tests`: `SlideCanvasAvaloniaTests.TableCellTextEditor_UsesAvaloniaAdapterForSharedPlannerDecisions` passed `1/1`.
- `FreeP.App.Avalonia.Tests`: live ribbon route test
  `MainWindowHeadlessTests.Ribbon_clipboard_routes_to_active_inline_cell_editor_before_shape_fallback`
  passed `1/1`; with an internal shape clipboard present, active-cell Paste/Cut did not paste or
  delete slide shapes.
- `FreeP.App.Avalonia.Tests` ribbon clipboard filter passed `3/3`.
- `FreeP.App.Rendering.Avalonia.Tests` `AvaloniaRichTextEditorTests` passed `38/38`, including
  custom payload precedence, external-format fallback, table projection, modeled run-effect
  preservation, and the rich-input clipboard context menu.
- `FreeP.App.Presentation.Tests` `InCanvasRichClipboardTests` passed `7/7`.
- WPF authority `FreeP.App.Host.Tests` `WpfRichTextClipboardAdapterTests` passed `15/15`.
- `git diff --check`: passed.

## Remaining

- The headless Avalonia platform does not expose a system clipboard, so the host route test proves
  target selection and shape-fallback suppression rather than a real OS clipboard round trip.
  Desktop Linux/Windows still use `TopLevel.GetTopLevel(...).Clipboard` at runtime.
- Avalonia's inline editor publishes the FreeP rich payload and plain text. It does not yet emit
  WPF-native RTF/XamlPackage formats on copy; external paste formats are already accepted.
- The broader FreeP inline-editor parity surface still has remaining formatting, object, and
  table-command depth beyond this bounded clipboard cut.
