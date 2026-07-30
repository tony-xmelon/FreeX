# Avalonia parity Wave 63: FreeP grouped-child text authoring

Date: 2026-07-30

## Functional slice

FreeP in-canvas rich-text editing now resolves direct and arbitrarily nested
group descendants through one shared shape-tree path traversal. WPF and
Avalonia both use the same descendant hit result, text-body planner, command
lookup, absolute child geometry, and rotation/flip placement metadata.

Commit and undo now reach nested text shapes; cancel leaves the descendant
unchanged. Table-cell pointer lookups also use the shared resolver so a nested
table does not regress into a top-level-only lookup.

## Managed coverage

- Shared presentation planner: **15 passed, 0 failed** in
  `InCanvasTextEditPlannerTests`, including three-level path resolution,
  transformed placement, commit/undo, and cancel.
- WPF editor: **1 passed, 0 failed** in
  `RichTextEditorTests.InCanvasTextEditor_NestedChild`.
- Avalonia editor: **1 passed, 0 failed** in
  `SlideCanvasAvaloniaTests.InCanvasTextEditor_NestedChild`.

The WPF and Avalonia tests instantiate their real editor overlays. Both cover
the same nested child workflow and transformed editor placement.

## Physical Linux evidence

The existing rich-text X11 harness gained an opt-in grouped-child fixture mode.
It wraps the existing notes text shape in a native `p:grpSp`, opens it in
FreeP Avalonia at **1280x820 / 96 DPI**, performs physical edit and commit,
saves, undoes, redoes, and inspects the saved PPTX after each checkpoint.

- Strict manifest: **5 passed, 0 failed**.
- Contract validation: **passed**.
- Exact postconditions: shape ID 2 retained its bounds and native paragraph
  structure; save/undo/redo produced the expected text and soft break with no
  picture or graphic-frame fallback objects.
- Owned container `freex-linux-interactive-freep-6097`: stopped after capture.

Retained evidence:

- `artifacts/freep-grouped-child-wave63-run4/freep/sessions/20260730T030302915Z/freep-rich-text-shortcut-validation/results.json`
- `tools/FreeP.RenderCompare/Generate-GroupedTextFixture.ps1`

## Remaining FreeP workflow residuals

- Nested grouped-child text formatting through every ribbon route still needs
  a dedicated physical parity lane; the shared text-body format planner already
  resolves descendants.
- Grouped-child text caret navigation and multi-paragraph point-mode behavior
  need broader physical coverage.
- A physical WPF lane remains unavailable in the Linux harness; WPF parity is
  covered by the managed editor test.
- Broader PowerPoint-authoritative visual and slideshow baselines remain
  separate from this functional authoring slice.
