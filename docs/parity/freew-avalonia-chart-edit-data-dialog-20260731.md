# FreeW Avalonia Chart Edit Data dialog

## Resolved behavior

WPF's Chart Design > Edit Data command reopens the chart-data dialog seeded
from the selected chart, applies a replacement only after OK, and supports Undo.

Avalonia previously handled only synthetic selected-value presets used by tests;
a normal button invocation had no value and did nothing. The empty-context
primary action now routes through an owner-modal shell callback when a chart is
selected. MainWindow passes that exact chart to the existing seedable
InsertChartDialog and applies an accepted result through the existing undoable
ReplaceSelectedChartData command.

The deterministic selected-value presets remain supported. Invalid nonempty
values remain no-ops, and the dialog is not opened without a selected chart.

## Verification

- FreeW.App.Avalonia Release build: 0 warnings, 0 errors.
- ChartSmartArtContextualTabTests: 30/30 passed.
- ChartMediaDialogPlannerTests: 6/6 passed.
- Tests cover selected-chart seed ownership, accepted replacement, Undo,
  cancellation/no mutation, and preservation of seeded kind, title, series,
  categories, and values.

No Word COM export is required for this command/dialog/model behavior slice.
