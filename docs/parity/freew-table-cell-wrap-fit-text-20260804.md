# FreeW table-cell wrap and fit-text parity

Date: 2026-08-04

## Gap

FreeW previously dropped Word's per-cell `w:noWrap` and `w:tcFitText` properties. Opening and saving
a document therefore silently restored wrapping and disabled fit-text, and neither Table Properties
dialog exposed the two Cell Options controls.

## Slice

- `TableCell.WrapText` defaults to true and maps to Word's inverse `w:noWrap` toggle.
- `TableCell.FitText` defaults to false and maps to `w:tcFitText`.
- The reader accepts normal on/off tokens; the writer emits only non-default elements.
- `w:tcPr` children now follow schema order through borders, shading, no-wrap, margins, text
  direction, fit-text, and vertical alignment.
- Document merge, compare, and combine clones preserve both options.
- WPF and Avalonia Table Properties dialogs expose **Wrap text** and **Fit text** checkboxes.
- Applying either dialog uses the shared undoable command; undo and redo restore both values.

## Package Evidence

The package contract writes no-wrap-only, fit-text-only, and default cells. It asserts exact XML,
including omission of defaults and the ordered `tcMar`, `textDirection`, `tcFitText`, `vAlign`
sequence, then reopens the document and verifies the model values.

## Verification

- Table package contracts: 6/6.
- Table model and merge contracts: 26/26.
- Shared dialog planner and undo contracts: 6/6.
- WPF dialog/application contracts: 7/7.
- Avalonia table-properties surface/application contracts: 3/3.
