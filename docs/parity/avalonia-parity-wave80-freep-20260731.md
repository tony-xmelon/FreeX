# FreeP Wave 80 Avalonia animation-pane toggle state parity

## Concrete gap

The WPF host routes the visible `freep.anim.pane` command through
`AnimationPaneToggleCommand`, an `IRibbonStatefulCommand` that exposes whether
the animation pane is checked/open. Avalonia routed every animation command,
including `freep.anim.pane`, through a stateless `ContextRibbonCommand`. The
pane could open and close, but the ribbon had no live checked-state contract.

## Fix

- Avalonia keeps the existing shared `PresentationAnimationCommandPlanner`
  toggle intent and uses a stateful host adapter for the pane command.
- The checked state reads the live Avalonia pane visibility, so direct pane
  show/hide workflows and ribbon execution agree.
- Opening and closing the pane synchronizes rendered ribbon toggle state.
- The existing headless animation workflow test now verifies initial unchecked
  state, checked state after opening, and unchecked state after closing.

## Verification

```text
dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~Ribbon_animation_commands_route_through_shared_planner"
Passed 1, Failed 0, Skipped 0, Total 1

dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~AnimationPane"
Passed 3, Failed 0, Skipped 0, Total 3
```

No Docker run was used. The isolated worktree did not contain a built WPF test
assembly for a no-build comparison run; the WPF command authority was reviewed
in `freep/FreeP.App.Host/FreePRibbonCommands.cs`.

## Residuals

This closes the animation-pane ribbon state mismatch. It does not claim full
FreeP functional parity, exact WPF visual fidelity, or parity with PowerPoint's
native animation playback and authoring engine.
