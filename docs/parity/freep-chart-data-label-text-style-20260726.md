# FreeP Chart Data-Label Text Styling

FreeP now exposes PowerPoint-style text styling for chart-level data labels
through the existing Chart Options workflow.

- WPF and Avalonia share one working-copy planner and one undoable
  `SetChartDisplayOptionsCommand`.
- The workflow edits label font family, size, color, bold, and italic state.
- Nullable bold/italic values preserve inherited chart/theme behavior instead of
  forcing an explicit value.
- Existing chart-level data-label components remain intact while the text style
  is changed.
- The existing chart reader/writer owns `c:dLbls` and `c:txPr` serialization, so
  the edit survives save and reopen without a host-specific package path.

This is functional authoring and package round-trip coverage. PowerPoint-
authoritative chart visual baselines remain separate work.
