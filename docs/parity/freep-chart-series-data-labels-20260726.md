# FreeP Chart Per-Series Data Labels

FreeP now exposes PowerPoint-style data-label overrides for the selected chart
series through the existing Series Options workflow.

- WPF and Avalonia share one working-copy planner and one undoable
  `SetChartSeriesOptionsCommand`.
- The workflow can enable or remove a series-scoped `c:dLbls` override and edit
  value, percentage, category, series-name, and legend-key components.
- Position, number format, and separator are carried with the same override.
- Font family, size, color, bold, and italic are carried by the same text
  properties payload; nullable bold/italic values preserve inherited state.
- Existing chart-level labels remain the fallback when the series override is
  disabled.
- The existing chart reader/writer already owns `c:dLbls` serialization, so the
  edit survives save and reopen without a host-specific package path.

This is functional authoring and package round-trip coverage. PowerPoint-
authoritative chart visual baselines remain separate work.
