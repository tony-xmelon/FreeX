# FreeP Chart Data Labels Over Maximum - 2026-07-28

`ChartShape.ShowDataLabelsOverMaximum` already had model, undo, dialog, and PPTX
reader/writer support, but the shared chart planner ignored it. The planner now
marks labels whose value exceeds the effective value-axis maximum and, when the
authored option is explicitly `false`, omits those labels from column, bar, line/area,
and scatter scene plans. Omitted and explicit `true` values retain the prior visible
label behavior. Pie/doughnut labels do not use a value axis and are unchanged.

This follows the PowerPoint/Office chart contract that the option controls whether
data labels remain visible when a value exceeds the maximum value-axis scale. Both
WPF and Avalonia already consume the shared `ChartScenePlan.DataLabels` list.

Focused coverage verifies explicit false filtering and explicit true retention.
