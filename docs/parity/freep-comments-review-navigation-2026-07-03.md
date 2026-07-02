# FreeP Comments Review Navigation Parity - 2026-07-03

## Scope

This slice advances the FreeP comments/review workflow-depth lane by moving
Previous Comment and Next Comment out of inert host command registrations and
onto a shared planner-backed navigation path.

## What changed

- `PresentationReviewWorkflowPlanner` now builds a
  `PresentationCommentNavigationPlan` for previous/next comment navigation.
- The shared adjacent-comment lookup now targets the nearest real thread when
  the current slide has no selected comment, instead of skipping the nearest
  comment on an empty slide.
- WPF and Avalonia both route Review Previous/Next Comment commands through the
  shared plan.
- Avalonia pane action buttons use the same navigation path as the ribbon
  commands.

## Verification

- Planner coverage proves same-slide navigation, cross-slide navigation, and
  empty-slide previous/next targeting.
- WPF adapter coverage proves the shared plan updates slide/comment selection
  without changing document dirty state.
- Avalonia headless coverage proves the registered ribbon commands execute the
  shared navigation path.

## Remaining Work

This does not close the broader modern-comments lane. Remaining depth includes
author identity integration, threaded-comment persistence beyond the currently
modeled legacy-compatible comment payloads, richer pane visual fidelity, and
PowerPoint-authored visual baselines.
