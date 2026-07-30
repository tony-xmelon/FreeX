# Avalonia parity Wave 62

Date: 2026-07-30

## Functional slices

- **FreeX formula-reference grip editing** now exposes Avalonia drag grips for
  existing same-sheet formula ranges. Resizing one range in a multi-area
  formula updates only that reference, keeps the other area intact, and
  synchronizes the formula bar and inline editor.
- **FreeW nested grouped-child editing** now resolves full child paths through
  arbitrary DrawingGroup nesting. WPF and Avalonia can select, move, and
  resize nested leaves; Avalonia can also select a nested group node. Shared
  commands preserve owner geometry and undo, while DOCX round-trip retains the
  edited child's local rotation and flips.
- **FreeP transformed table-cell editing** now renders, hit-tests, and places
  the live editor through a table frame's rotation and flips in WPF and
  Avalonia. PPTX read/write preserves the graphic-frame transform.

## Review corrections

- The initial FreeW physical probe incorrectly labeled resize as passed when a
  screenshot showed the outer group selected. The final wrapper leaves the
  resize result pending until exact saved-DOCX inspection proves that the
  outer and inner groups are unchanged and the selected leaf changed.
- Avalonia nested resize had stored the outer selection rectangle after
  correctly hitting a child handle. It now derives the drag base from the
  current full-path child geometry.
- Nested handle planning applied the child's rotation and flips twice. Raw
  model-space handle centers now pass through the leaf and ancestor transforms
  exactly once.
- Child identity compared only the terminal index. It now compares block, run,
  and the complete child path, preventing a click in another nested branch
  from mutating the stale selection.
- DOCX group-child transforms previously replaced local rotation and flip
  attributes with offset and extent only. Writer, round-trip, fixture, and
  physical assertions now preserve and verify the complete child transform.

## Physical Linux evidence

- FreeX formula-reference grip workflow: **1/1 passed**. Real X11 input resized
  the first range in `=SUM(B2:C3,D4:F6)`, preserved the second range, committed
  the exact formula, and produced result `15`.
- FreeW nested grouped-child workflow: **4/4 passed** from the exact integrated
  head. Real X11 input selected path `0,1`, moved it, resized its transformed
  bottom-right handle, saved the DOCX, and retained eight child handles.
  Inspection proved unchanged outer and inner geometry, changed leaf offset
  and size, and unchanged `10deg,flipH=True,flipV=False` leaf transform.
- FreeP transformed table-cell workflow: **5/5 passed**. Real X11 input entered
  a transformed cell editor, exercised caret/input, committed and saved exact
  content and frame transform, and verified Escape cancellation.

Retained detailed evidence:

- `artifacts/linux-interactive/freex/interaction-validation/20260730T011816Z/interaction-validation.json`
- `freew/artifacts/wave62-integration-physical/freew-wave62-nested-group-child-validation.json`
- `freep/docs/parity/2026-07-30-freep-transformed-table-cell-edit-wave62.md`
- `freep/artifacts/freep-transformed-table-cell-edit-wave62-rerun/freep/sessions/20260730T011542857Z/freep-transformed-table-cell-edit-validation/results.json`

## Focused verification

- FreeX Avalonia formula-reference grip suite: **1 passed**.
- FreeP shared transformed table-cell suites: **61 passed**.
- FreeP Avalonia rendering suite: **79 passed**.
- FreeW model grouped-drawing suite: **18 passed**.
- FreeW DOCX grouped-drawing round-trip suite: **19 passed**.
- FreeW shared layout planner suite: **33 passed**.
- FreeW WPF grouped-drawing host suite: **12 passed**.
- FreeW Avalonia floating-selection suite: **30 passed**.

The integrated focused total is **253 passed, 0 failed**. Dedicated Linux/X11
evidence adds **10 passed, 0 failed** across the three app workflows.

## Final integration gates

- Repository preflight passed across 209 JSON files, 259 XML-backed files,
  77 PowerShell tools, 9 workflows, 123 projects, generated parity evidence,
  packaging checks, and 9,598 conflict-marker candidates.
- The preflight initially found the FreeP whole-window visual-evidence manifest
  stale after the transformed editor source changed. The canonical generator
  refreshed its source hash; the complete preflight then passed.
- `FreeX.slnx` built in Release with **0 warnings and 0 errors**.
- `FreeX.DefaultTests.slnx` finished with **33,370 passed, 0 failed, and
  133 skipped** across 19 test assemblies. Its twentieth solution entry is the
  non-test `FreeX.Fixtures` project.

## Remaining work

- FreeX grip dragging still needs separate quoted and cross-sheet reference
  workflows. Same-sheet existing multi-area range resizing is complete.
- FreeW has no known residual in nested leaf/group-node selection, move,
  resize, undo, transform composition, or DOCX persistence. Nested child text,
  formatting, and edit-points workflows remain separate grouped-object slices.
- FreeP transformed table-cell editing is physically verified on Avalonia and
  covered by shared/WPF managed contracts. A physical WPF lane is unavailable
  in the Linux harness.
- Canonical visual reports still contain broader pixel-fidelity residuals.
  This wave closes functional interaction and persistence slices and does not
  relabel unrelated visual mismatches.
- Authoritative Excel, Word, and PowerPoint baselines remain unavailable on
  this host. WPF remains the local platform authority where Office captures
  cannot be produced.
