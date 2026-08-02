# FreeP Stock Chart Authoring

## Scope

The stock-chart insertion command now creates a renderable OHLC data set in the
shared editing session. The chart data dialog also normalizes an ordinary chart
to the four editable stock roles when the user changes its type to Stock.

## Behavior

- New stock charts contain `Open`, `High`, `Low`, and `Close` series across three
  sample day categories.
- Existing values are preserved when converting a chart to Stock; missing OHLC
  roles are added as editable columns.
- WPF and Avalonia consume the same `EditingSession` and
  `ChartDataDialogPlanner` behavior.
- Other chart types retain their existing generic sample data and projections.

## Verification

- `ChartDataDialogPlannerTests` and `EditingSession5ATests`: 91/91.
- The inserted sample is accepted by `ChartRenderPlanner.BuildStockPrimitivePlan`
  and produces one high-low stem per category.
