# FreeW shared undoable table formulas

Date: 2026-08-04

## Result

Table Layout > Formula now inserts through one shared `InsertTableCellFormulaCommand` in WPF and Avalonia.

The command addresses the exact model table, row, cell, paragraph, and character offset. Its first application computes the formula and cached result from the target table, then snapshots and splits the paragraph runs at the caret. Undo restores the original run objects exactly; Redo reuses the same formula run so the expression, number format, cached result, sibling text, and insertion position remain stable.

WPF previously inserted a tagged field only into the live `FlowDocument`, then committed that surface without adding a model command-history entry. It now uses the same caret-to-model coordinate mapper already proven for table-cell notes and routes the mutation through `DocumentCommandBus`. Avalonia's existing undoable local paragraph rebuild was replaced with the shared command.

## Evidence

- Shared command: 2/2 focused tests passed.
- WPF editor: 5/5 `TableFormulaEditorTests` passed, including one-step Undo/Redo with bold sibling text around a formatted `=SUM(ABOVE)` field.
- Avalonia paired host: 1/1 focused table-formula command test passed with Undo/Redo and exact formula-run identity on Redo.

The accepted case inserts `=SUM(ABOVE)` with number format `#,##0.00` between `before ` and `after`, caches `30.00`, restores `before after` on Undo, and restores the same field object and cached result on Redo.

## Process rule

Host editors should map caret coordinates before committing the live surface, then execute one model command and restore the caret after the command-triggered render. A rendered field that merely round-trips on save is not functionally complete until Undo and Redo preserve its structured payload and exact insertion position.
