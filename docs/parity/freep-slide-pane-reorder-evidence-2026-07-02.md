# FreeP Slide Pane Reorder Evidence - 2026-07-02

Scope: bounded FreeP WPF/Avalonia workflow-depth slice for slide-pane editing parity. This avoids command-inventory rows, layout-picker evidence, comments pane evidence, alt-text, FreeW, and FreeX files.

## Starting Point

- `docs/parity/freep-command-parity-inventory.md` reports 93 total FreeP commands, 87 shared, and 0 actionable WPF/Avalonia command gaps, so this slice does not chase command rows.
- `docs/parity/2026-06-27-avalonia-wpf-parity-scope.md` identifies slide-pane/editing depth as the next FreeP parity area after command-profile parity, with WPF owning drag reorder and Avalonia carrying a simpler list surface.
- `docs/planning/freep-powerpoint-parity-status-2026-06-27.md` keeps slide-pane/editing parity in the remaining workflow-depth backlog.

## Improvement

- Avalonia slide thumbnails now wire pointer press/move/release/capture-lost handlers on each slide-pane item.
- Drag feedback is visible through an overlaid FreeP-accent insertion indicator on the Avalonia slide pane.
- Reorder semantics remain shared: Avalonia computes target insertion points with `SlidePanePlanner.HitTestInsertionPoint`, positions feedback with `SlidePanePlanner.ComputeInsertionIndicatorOffset`, and applies drops through `SlidePanePlanner.PlanMoveAction` plus `SlidePanePlanner.TryApplyAction`.
- Focused guards prevent `FreeP.App.Avalonia.MainWindow` from drifting back to local duplicate/delete/move command bodies.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/SlidePanePlannerTests.cs` now covers shared move-action application and selection preservation.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` now covers the Avalonia slide-pane adapter route by moving the first of three slides after the last slide through the same helper used by pointer drop.
- `freep/FreeP.App.Avalonia.Tests/SlidePanePolicySourceGuardTests.cs` now pins Avalonia to the shared slide-pane planner for projection, context menus, drag hit testing, insertion feedback, and move planning.

## Remaining FreeP Workflow-Depth Gaps

- Avalonia slide-pane reorder still needs foreground pointer evidence and richer thumbnail/section visual comparison against WPF and PowerPoint.
- The WPF/Avalonia bottom `+ New Slide` affordance gap is addressed by `docs/parity/freep-slide-pane-new-slide-affordance-evidence-2026-07-13.md`; broader sorter-pane polish remains.
- Rich inline text/table editing parity, presenter recording/ink execution, modern comments/review UI, full rendered alt-text pane UX, proofing/accessibility execution, and PowerPoint-authoritative visual baselines remain outside this slice.
