# FreeP Chart Bubble Transition Seeding - 2026-08-01

The chart data dialog now seeds every missing required Scatter/Bubble coordinate when changing chart type. A partially populated Bubble size matrix no longer leaves null size cells after a Scatter-to-Bubble transition; authored existing values remain unchanged.

Verification: `ChartDataDialogPlannerTests` passed with the partial-size transition regression covered.
