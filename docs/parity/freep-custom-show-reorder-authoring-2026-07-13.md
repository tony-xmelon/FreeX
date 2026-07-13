# FreeP Custom Show Reorder Authoring Parity - 2026-07-13

## Scope

This slice advances FreeP custom-show authoring parity by adding a shared
planner mutation for reordering slides inside an existing custom show. The
route is shared-first and does not depend on a WPF- or Avalonia-specific
renderer.

## Evidence

- `SlideShowCustomShowPlanner.MoveCustomShowSlide` validates the custom show,
  validates the selected custom-show slide occurrence by index and slide id,
  clamps out-of-range target indexes deterministically, and returns the
  post-move selected slide index for host dialogs.
- Duplicate slide ids remain distinct because the mutation moves the selected
  occurrence index instead of deduplicating by slide id.
- WPF and Avalonia expose thin host adapter methods over the same shared
  planner route, matching the existing create, rename, delete, and membership
  authoring adapters.
- The WPF and Avalonia Custom Shows dialogs render the selected custom-show
  slide occurrence order separately from deck-order membership checkboxes and
  wire visible Move Up/Move Down controls through the shared planner route.

## Verification

- `freep/FreeP.App.Presentation.Tests/SlideShowCustomShowPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/SlideShowTests.cs`
- `freep/FreeP.App.Avalonia.Tests/SlideShowWindowHeadlessTests.cs`

## Deferred

- The current visible WPF and Avalonia custom-show dialogs still use deck-order
  checkbox membership for add/remove updates, so adding duplicate occurrences
  remains outside the visible dialog surface. Drag-reorder polish should consume
  the shared route in a later UI-focused slice.
- PowerPoint-authoritative custom-show visual/workflow baselines remain blocked
  until a COM-capable PowerPoint baseline lane is available.
