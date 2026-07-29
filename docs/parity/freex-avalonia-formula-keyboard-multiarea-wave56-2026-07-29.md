# FreeX Formula Keyboard Multi-Area Parity: Wave 56

This slice closes the keyboard-created multi-area formula-reference gap in both
worksheet hosts.

- Shared formula-entry planning now maps `F8` to Extend Selection and `Shift+F8`
  to Add to Selection while formula Point mode is active.
- In Add mode, an arrow key appends a new single-cell reference and
  `Shift+Arrow` appends a rectangular reference area. The new reference span is
  returned and tracked, so later point selection replaces only that area.
- A1 and R1C1 formatting, existing reference-span replacement, and sheet-name
  qualification remain in the shared planner. Ctrl/Cmd+Arrow and
  Ctrl/Cmd+Shift+Arrow continue to use the existing data-boundary target logic.
- WPF and Avalonia formula-bar and inline editors use the same mode transition
  and append planner paths.

## Verification

- Shared planner: 8 passed, 0 failed.
- Avalonia worksheet keyboard editing: 10 passed, 0 failed.
- WPF formula-bar Shift+F8 host behavior: 1 passed, 0 failed.
- Relevant Release builds completed without compile errors.

## Remaining Residuals

- Three-dimensional sheet references are not yet produced by keyboard Point
  mode.
- More exotic modifier-aware keyboard selection combinations beyond the Excel
  F8/Add-to-Selection path remain candidates for future parity work.
