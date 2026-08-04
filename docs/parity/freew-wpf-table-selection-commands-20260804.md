# FreeW WPF table selection commands

## Scope

The WPF Table Layout commands `Select Table`, `Select Row`, `Select Column`, and `Select Cell` were registered in the ribbon but only focused the editor. They did not change the live selection.

The commands now resolve the rendered table cell at the caret and select the requested cell range through WPF's native `TextSelection`. Table and row commands use the first and last rendered cells, the cell command selects that cell's complete block range, and the column command resolves the logical grid column across row-specific cell spans. Repeated pagination header rows are excluded from the selectable model range.

Selection remains view-only: it does not mutate the document or add an undo entry. Existing editing and formatting commands continue to consume the native WPF selection.

## Functional evidence

- Direct selection contracts cover a 2x3 table and prove table, row, rectangular column, and cell selection boundaries: 4/4.
- The four production ribbon command IDs execute the same native selection route and preserve the expected included/excluded cells: 4/4.
- The table-selection test also proves that selecting the table leaves all six model cell values unchanged.
- The existing WPF oracle already proves native cross-cell deletion, typing, and multiline replacement preserve table structure.

## Process rule

Command registration is not behavior parity. For selection commands, execute the production command against a live rendered document, assert both included and excluded content, and keep selection state separate from document mutation and undo history.
