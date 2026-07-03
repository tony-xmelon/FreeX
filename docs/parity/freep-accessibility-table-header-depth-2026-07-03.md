# FreeP Accessibility Checker Table Header Depth - 2026-07-03

Scope: bounded FreeP WPF/Avalonia parity slice for shared accessibility-checker depth. This avoids the recently integrated notes-page preview and review/comments action-button evidence areas.

## Added

- `PresentationReviewWorkflowPlanner` now flags tables whose header row is enabled but contains blank real header cells.
- The issue uses the shared accessibility-checker row model, so WPF and Avalonia panes inherit the same category, object selection behavior, and action summary.
- Merge-continuation cells are ignored by the blank-header check; the existing merged/split-cell diagnostic remains responsible for merge structure.

## Evidence

- `PresentationReviewWorkflowPlannerTests.BuildAccessibilitySummaryPlan_FlagsBlankTableHeaderCells` covers the shared issue descriptor and selectable checker-row projection.
- Existing table diagnostics still cover missing header-row metadata and merged/split table cells.

## Still Open

- Broader PowerPoint accessibility parity still needs grammar-scale proofing, richer comment/mention UI, deeper generated alt-text suggestions, and PowerPoint-authoritative review baselines.
