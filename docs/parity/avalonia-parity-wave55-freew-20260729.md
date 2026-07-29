# Avalonia Parity Wave 55: Rotated Text-Box Pointer Caret Mapping

## Bounded Gap

Wave54 added pointer caret placement for horizontal floating text boxes. Rotated text boxes still
accepted keyboard edits, but a pointer click could not resolve a caret because the visible text was
painted through the renderer's 90-degree transform.

## Implementation

- Avalonia caret stops now use the same centered, width-constrained text geometry as the rotated shape
  renderer.
- Each stop records the renderer rotation and shape center. Pointer placement applies the inverse
  transform before choosing the nearest paragraph/run/offset stop.
- Both `Rotate90` and `Rotate270` are covered; insertion still routes through the existing shared
  undoable shape-text commands and preserves the selected run formatting.

## Evidence

- `DocumentViewFloatingShapeTests.Pointer_caret_placement_applies_the_shape_text_rotation_transform`
  verifies that the top edge maps to the start for `Rotate90` and the end for `Rotate270`.
- Existing horizontal pointer caret coverage remains unchanged.

## Residuals

- Drag-selection inside shape text remains a follow-up.
- Shape text still uses the existing compact Avalonia rendering treatment rather than a full WPF
  `FlowDocument` equivalent.
