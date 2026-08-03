# FreeW WPF Undoable Chart Data And Size

Date: 2026-08-04

## Scope

WPF chart size and Edit Data operations mutated the selected chart directly, while Avalonia already
used the shared command bus.

WPF now uses `SetFloatingSizeCommand` for chart dimensions and `ReplaceChartDataCommand` for editable
chart data. The shared data command is constrained to data-owned fields: kind, titles, legend, positive
replacement dimensions, categories, and series. It preserves chart placement, rotation, flips, style,
color scheme, quick layout, and imported visual metadata.

This matches Word's Edit Data ownership: changing workbook-like data does not reset object formatting
or arrangement. Both WPF operations now support undo and redo.

## Verification

- Core `ChartEditCommandTests`: 9/9 passed, including editable data apply/undo/redo and formatting
  stability.
- Focused WPF `FreeWRibbonParityTests`: 2/2 passed for size and data apply/undo/redo.
- Focused Avalonia `ChartSmartArtContextualTabTests`: 2/2 passed as the shared-command host control.

No Word COM visual baseline is required because rendering and serialization paths are unchanged.
