# FreeP Rich-Text Pointer Paragraph Boundary

## Gap

WPF RichTextBox paragraph gestures carry the following paragraph marker when the
selected paragraph is not the last paragraph. Avalonia stopped at the newline,
so triple-click copy/delete behavior differed even though wrapped drag selection
and pointer autoscroll already matched.

## Change

`InCanvasRichTextPointerSelectionPlanner.PlanParagraph` now owns the shared
paragraph range rule. Avalonia uses it for triple-click selection; the final
paragraph remains marker-free. The WPF parity test records the native range
contract, and the Linux pointer lane triple-clicks the first paragraph and
requires an exact newline-terminated `xclip` transcript. Missing `xclip`, a
timeout, or any text mismatch fails the lane.

## Verification

The managed source-contract guard passed 1/1 on the integration worktree,
including the ordered probe manifest declaration and the runner's exact
forward/reverse/paragraph transcript contract.

Physical Linux validation also passed:

- Command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreePRichTextShortcutValidation.ps1 -PointerSelection -Port 6171 -OutputDir artifacts\wave71-freep-pointer-20260730`
- Result: 5 passed, 0 failed; manifest contract validation passed.
- Exact paragraph proof: `pointer-paragraph-selection-proof.txt` records
  `tool=xclip`, `status=true`, and `exact-match=true` for the expected
  newline-terminated paragraph.
- Manifest: `artifacts/wave71-freep-pointer-20260730/freep/sessions/20260730T205725653Z/freep-rich-text-shortcut-validation/results.json`.

The runner stopped its harness-owned container after the successful run.
