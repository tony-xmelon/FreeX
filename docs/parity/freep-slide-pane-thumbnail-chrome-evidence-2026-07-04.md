# FreeP Slide Pane Thumbnail Chrome Evidence - 2026-07-04

Scope: bounded FreeP slide-pane observable visual parity slice after shared drop visual planning. This avoids command inventory, pointer foreground automation, PowerPoint baseline generation, and unrelated FreeP feature lanes.

## Starting Point

- `docs/parity/freep-slide-pane-reorder-evidence-2026-07-02.md` records shared drag-reorder planning and leaves richer thumbnail/section visual comparison open.
- `docs/parity/freep-new-slide-pane-affordance-evidence-2026-07-02.md` adds the Avalonia bottom `+ New Slide` affordance and leaves thumbnail chrome, grouping, and sorter-pane polish open.
- `docs/planning/freep-powerpoint-parity-status-2026-06-27.md` keeps PowerPoint-measured layout thumbnail rendering and slide-pane visual fidelity in the remaining FreeP backlog.

## Improvement

- `SlidePaneThumbnailVisualPlan` now carries shared pane background, normal/selected/hover item backgrounds, normal/selected item borders, thumbnail border, label foreground, corner radius, and border thickness values.
- WPF `SlidePane` consumes those shared thumbnail chrome tokens for pane background, label color, thumbnail border, normal/selected item chrome, hover feedback, and drop-indicator accent refresh.
- Avalonia `MainWindow` consumes the same shared thumbnail chrome tokens for pane background, label color, inner thumbnail item chrome, hover feedback, selection chrome refresh, rendered-plan evidence, and drop-indicator accent refresh.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/SlidePanePlannerTests.cs` pins the shared thumbnail chrome contract.
- `freep/FreeP.App.Host.Tests/SlidePaneTests.cs` verifies WPF selected/normal thumbnail chrome and label color use the shared planner tokens.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` verifies Avalonia projects the shared thumbnail chrome plan.
- `freep/FreeP.App.Avalonia.Tests/SlidePanePolicySourceGuardTests.cs` prevents Avalonia from drifting back to local thumbnail chrome constants.

## Remaining Gaps

- Foreground pointer evidence for Avalonia drag hover/drop behavior remains open.
- Section-header chrome, richer thumbnail rendering fidelity, grouping/sorter-pane polish, and PowerPoint-authoritative slide-pane visual baselines remain open.
