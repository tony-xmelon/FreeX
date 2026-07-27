# FreeP Chart Change Type Command

PowerPoint exposes Change Chart Type as a direct chart-design action. FreeP already had the
underlying chart-data planner and undoable `ReplaceChartDataCommand` transition, including the
Scatter and Bubble coordinate rules, but the ribbon only exposed chart insertion and Edit Data.

This slice adds a shared Change Chart Type dropdown to the chart group in both WPF and Avalonia.
Each modeled `ChartType` has a menu command. Selecting one reuses `ChartDataDialogPlanner` to
preserve the current categories, series, nullable values, and chart-specific coordinates, then
commits one undoable chart mutation. The parent command still opens Edit Data for a dialog-based
workflow.

Focused coverage:

- 64 Presentation chart-data command tests, including direct session transition and undo.
- Shared WPF/Avalonia ribbon definition test covering every chart-type menu item.
- WPF and Avalonia application Release builds.

This is function/package parity. It does not claim that every chart family has identical
PowerPoint rendering; existing chart-family visual baselines remain separate evidence.
