# FreeP Wave65: Grouped-Child Caret Navigation

## Scope

Wave65 closes the next FreeP residual after grouped-child rich-text formatting: logical caret movement, keyboard selection, paragraph-boundary edits, and save/reopen evidence for nested in-canvas text.

## Production change

The existing `InCanvasRichTextNavigationPlanner` had no production consumer. It now owns renderer-neutral Left/Right, Home/End, Ctrl+Home/Ctrl+End, Ctrl-word movement, and selection-anchor resolution in Avalonia. Avalonia keeps native visual-line geometry for Up/Down and unmodified visual Home/End. WPF continues to use its native `RichTextBox` route; paired tests cover the same logical contract and nested child propagation.

## Evidence

- Shared presentation tests: 30 passed.
- Avalonia focused navigation tests: 2 passed.
- WPF nested-child paragraph selection/edit test: 1 passed.
- Physical Linux/X11 grouped-caret retry: 5 passed, 0 failed; manifest contract passed.
- Latest physical evidence: `artifacts/freep-wave65-grouped-caret-20260730/freep/sessions/20260730T071559192Z/freep-rich-text-shortcut-validation/results.json`.

The physical lane exercises nested child entry, document-boundary navigation, cross-paragraph selection input, boundary Delete/Backspace, type-to-replace, undo/redo, and native PPTX inspection. The saved package preserves the child path, transforms, paragraph/run structure, and edit checkpoints.

## Honest residual

The physical wrapper reports a non-fatal warning when the optional host-mounted-after SHA256 artifact is unavailable during harness teardown. The probe and manifest remain valid because the required source/mounted package invariants and native package predicates pass; the wrapper now excludes that optional hash from validation when it cannot be materialized. Visual-line Up/Down remains renderer-specific by design, and exhaustive all-command UI coverage is outside this bounded slice.
