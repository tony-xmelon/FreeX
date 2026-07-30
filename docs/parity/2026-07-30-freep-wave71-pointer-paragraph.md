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

Focused test execution was attempted, but the worktree's Release outputs were
locked by another process after the parallel test launch. No Docker command was
run. The source-contract test and diff checks remain available for the next
uncontended focused run.
