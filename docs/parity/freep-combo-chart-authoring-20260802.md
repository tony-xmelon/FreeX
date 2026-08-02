# Combo Chart Authoring

FreeP already supported imported column-plus-line combo charts: the model retains per-series line overrides and secondary-axis placement, and both renderers/package paths consume them. This slice makes the workflow directly authorable from Insert Chart.

The new command creates one undoable chart with the first sample series as columns and the second as a line with markers on the secondary value axis. It uses the existing chart writer and shared renderer paths, so save/reopen and host behavior remain aligned with imported combo charts.
