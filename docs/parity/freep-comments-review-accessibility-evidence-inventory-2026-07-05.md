# FreeP Comments/Review Accessibility Evidence Inventory - 2026-07-05

## Scope

This slice promotes existing FreeP comments/review/accessibility workflow-depth
coverage into the generated command/evidence inventory and dashboard. It does
not change caption-authoring files, command classification policy, FreeW,
FreeX, PowerPoint COM baselines, or the generated WPF/Avalonia command surface.

## Added

- `tools/Generate-FreePCommandParityInventory.ps1` now emits generated workflow
  evidence rows for modern comments/review depth and review
  accessibility/proofing depth.
- The modern comments row ties together shared planner and host evidence for
  comment navigation, modern anchor and author identity preservation,
  mention/reply descriptors, thread filters, and resolved-thread action states.
- The accessibility/proofing row ties together shared planner and host evidence
  for accessibility checker row actions, table-header remediation, reading
  order action states, and proofing correction flows.
- The cross-app dashboard now stops listing modern comments/review as a generic
  remaining workflow-depth slice and reports the larger generated evidence
  count instead.

## Generated State

Before this slice, FreeP generated inventory state was 0 actionable WPF gaps,
0 actionable Avalonia gaps, 8 platform-only rows, and 3 workflow evidence rows.

After regenerating the FreeP inventory and cross-app dashboard, the command-gap
state remains 0 actionable WPF gaps, 0 actionable Avalonia gaps, and
8 platform-only rows. Workflow evidence rows increase to 5.

## Verification Evidence

- `freep/FreeP.App.Presentation.Tests/PresentationReviewWorkflowPlannerTests.cs`
  covers shared mention/reply descriptors, thread filters, accessibility
  checker rows, reading-order actions, and proofing corrections.
- `freep/FreeP.App.Host.Tests/ReviewWorkflowAdapterTests.cs` covers WPF host
  consumption of the same shared review planner.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers Avalonia
  headless comments pane, accessibility checker, reading-order, proofing, and
  comment mutation action paths.
- `freep/FreeP.App.Host.Tests/SectionsCommentsTests.cs` covers modern comment
  anchor/author/reply identity package preservation that feeds the shared
  review descriptors.

## Remaining Work

PowerPoint-authoritative review-pane visual baselines, people-picker mention
insertion, coauthor presence, notification routing, grammar-scale proofing,
richer remediation panes, and full reading-order visual parity remain separate
workflow-depth slices.
