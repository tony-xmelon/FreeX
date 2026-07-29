# Avalonia parity wave 52

Date: 2026-07-29

## Closed slices

- FreeX formula point mode now moves the visible worksheet selection and name
  box to the pointed range while retaining the formula's source cell for commit.
  The behavior is shared through `WorkbookSession.SelectRangeForFormulaEdit`
  and exercised through real Avalonia formula-bar input.
- FreeW Avalonia can directly select a child inside a floating drawing group.
  Child rotation and horizontal/vertical flips use an undoable model command;
  group-level arrange and ungroup commands continue to target the owning group.
  Selection chrome follows both the child transform and the parent group's
  rotation/flip transform.
- FreeP Animation Pane `Play From Selected` now starts WPF and Avalonia
  slideshow playback at the selected animation row through one shared playback
  route/controller contract.
- The interactive Linux runner now publishes with build servers, shared
  compilation, node reuse, and parallel MSBuild disabled. This keeps physical
  validation foreground-owned and avoids leaving build workers behind.

## Focused validation

- FreeX service point-mode contract: 1/1 passed.
- FreeX Avalonia point-mode lane: 7/7 passed.
- FreeW grouped-object model lane: 15/15 passed.
- FreeW Avalonia floating-selection lane: 25/25 passed.
- FreeP shared Animation Pane planner lane: 102/102 passed.
- FreeP WPF slideshow controller and Animation Pane lanes: 36/36 passed.
- FreeP Avalonia slideshow window lane: 49/49 passed.

## Physical Linux evidence

- FreeX physical-only interaction matrix: 24/24 passed. The real X11
  formula-bar point-mode row clicked B2, observed the reference-selection
  transition, and committed `=B2`.
  Evidence: `artifacts/linux-interactive/freex/interaction-validation/20260729T052647Z/interaction-validation.json`.
- FreeW family X11 baseline: 37/37 passed.
  Evidence: `artifacts/linux-family-interactive/freew/sessions/20260729T052452307Z/family-validation/family-x11-results.json`.
- FreeP family X11 baseline: 24/24 passed, including the seeded Animation Pane
  open, row selection, close, and reopen workflow.
  Evidence: `artifacts/linux-family-interactive/freep/sessions/20260729T052254226Z/family-validation/family-x11-results.json`.
- Every harness-owned container stopped after validation.

## Remaining work

- FreeX formula point mode still needs cross-sheet pointing and broader visual
  comparison; autofill and selection-border drag remain separate interaction
  slices.
- FreeW grouped children still need local move/resize, formatting, text editing,
  edit-points mode, nested path selection, and a dedicated seeded Linux physical
  route.
- FreeP trigger-only `Play From Selected` semantics and PowerPoint-authoritative
  animation timing, easing, and visual checkpoints remain outstanding.
- Authoritative Word, Excel, and PowerPoint raster comparisons remain necessary;
  this wave closes functional and physical slices, not 100% pixel parity.
