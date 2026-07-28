# FreeP Chart Leader Lines

## Functional Slice

Chart-level `c:showLeaderLines` state for pie and doughnut data labels now survives
PPTX read/write, including an explicit disabled value. The shared chart display
planner and undo command expose the state, and WPF/Avalonia Chart Options dialogs
present the same three-state control, enabled for the chart families that use it.

This slice preserves authoring/package semantics only; it makes no new raster-fidelity
claim for leader-line geometry.

## Validation

- Host chart and dialog tests: 85/85.
- Presentation chart command and planner tests: 103/103.
- WPF Host.Tests Release build: 0 warnings, 0 errors.
- Avalonia Release build: 0 warnings, 0 errors.
