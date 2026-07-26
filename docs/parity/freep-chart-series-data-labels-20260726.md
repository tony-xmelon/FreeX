# FreeP Chart Per-Series Data Labels

FreeP now exposes PowerPoint-style data-label overrides for the selected chart
series through the existing Series Options workflow.

- WPF and Avalonia share one working-copy planner and one undoable
  `SetChartSeriesOptionsCommand`.
- The workflow can enable or remove a series-scoped `c:dLbls` override and edit
  value, percentage, category, series-name, and legend-key components.
- Position, number format, and separator are carried with the same override.
- Existing chart-level labels remain the fallback when the series override is
  disabled.
- The existing chart reader/writer already owns `c:dLbls` serialization, so the
  edit survives save and reopen without a host-specific package path.

This is functional authoring coverage. Per-point label overrides, complete
PowerPoint label text styling, and PowerPoint-authoritative visual baselines
remain separate work.
