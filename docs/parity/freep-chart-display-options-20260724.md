# FreeP Chart Display Options - 2026-07-24

FreeP now exposes a shared chart-options workflow in both WPF and Avalonia. The
working copy edits chart title, legend placement/visibility, value-label display
and placement, and category/value major gridlines. OK commits the complete set as
one `SetChartDisplayOptionsCommand`; cancel leaves the live chart untouched and
undo restores the prior title, automatic-title flag, legend, label metadata, and
axis gridline state.

The existing PPTX chart reader/writer already owns these fields, so the slice also
verifies save/reopen behavior for the edited options. This is a function-first
authoring slice; it does not claim that every PowerPoint chart-format pane is
complete.

Verification:

- Presentation chart planner/command tests: 65/65.
- WPF chart/dialog and shared-dialog tests: 16/16.
- Avalonia chart dialog tests: 2/2.
- Release builds completed through each dependent host test project with 0 warnings/errors.
