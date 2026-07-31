# FreeP parity wave 83: double-click selection

## Scope

FreeP authoring interaction between the WPF and Avalonia canvas gesture handlers.

## Divergence

Avalonia returned from every double-click that was not handled as OLE or Zoom. On a
textless shape this prevented the normal hit-test and selection/move path from running,
while WPF continued into that path. Text-bearing shapes must remain available to the
in-canvas text editor.

## Fix

Both handlers now use the same deterministic policy: textless shapes continue through
normal selection, and text-bearing shapes defer to the text editor. OLE and Zoom keep
their existing higher-priority double-click actions.

## Evidence

- `freep/FreeP.App.Rendering.Avalonia/AvaloniaCanvasGestureHandler.cs`
- `freep/FreeP.App.Rendering.Wpf/CanvasGestureHandler.cs`
- Paired `DoubleClickPolicy_TextlessShapesContinueSelection_TextShapesDeferToEditor`
  tests in the Avalonia rendering and WPF host test projects.
