# FreeP Comment Thread Filter Depth - 2026-07-04

## Scope

This comments/review workflow-depth slice adds shared comment-pane filter
evidence for FreeP WPF and Avalonia. It does not change command inventory,
dialog evidence, FreeW, or the already-integrated table-cell paragraph
alignment route.

## Improved

- `PresentationReviewWorkflowPlanner` now projects All/Open/Resolved/Mentions
  filter counts from the same shared comment pane plan used by both shells.
- Filtered planner calls remap visible selection to the filtered thread list
  while retaining original slide comment indexes for host actions.
- WPF and Avalonia render/expose the shared filter summaries as thin consumers
  of `PresentationCommentPanePlan`.

## Evidence

- Shared planner coverage proves all/open/resolved/mention filters, counts,
  labels, filtered selection remapping, and action enablement.
- WPF adapter coverage proves the shell exposes the shared filter states from
  the same review workflow plan.
- Avalonia headless coverage proves the comments pane exposes the same filter
  states alongside existing action-button evidence.

## Remaining

PowerPoint-authoritative visual baselines, people-picker mention insertion,
coauthor presence, and richer comment-pane chrome remain separate review-depth
work.
