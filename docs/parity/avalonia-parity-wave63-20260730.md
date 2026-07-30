# Avalonia/WPF parity Wave 63

Date: 2026-07-30

## Scope

Wave 63 moved below exhausted command-inventory parity and closed one bounded,
user-visible workflow-depth gap in each app:

- FreeX: quoted same-sheet formula-reference grip resizing.
- FreeW: direct and nested grouped-child Edit Points.
- FreeP: direct and nested grouped-child in-canvas text authoring.

## Delivered

### FreeX

`FormulaReferenceDragResizePlanner` now preserves explicit quoted sheet
qualifiers while replacing only the resized range token. WPF and Avalonia use
the shared planner and have paired managed commit/result coverage.

Commit: `0dfc62428a`

Detail: `docs/parity/avalonia-parity-wave63-freex-20260730.md`

### FreeW

Custom-geometry conversion and edit-point mutation now resolve a nested
`DrawingGroup` child path through shared commands. WPF and Avalonia render,
hit-test, and drag handles through composed group transforms. Undo, Escape,
and DOCX persistence are covered.

Commit: `660d8111c4`

Detail: `docs/parity/freew-wave63-nested-edit-points-20260730.md`

### FreeP

Shared shape-tree resolution now reaches arbitrarily nested text-bearing
children. WPF and Avalonia activate the same in-canvas editor workflow,
including transformed placement, commit, cancel, undo, and saved PPTX
persistence.

Commit: `6ccf508638`

Detail: `docs/parity/avalonia-parity-wave63-freep-grouped-child-text-20260730.md`

## Verification

- Integrated focused lane: 39 passed, 0 failed across nine affected projects.
- Post-sync FreeW overlap lane: 23 passed, 0 failed.
- Post-sync FreeX grip lane: 9 passed, 0 failed.
- Linux/X11 physical evidence:
  - FreeX quoted formula grip: 1 passed, 0 failed; exact formula, result 15,
    and clean save.
  - FreeW nested Edit Points: 3 passed, 0 failed; exact changed leaf geometry
    with unchanged parent transforms.
  - FreeP grouped-child text: 5 passed, 0 failed; edit/save/undo/redo and
    native PPTX text structure.
- Repository preflight: passed.
- Full `FreeX.slnx` Release build: 0 warnings, 0 errors.
- Default non-UI suite, serialized to avoid cross-project benchmark
  contention: 33,381 passed, 0 failed, 133 skipped.

The initial parallel default run had two unrelated timing-budget failures.
Both passed immediately in isolation, and the complete serialized rerun was
green.

## Remaining high-value slices

- FreeX: cross-sheet formula-reference grip resize while formula editing
  remains active, then dedicated physical 3-D sheet-range proof.
- FreeW: nested grouped-child text editing, followed by nested formatting.
- FreeP: grouped-child text formatting across ribbon routes, followed by
  broader caret navigation and multi-paragraph physical coverage.
- Cross-app: continue visual fidelity work after the remaining functional
  workflow-depth gaps, especially FreeW dialog families with known visual
  mismatches.
