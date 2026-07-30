# Wave 64 FreeP grouped-child rich-text parity

## Implementation

- WPF shape editing routes Bold, Italic, Underline, superscript/subscript, font family, font size, and color through the shared recursive `InCanvasTextEditPlanner` run mutation path.
- Avalonia shape editing already consumes the same `InCanvasRichTextEditBuffer` and shared planner path; the paired test covers a nested group child with two paragraphs and four source runs.
- The grouped fixture now preserves multiple native paragraphs and runs so physical selection crosses both boundaries.
- The Linux X11 probe selects the nested child physically, applies Bold through the shortcut and Home ribbon key-tip route, applies the final Bold/Italic/Underline shortcut pass, saves, undoes the three formatting transactions, and redoes them with Ctrl+Y.

## Verification

Managed tests:

- `FreeP.App.Host.Tests`: `InCanvasTextEditor_NestedChild_FormatsCrossParagraphSelectionThroughSharedPlanner` passed.
- `FreeP.App.Rendering.Avalonia.Tests`: `InCanvasTextEditor_NestedChild_FormatsCrossParagraphSelectionThroughSharedPlanner` passed.

Physical evidence:

- Run: `artifacts/freep-grouped-child-wave64-run10`
- Manifest: `artifacts/freep-grouped-child-wave64-run10/freep/sessions/20260730T051419451Z/freep-rich-text-shortcut-validation/results.json`
- Result: 5 passed, 0 failed at 1280x820, 96 DPI in the Linux X11/noVNC harness.
- Native package inspection proves the selected `Slide 1 has` paragraph and selected ` s` prefix of the second paragraph carry Bold+Italic+Underline, while `peaker notes` remains unformatted. Shape ID 2 bounds and the two-paragraph structure remain unchanged.

## Residual limitations

- The physical lane uses three formatting commits because the ribbon key-tip transition can commit the in-canvas editor. Undo/redo is therefore validated as three Ctrl+Z/Ctrl+Y transactions in the grouped lane.
- The physical probe is intentionally scoped to the grouped-child rich-text route; broader ribbon command coverage remains in the existing FreeP interaction suites.
