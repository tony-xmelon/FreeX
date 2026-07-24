# FreeP Chart Point Options - 2026-07-24

This function-first slice exposes the point-level chart style payload already supported by the
model and PPTX reader/writer.

## Scope

- WPF and Avalonia expose a shared Point Options command and dialog.
- A selected series/category point supports fill color, outline color, outline width, marker
  symbol, and marker size.
- The shared command snapshots the prior point color/style dictionaries and restores them exactly
  on undo.
- Existing gradient point fills and unrelated marker metadata remain retained when the dialog does
  not replace them; authored solid overrides round-trip through `c:dPt`.

## Verification

- Presentation planner/command and PPTX round-trip tests: 71/71.
- WPF host dialog/routing tests: 22/22.
- Avalonia headless dialog/ribbon registration tests: 5/5.
- Ribbon definition tests: 18/18.
- Release builds for Presentation, WPF Host, Avalonia Host, and Ribbon definitions: 0 warnings/errors.

## Remaining chart function scope

Chart-area and plot-area formatting dialogs, richer chart data workflows, and advanced PowerPoint
chart semantics remain separate slices. This work does not alter chart geometry or renderer
calibration.
