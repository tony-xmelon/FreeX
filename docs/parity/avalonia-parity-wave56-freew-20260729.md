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
  text rendering, including rotated text.
- Collapsed shape selections correctly after typing, deletion, caret movement, and paragraph breaks.

## Evidence

- `DocumentViewFloatingShapeTests.Horizontal_shape_text_drag_selects_and_replaces_the_selected_range`
  covers horizontal drag selection, Bold formatting, and replacement.
- `DocumentViewFloatingShapeTests.Rotated_shape_text_drag_selects_and_replaces_the_selected_range`
  covers both rotated directions and replacement through the shared command path.
- The complete `DocumentViewFloatingShapeTests` class passes, including the preceding caret, movement,
  undo/redo, rendering, and paragraph-break coverage.

## Residuals

- Shape text remains a compact Avalonia renderer rather than a native WPF `FlowDocument`; complex inline
  objects and advanced multi-line visual selection geometry may still differ.
- Keyboard Shift+Arrow extension inside shape text and drag-selection auto-scroll remain follow-ups.
