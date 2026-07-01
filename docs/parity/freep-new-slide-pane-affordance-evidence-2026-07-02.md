# FreeP Slide Pane New Slide Affordance Evidence - 2026-07-02

Scope: bounded FreeP Avalonia workflow-depth slice after slide-pane reorder. This avoids slide-pane reorder semantics, alt-text, generated command inventory changes, FreeW, and FreeX files.

## Starting Point

- `docs/parity/freep-command-parity-inventory.md` reports 93 total FreeP commands, 87 shared commands, and 0 actionable WPF/Avalonia command gaps.
- `docs/parity/freep-slide-pane-reorder-evidence-2026-07-02.md` records slide-pane drag reorder as complete, and lists the missing Avalonia bottom `+ New Slide` affordance as a remaining workflow-depth gap.
- `docs/planning/freep-powerpoint-parity-status-2026-06-27.md` keeps slide-pane and editing parity in the remaining workflow-depth backlog.

## Improvement

- Avalonia now keeps a bottom-row slide-pane `+ New Slide` button outside the scrollable thumbnail list, matching the WPF pane affordance.
- The button text comes from `SlidePanePlanner.NewSlideButtonText`, so WPF and Avalonia share the visible label contract.
- The button routes through the same insertion workflow as the ribbon command by calling `Editor.InsertSlide()`, then the existing editor-change refresh path updates thumbnails, canvas, review workflow plans, and status.
- The insertion indicator remains over the thumbnail list only, so this slice does not alter the just-merged drag reorder behavior.

## Focused Evidence

- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers the visible button label, visibility, slide insertion, and slide-pane refresh count.
- `freep/FreeP.App.Avalonia.Tests/SlidePanePolicySourceGuardTests.cs` pins the shared planner label, bottom-row host placement, and insertion route.

## Remaining FreeP Workflow-Depth Gaps

- Avalonia slide-pane reorder still needs foreground pointer evidence and richer thumbnail/section visual comparison against WPF and PowerPoint.
- Slide thumbnails and section headers need deeper PowerPoint visual fidelity, including thumbnail chrome, grouping, and sorter-pane polish.
- Rich inline text/table editing parity, presenter recording/ink execution, modern comments/review UI, richer alt-text suggestions, reading-order workflows, proofing/accessibility execution, notes-page rendering, native print execution/preview, video export, and PowerPoint-authoritative visual baselines remain outside this slice.
