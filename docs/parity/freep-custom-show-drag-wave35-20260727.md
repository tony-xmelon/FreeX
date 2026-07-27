# FreeP Custom Show Drag Parity - Wave35

Date: 2026-07-27
Branch: `codex/freep-functional-wave35-20260727`
Authority: WPF `freep/FreeP.App.Host/CustomShowDialog.cs`.

## Host gap

Both hosts use `SlideShowCustomShowSessionPlanner.BuildDragReorderPlan` and the same
`MainWindow.MoveCustomShowSlide` mutation. The gap was in the input lifecycle:

- WPF starts `DragDrop.DoDragDrop` after the system drag threshold. WPF's `Drop` handler
  accepts only the typed slide-index payload, so a release outside the list cancels without
  changing the custom show.
- Avalonia previously only set a local active flag. It did not capture the pointer, so a
  release after leaving the list could lose the completion event, and its pointer-release
  path defaulted a non-row release to the end of the list.

This is a host interaction gap. It is not a PowerPoint-vs-FreeP feature limitation: the
portable custom-show model, planner, and mutation already existed and are covered by both
hosts.

## Change

Avalonia now captures the pointer to the dialog when the drag threshold is crossed. Pointer
capture loss cancels the pending drag. On release, the host checks whether the pointer is
inside the custom-show list before resolving a row and applying the existing shared reorder
plan. Releases outside the list are now no-ops, matching WPF's drop-target contract.

The inside-list and outside-list completion policy is exposed only through an internal test
seam; no shared planner or renderer code changed.

## Evidence

- WPF authority test: `CustomShowDialog_DragReorder_UsesSharedPlannerAndExistingMoveMutation`
  runs the WPF dialog's existing reorder route against a real WPF window and presentation.
- Avalonia headless test: `CustomShowDialog_drag_reorder_uses_shared_planner_and_existing_move_mutation`
  runs the existing inside-list reorder, verifies that an outside-list completion leaves the
  slide-id order unchanged, and uses a real Avalonia `Pointer` to verify capture loss cancels
  the pending drag before any mutation.
- Focused WPF test filter: 2/2 passed.
- Focused Avalonia test filter: 2/2 passed.
- `git diff --check`: passed.

No visual calibration or screenshot claim is made in this slice. Native drag ghost visuals
and insertion-indicator polish remain platform-specific follow-up work; the functional
drop/cancel contract is the closed scope here.
