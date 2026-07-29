# Avalonia Parity Wave 54: FreeW Text-Box Pointer Caret

## Bounded Gap

WPF's editable `RichTextBox` resolves a pointer click inside a text box to a `TextPointer` in the
correct paragraph and run. Avalonia's custom `DocumentView` could enter a selected text box only from
the keyboard and started editing at the end of the first run; it did not provide pointer caret placement.

## Implementation

- Avalonia floating text-box layout now emits page-space caret stops for each paragraph, run, and text
  offset, including wrapped lines and empty paragraphs.
- While a text box is already in text-edit mode, a click resolves to the nearest stop and updates the
  existing shape caret tuple. Object selection and drag behavior is unchanged before text-edit mode.
- Existing shared shape-text commands remain the edit boundary, so insertion into a resolved run keeps
  that run's formatting and synchronizes the outer drawing-run text mirror.
- Horizontal text boxes are covered. Rotated text boxes remain keyboard-editable; pointer placement for
  vertical/rotated text needs a separate transformed layout map.

## Evidence

- Focused Avalonia shape tests: `DocumentViewFloatingShapeTests`, including the new two-run pointer
  placement test.
- The new test verifies a pointer near the end of a two-run shape resolves to run 2, offset 5, and
  typing produces `Boldplain!` with `!` appended to the second run.

## Residuals

- Pointer drag-selection inside shape text is not included in this bounded slice.
- Rotated text-box pointer mapping remains a follow-up.
- Shape text rendering still uses the existing compact visual treatment; the new hit map follows that
  rendered geometry but does not replace the renderer with a full WPF `FlowDocument` equivalent.
