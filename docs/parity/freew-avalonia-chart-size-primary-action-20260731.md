# FreeW Avalonia Chart Size Primary Action

The canonical `freew.chart-size` command now opens the existing seeded Chart Size dialog when it is
executed without a selected value. This matches the WPF route and makes command-palette, keyboard,
and direct command dispatch useful instead of silently doing nothing.

The value-bearing combo route remains supported: values such as `400 x 300` resize the selected chart
directly and remain undoable. `freew.chart-size-dialog` is an alias of the same stateful command, so the
two entry points cannot drift. Both routes are disabled when no chart is selected; invalid nonempty
values and cancelled dialogs leave the model unchanged.

Focused evidence is in `ChartSmartArtContextualTabTests`:

- canonical primary and dialog alias share one command and invoke the owner callback;
- cancellation does not mutate the selected chart;
- no-selection state is disabled and does not open the dialog;
- value-bearing resize remains undoable and does not open the dialog.
