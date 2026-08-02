# FreeP Wave106: Slide-Pane Selection Parity

Date: 2026-08-02
Scope: `freep/FreeP.App.Avalonia/MainWindow.cs` thumbnail pointer interaction

## Authority and residual

The WPF authority is `freep/FreeP.App.Host/SlidePane.cs`. Its left-button
thumbnail handler selects the clicked slide before it starts the shared drag
session. Avalonia already used the shared `SlidePanePlanner` for drag math, but
its pointer-press adapter only initialized the drag session and relied on the
`ListBox` default selection side effect.

That left click-and-hold behavior dependent on Avalonia control internals and
could leave the editor selection on the previous slide while drag evaluation
was already running for the clicked thumbnail.

## Change

Avalonia now explicitly calls `Editor.SelectSlide(sourceSlideIndex)` after
`SlidePanePlanner.BeginDragSession`, matching WPF ordering while leaving the
shared planner, context menus, sections, keyboard actions, and pointer capture
unchanged. Right-click behavior is unchanged because the route still exits
before this selection path unless the left button is pressed.

## Verification

- `SlidePanePolicySourceGuardTests` proves the Avalonia pointer adapter selects
  the source slide in the WPF-equivalent route after drag-session initialization.
- `MainWindowHeadlessTests` covers selection state immediately before drag
  planning and confirms the shared planner remains the move authority.
- Focused command: `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlidePane"`

Remaining FreeP slide-pane depth is outside this bounded interaction: richer
WPF thumbnail rendering and PowerPoint-backed thumbnail baselines still need a
COM-capable evidence machine, as recorded in the parity scope.
