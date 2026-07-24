# FreeP Chart Series Options - 2026-07-24

This function-first slice adds a host workflow for formatting one chart series.

## Scope

- WPF and Avalonia expose a shared Series Options command and dialog.
- The selected series supports smooth-line state, secondary-axis assignment, line width,
  marker symbol, and marker size.
- The shared command applies the complete edit atomically and restores the prior line/marker
  objects on undo.
- Existing PPTX chart reader/writer fields carry the values through save and reopen.
- Automatic line and marker formatting remains absent when the user leaves those fields
  automatic; the command does not manufacture empty style objects.

## Verification

- Presentation planner/command tests: 69/69.
- WPF host dialog/routing tests: 20/20.
- Avalonia headless dialog/ribbon registration tests: 5/5.
- Release builds for Presentation, WPF Host, and Avalonia Host test projects: 0 warnings/errors.

## Remaining chart function scope

Per-point formatting, chart-area and plot-area formatting, and richer chart data editing remain
separate slices. This work intentionally does not add renderer-only calibration or change chart
geometry semantics.
