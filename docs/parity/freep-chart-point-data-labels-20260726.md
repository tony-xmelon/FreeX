# FreeP Chart Per-Point Data Labels

FreeP now exposes PowerPoint-style data-label overrides for an individual
selected chart point through the existing Point Options workflow.

- WPF and Avalonia share one working-copy planner and one undoable
  `SetChartPointOptionsCommand`.
- The workflow can enable or remove a point-scoped `c:dLbl` override and edit
  value, percentage, category, series-name, and legend-key components.
- Position, number format, separator, and the native point `delete` state are
  carried by the same point-style payload.
- Point-label font family, size, bold, italic, and color are authored through
  the same payload while nullable bold/italic values preserve inherited state.
- The chart reader and writer preserve point overrides under the owning
  series `c:dLbls` container, including point-only containers with no aggregate
  series labels.

This is functional authoring and package round-trip coverage. PowerPoint-
authoritative chart visual baselines remain separate work.
