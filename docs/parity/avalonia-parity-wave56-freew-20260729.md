# Avalonia Parity Wave 56: Floating Shape Text Drag Selection

## Bounded Gap

Wave 54/55 added pointer caret stops for horizontal and rotated floating text boxes, but a press-drag
inside an editing text box still moved the floating object or left only a collapsed caret. Avalonia had
no shape-text selection anchor, selection paint, or range mutation route.

## Implementation

- Added an Avalonia-only shape-text selection anchor and active endpoint with pointer capture. Horizontal,
  `Rotate90`, and `Rotate270` drags resolve through the existing caret-stop map and inverse rotation.
- Kept shape movement, resize handles, edit points, and ordinary document selection on their existing
  independent pointer paths.
- Added shared `ReplaceShapeTextParagraphsCommand` in `FreeW.Core.Model`. Replacement and deletion of a
  selected range, plus Bold and other character-format transforms, now use the command bus and preserve
  text and formatting outside the selected spans.
- Paint selected shape characters with the existing selection brush in the same transform used by shape
  text rendering, including rotated text. Highlight widths use each selected run's actual font metrics.
- Collapsed shape selections correctly after typing, deletion, caret movement, and paragraph breaks.
- Formatting validates both endpoints and clones paragraphs before and after the selected span unchanged;
  stale or out-of-range shape selections are a no-op rather than falling through to body-text formatting.

## Evidence

- `DocumentViewFloatingShapeTests.Horizontal_shape_text_drag_selects_and_replaces_the_selected_range`
  covers horizontal drag selection, Bold formatting, and replacement.
- `DocumentViewFloatingShapeTests.Rotated_shape_text_drag_selects_and_replaces_the_selected_range`
  covers both rotated directions and replacement through the shared command path.
- `DocumentViewFloatingShapeTests.Shape_text_formatting_only_mutates_paragraphs_inside_the_selection`
  covers a middle-paragraph-only format change across three differently formatted shape paragraphs.
- `DocumentViewFloatingShapeTests.Shape_text_selection_highlights_use_each_runs_actual_font_metrics`
  asserts that selection geometry follows the selected run's font size instead of a fixed 9pt metric.
- The complete `DocumentViewFloatingShapeTests` class passes, including the preceding caret, movement,
  undo/redo, rendering, and paragraph-break coverage.

## Residuals

- Shape text remains a compact Avalonia renderer rather than a native WPF `FlowDocument`; complex inline
  objects and advanced multi-line visual selection geometry may still differ.
- Keyboard Shift+Arrow extension inside shape text and drag-selection auto-scroll remain follow-ups.
