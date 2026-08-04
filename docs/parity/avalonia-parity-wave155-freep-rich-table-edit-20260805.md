# Avalonia FreeP Rich Table-Cell Edit Wave 155

## Closed

- Nested Avalonia inline table-cell editors now consume the shared `TableCellEditPlanner` rich-run metadata and select the full cell body on activation, matching the WPF rich edit starting state.
- `Ctrl+B`, `Ctrl+I`, `Ctrl+U`, and superscript/subscript shortcuts now apply to the nested cell editor through the same rich-text buffer used by the parent editor.
- Escape now follows the shared table-cell keyboard plan and discards the child transaction without mutating the parent body. Tab still commits the child body before navigation.
- The parent `TextBody` round-trip retains edited run formatting and cell model/package payloads because the child writes back through the cloned `InCanvasRichTextEditBuffer` only on commit.

## Remaining

- Avalonia inline table cells still do not expose the full WPF cell command surface for row/column insertion, merging, splitting, or cell-level paragraph controls.
- Inline-cell edits remain part of the parent rich-text transaction; they do not create an independent command-bus undo step until the enclosing shape edit commits.
