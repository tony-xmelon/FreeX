# FreeP Comment Mention Detail - 2026-07-04

## Scope

This comments/review workflow-depth slice keeps the work inside FreeP shared
review planning and focused FreeP tests. It does not change command inventory,
dialog evidence, FreeW inventory, or the cross-app dashboard.

## Improved

- `PresentationReviewWorkflowPlanner` now emits renderer-neutral mention
  descriptors for comment roots and replies, including mention offsets, labels,
  display text, and normalized identity keys.
- Existing comment-pane counts and summaries remain intact, while WPF and
  Avalonia consumers can now render or inspect exact mention chips from the same
  shared plan instead of reparsing pane text locally.
- Focused planner and WPF host-adapter tests cover root-comment and reply
  mentions flowing through `PresentationCommentDescriptor` and
  `PresentationCommentReplyDescriptor`.

## Remaining

- Rich PowerPoint-style mention insertion UI, people-picker integration,
  notification routing, and coauthor presence remain deferred.
- PowerPoint-authoritative review-pane visual baselines still require a
  COM-capable machine.
