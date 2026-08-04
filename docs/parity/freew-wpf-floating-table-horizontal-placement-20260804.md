# FreeW WPF floating-table horizontal placement

## Scope

WPF now consumes the renderer-neutral floating-table placement contract for horizontal positioning. Text, margin, and page anchors plus authored offsets and horizontal alignment specifications map onto the native FlowDocument table margin without replacing the editable table surface.

## Guard

Vertical placement remains retained in the model and package but is not mapped to a block margin. A margin would move normal flow rather than provide Word's floating composition semantics; that work requires a true WPF floating block container and is tracked separately.

## Verification

The focused host contract renders paired inline and floating 120pt tables. A text-relative 36pt X offset produces an exact 48-DIP left shift while the inline control stays at zero. The test also asserts the authored vertical offset is not incorrectly applied as ordinary block spacing.
