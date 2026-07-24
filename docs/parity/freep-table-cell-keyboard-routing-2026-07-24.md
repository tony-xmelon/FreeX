# FreeP Table Cell Keyboard Routing - 2026-07-24

Scope: bounded FreeP table-cell inline-editing parity for keyboard ownership and modifier semantics.

## Coverage

- `TableCellEditPlanner.PlanKeyboard` is the shared policy for Escape cancellation, Tab and Shift+Tab navigation, and Ctrl+B/I/U formatting.
- WPF and Avalonia map native key and modifier values into the same renderer-neutral intent plan.
- A focused Avalonia table-cell editor remains above canvas arrow/delete handling, while commit, cancel, selection, and command-bus history stay in the existing editor transaction paths.

## Verification

- `TableCellEditPlannerTests` covers the shared keyboard intent matrix.
- `CanvasEditingTests` checks that the WPF RichTextBox host consumes the shared keyboard policy.
- `SlideCanvasAvaloniaTests` checks focused table-cell editor ownership and existing commit/navigation behavior.
- `MainWindowHeadlessTests` checks the Avalonia shell wiring for the focused-editor guard and shared policy.

## Remaining

This does not add a native Avalonia RichTextBox equivalent, visible PowerPoint-style list galleries, or PowerPoint-authoritative rich-editor visual baselines.
