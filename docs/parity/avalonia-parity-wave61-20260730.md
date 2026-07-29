# Avalonia parity Wave 61

Date: 2026-07-30

## Functional slices

- **FreeX multi-area formula editing** now preserves an already-authored
  quoted first area while a later area is edited and replaced. Avalonia keeps
  the live reference span through reverse-selection notifications and recovers
  the trailing quoted reference when transient TextBox state loses tracking.
- **FreeW grouped-child editing** now routes direct-child move and resize
  gestures through group-local coordinates. Shared commands persist position
  and size with undo, WPF and Avalonia expose the same child selection path,
  and Avalonia renders and hit-tests eight handles through the combined child
  and group transforms.
- **FreeP rotated shape-text editing** now transforms the live editor overlay
  with the rendered shape in both WPF and Avalonia. Rotation, flips, transform
  origin, commit, cancellation, and LostFocus lifecycle use the same shared
  placement contract.

## Physical Linux evidence

- FreeX selector `formula-multi-area-edit`: **1/1 passed**. Real X11 input
  changed the tracked second area and committed
  `=SUM('Revenue Data'!F5,'Revenue Data'!J7)` with result `30` and
  `Revenue Data!J7` selected before readback.
- FreeW grouped-child workflow: **4/4 passed**. Real X11 input selected child
  1, moved it, resized its transformed bottom-right handle, saved the DOCX,
  and proved exact changed child geometry while the owning group's offset and
  size remained unchanged. Eight child handles remained visible.
- FreeP rotated shape-text workflow: **5/5 passed**. Real X11 input entered
  the editor through a point inside the rotated polygon but outside its
  unrotated edge, replaced the text, committed and saved it, then proved that
  Escape canceled a second edit. The package retained exact text, bounds, and
  30-degree rotation.

The detailed reports and retained artifact paths are:

- `docs/parity/avalonia-parity-wave61-freex-formula-edit-20260730.md`
- `freew/docs/parity/freew-wave61-grouped-child-editing.md`
- `docs/parity/freep-rotated-shape-text-edit-wave61-20260730.md`

## Integration review

- The FreeX slice deliberately did not duplicate Wave 56's F8/Shift+F8 append
  path. It targets mutation of an existing non-final quoted area and verifies
  the exact saved formula, result, and live reference selection.
- FreeW's physical iterations exposed child hit-testing and selection geometry
  that still used stale or parent-space rectangles after a command. The final
  implementation resolves current child layout data, composes child and group
  transforms for the visible polygon, and reran the physical workflow green.
- FreeP source review confirmed a genuine application gap: shape rendering was
  rotation-aware, but the editor overlay was axis-aligned. The physical lane
  demonstrates transformed editor entry, typing, commit, and cancellation.
- Concurrent `origin/main` work was merged repeatedly. The primary dirty
  checkout was not modified.

## Focused verification

- FreeX Avalonia R53 formula-point suite: **9 passed**.
- FreeP shared editor/geometry suites: **19 passed**.
- FreeP WPF rich-text editor suite: **50 passed**.
- FreeP Avalonia slide-canvas suite: **78 passed**.
- FreeW model grouped-drawing suite: **17 passed**.
- FreeW shared layout planner suite: **32 passed**.
- FreeW DOCX grouped-drawing round-trip suite: **18 passed**.
- FreeW WPF grouped-drawing host suite: **11 passed**.
- FreeW Avalonia floating-selection suite: **27 passed**.

The integrated focused total is **261 passed, 0 failed**. Physical evidence
adds **10 passed, 0 failed** across the three dedicated Linux/X11 workflows.

## Remaining work

- FreeX still needs deeper drag-edit and non-quoted multi-area formula variants
  where those paths are not already covered by shared or physical evidence.
- FreeW direct-child move/resize is complete for this slice. Nested child paths,
  child formatting, child text editing, and edit-points mode remain separate
  grouped-object workflows.
- FreeP ordinary rotated shape text is complete for this slice. Rotated table
  cell editors and grouped-child text editing remain separate workflows.
- FreeW's canonical visual comparison still contains the broad visual residual
  set reported by Waves 59 and 60. This wave closes functional input/model
  paths and does not relabel unresolved pixel mismatches.
- Authoritative Excel, Word, and PowerPoint application baselines remain
  unavailable on this host. WPF remains the local platform authority where an
  Office-level capture cannot be produced.
