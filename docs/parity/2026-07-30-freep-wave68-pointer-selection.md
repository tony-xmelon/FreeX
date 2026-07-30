# FreeP Wave68: pointer drag selection

Wave68 adds a bounded physical Linux contract for in-canvas rich-text pointer
selection across unequal-width wrapped visual lines and a paragraph boundary.
The lane is intentionally readback-only and does not claim text mutation.

## Shared and host behavior

- `InCanvasRichTextPointerSelectionPlanner` owns anchor/caret clamping and
  direction-preserving logical selection semantics for both hosts.
- Avalonia routes pointer press and move through the shared planner. Its hit
  test chooses the nearest measured paragraph span, including when the pointer
  is in the gap between paragraphs.
- WPF continues to use the native `RichTextBox` pointer selection route; the
  managed parity test verifies that native selection maps to the same logical
  range and preserves the paragraph separator.

## Physical contract

`Run-FreePRichTextShortcutValidation.ps1 -PointerSelection` generates the
deterministic fixture `21-comments-notes-grouped-child-pointer-selection.pptx`
and runs the existing rich-text Docker probe with surface
`in-canvas-grouped-child-pointer-selection`.

The probe drags from the first visual line to the final wrapped line, copies in
both directions, and requires exact bounded `xclip -selection clipboard -out`
readback. The canonical geometry artifact is
`pointer-selection-calibration.txt`; the forward and reverse transcript files
must match the expected two-paragraph text byte-for-byte. The mounted fixture
hash must remain unchanged because this contract does not edit the document.

Docker physical execution is intentionally deferred to the parent integration
session, as requested for this slice.

## Focused verification

- Avalonia pointer drag test: passed, 1/1.
- WPF native cross-paragraph pointer-selection test: passed, 1/1.
- Bash probe syntax, PowerShell runner syntax, JSON schema parsing, and
  deterministic fixture generation: passed.
- Shared presentation test execution remains blocked by the existing
  `FreeP.App.Presentation.Tests` namespace/type-resolution errors across
  pre-existing files; this slice does not alter that unrelated test-project
  issue.
