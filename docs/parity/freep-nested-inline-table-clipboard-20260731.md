# FreeP nested inline-table clipboard parity

## Scope

This slice closes nested tables carried by the supported XamlPackage/FlowDocument rich-text
path. A nested table is represented as one `U+FFFC` object-replacement run owned by the
containing paragraph or cell body, so surrounding text offsets remain stable.

## Behavior

- The shared model, clone/equality logic, and rich clipboard codec preserve recursive table
  rows, cells, column widths, spans, basic fills/borders/insets, and nested cell bodies.
- XamlPackage import recognizes only the current table's direct rows/cells, preventing nested
  tables from being duplicated as top-level blocks.
- WPF presents a bounded editable Grid. Unchanged cell text retains its cloned nested body;
  changing a cell's plain text uses the existing bounded text-editor path.
- Avalonia uses the same run/model contract and draws the table inline with measured height.
- Slide-level fallback strips the replacement marker and continues to use the existing table or
  text fallback semantics.

## Verification

- Presentation focused clipboard/visual planner tests: `60/60`.
- WPF Rendering build: `0 warnings, 0 errors`.
- WPF Host Release build: `0 warnings, 0 errors`.
- WPF rich-editor STA tests: `55/55`.
- Avalonia Rendering Release build: `0 warnings, 0 errors`.
- Avalonia rich-editor/RTL tests: `30/30`.

## Boundary

This does not claim full nested-table parity for external RTF. The existing RTF reader still
normalizes nested table destinations into the bounded slide-table path; preserving true inline
RTF nesting requires a separate parser/model integration slice.
