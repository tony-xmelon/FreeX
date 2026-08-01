# FreeP WPF Nested Inline-Table Tab Navigation - 2026-08-01

## Scope

WPF inline tables are editable `Grid` controls embedded in the rich-text
`FlowDocument`. This slice brings their keyboard workflow in line with the
existing Avalonia editor behavior:

- `Tab` advances through editable cells in row/column order.
- `Shift+Tab` moves backward and is contained at the first cell.
- `Tab` from the final cell appends a new row with the existing column count,
  inherited row height, and empty editable cell bodies, then targets its first
  cell.
- The appended row is included by the existing `FromFlowDocument` model
  extraction and round-trips with the inline table.

The behavior is implemented in the WPF converter that owns the inline-table
editor controls. It does not change the shared table model or regular table
commands.

## Verification

- `WpfInlineTableEditor_TabMovesAcrossCellsAndAppendsMatchingRow`: passed.
- `WpfInlineTableEditor_ShiftTabAtFirstCellStaysInsideTable`: passed.
- Focused WPF inline-table test filter: 4/4 passed.
- Full `FreeP.App.Host.Tests`: 1884/1884 passed.
- `FreeP.App.Host` Release build: 0 warnings, 0 errors.
