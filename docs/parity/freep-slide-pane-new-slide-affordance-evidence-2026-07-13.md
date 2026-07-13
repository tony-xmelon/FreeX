# FreeP Slide Pane New Slide Affordance Evidence - 2026-07-13

Scope: bounded no-COM FreeP WPF/Avalonia slide-pane parity slice for the bottom `+ New Slide` affordance. This follows the July 2 reorder evidence gap without expanding into foreground pointer capture, PowerPoint visual baselines, or broader sorter-pane polish.

## Starting Point

- `docs/parity/freep-slide-pane-reorder-evidence-2026-07-02.md` recorded that Avalonia still lacked the WPF bottom `+ New Slide` affordance after the shared slide-pane reorder work.
- Current `main` already had an Avalonia button shape, but WPF and Avalonia still owned local bottom-button insertion policy in renderer code.

## Improvement

- `SlidePanePlanner.BuildBottomNewSlideAffordance` now projects the renderer-neutral bottom-button text, tooltip, automation name, visibility, enablement, and insertion action.
- `SlidePanePlanner.TryApplyBottomNewSlideAffordance` applies the same shared insert-after-current-slide action used by the slide-pane action executor.
- WPF `SlidePane` and Avalonia `MainWindow` render the button from the shared plan and route clicks through the shared executor.

## Focused Evidence

- `freep/FreeP.App.Presentation.Tests/SlidePanePlannerTests.cs` covers the shared bottom-affordance plan and action execution.
- `freep/FreeP.App.Host.Tests/SlidePaneTests.cs` covers the WPF bottom button state and click route.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` covers the Avalonia visible bottom affordance and insertion behavior.
- WPF and Avalonia source guards pin both renderers to the shared planner/executor instead of local slide-pane insertion bodies.

## Remaining Deferred Work

- PowerPoint-authoritative visual baseline evidence for the slide-pane affordance still requires a COM-capable machine.
- Foreground pointer evidence and broader sorter-pane polish remain outside this no-COM slice.
