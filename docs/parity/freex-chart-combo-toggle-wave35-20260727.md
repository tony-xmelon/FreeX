# FreeX Chart Combo Toggle Parity, Wave 35

## Scope

This slice closes the ribbon Combo Chart workflow where Avalonia did not follow the
implemented WPF command route. It changes only the FreeX Avalonia ribbon mapping and
its focused source/runtime tests.

## WPF authority

`src/FreeX.App.Host/MainWindow.ChartCommands.cs`, `ChartComboBtn_Click`, calls
`ExecuteChartQuickCommand(ChartQuickCommandCatalog.ComboToggle)`. The mutation is
planned by the shared `ChartQuickCommandPlanner` and applied by the shared
`SetChartLayoutCommand`; no WPF-only behavior was invented or weakened.

## Before and after

Before, Avalonia mapped `chartDesign.comboChart` to `ShowChartComboDialog`. That
full per-series dialog has a support gate and could report an unsupported workflow,
including for a loaded combo chart whose source no longer exposed enough series.

After, the ribbon command maps to `CycleChartCombo`, which invokes the same shared
`ComboToggle` planner path as WPF. Existing combo charts can therefore be toggled off
through the ribbon even when the dialog route cannot be reopened. The existing full
`ShowChartComboDialog` remains available for its separate per-series route and parity
capture; it was not removed.

## Evidence

- Avalonia runtime and source tests: 3 passed, 0 failed.
- WPF authority source test: 1 passed, 0 failed.
- Shared chart planner combo tests: 5 passed, 0 failed.
- Linux Docker evidence was not run in this bounded slice; the Avalonia headless test
  dispatches the production ribbon command and verifies the model mutation, including
  the loaded one-series combo edge case.

## Residuals

Other chart format and workflow guards remain intentionally unchanged. The full
Avalonia combo dialog remains a separate route and is not claimed to be equivalent to
the WPF immediate button. This note does not claim overall Avalonia/WPF parity.
