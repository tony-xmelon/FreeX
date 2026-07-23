# FreeP Format Painter source-to-target workflow

## Scope

PowerPoint's normal single-click Format Painter workflow captures one selected
source shape, waits for the next canvas shape, applies the source fill,
outline, and first-run formatting once, and leaves the target selected. FreeP
previously supported only the immediate multi-selection variant.

The shared `EditingSession` now owns the temporary source-to-target state and
applies the existing `ApplyFormatPainterCommand` to exactly one hit-tested
target. WPF and Avalonia gesture handlers intercept the next shape click before
move, resize, marquee, OLE, or zoom handling. A slide change cancels the armed
state. Multi-selection keeps the existing first-selected-source behavior.

## Verification

- `EditingSession5ATests` plus `CanvasGesturePlannerTests` focused route: `55/55`
  after the new source/target and undo cases.
- WPF `RibbonEditorCompleteness5BTests` plus `CanvasEditingTests`: `122/122`.
- Avalonia `MainWindowHeadlessTests`: changed command path compiled and the
  existing format-painter command coverage passed; the filtered run had five
  unrelated pre-existing failures in animation/transition command inventories,
  print-pane line formatting, and review-pane action projection.

The change is functional workflow parity; it does not claim a PowerPoint pixel
baseline because Format Painter is an interaction state rather than a slide
raster feature.
