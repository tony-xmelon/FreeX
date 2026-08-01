# FreeP functional parity Wave 90

Date: 2026-08-01

## Selected gap

The highest-severity actual host asymmetry at HEAD was stale WPF canvas gesture
lifecycle after an editor rebuild. `FreeP.App.Host.MainWindow` rebinds the WPF
`SlideCanvas` on every New/Open through `SlideCanvas.AttachEditing`, but the WPF
`CanvasGestureHandler` had no teardown. Each rebind added another mouse, capture,
keyboard, and editor-change subscription, and each old handler also left its
selection adorner attached. A later pointer gesture could therefore be handled
by multiple WPF handlers and produce duplicate movement, transform, or undo
mutations against a rebuilt document.

This was a real WPF/Avalonia difference, not an aspirational feature gap:
Avalonia's `MainWindow.RewireInteractionToEditor` already disposes its prior
`AvaloniaCanvasGestureHandler` before constructing the replacement. The current
command inventory was 581/581 shared with zero actionable missing commands, the
dialog/pane inventory reported zero product gaps, and the committed whole-window
matrix was 33/33 paired passes, so those surfaces did not select the target.

## Closure

WPF `CanvasGestureHandler` now implements `IDisposable`. Disposal removes all
canvas and editor subscriptions, cancels an active gesture without committing it,
and removes the handler-owned selection adorner. `SlideCanvas.AttachEditing`
disposes the previous handler before binding the replacement `EditingSession`.
The shared gesture planner and command bus remain unchanged.

## Paired proof

- WPF `CanvasGestureHandler_Dispose_DetachesEditorSubscriptions` proves a
  disposed handler no longer refreshes from the old editor.
- WPF `AttachEditing_DisposesPreviousGestureHandler` proves the production WPF
  rebind path disposes the old handler and installs a distinct replacement.
- Avalonia `RebuiltEditor_DetachesStalePointerHandler_AndCapturesSelectedShape`
  proves the corresponding production host lifecycle: the stale handler does
  not consume the rebuilt document's pointer press, while the replacement does.

Focused verification:

```text
dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~CanvasEditingTests" --logger "console;verbosity=minimal"
42 passed, 0 failed

dotnet test freep\FreeP.App.Rendering.Avalonia.Tests\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~RebuiltEditor_DetachesStalePointerHandler_AndCapturesSelectedShape" --logger "console;verbosity=minimal"
1 passed, 0 failed

dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~CanvasGesturePlannerTests" --logger "console;verbosity=minimal"
16 passed, 0 failed

powershell -NoProfile -ExecutionPolicy Bypass -File tools\Generate-FreePCommandParityInventory.ps1 -Check
current: 581 shared, 0 actionable gaps

powershell -NoProfile -ExecutionPolicy Bypass -File tools\Generate-FreePDialogPaneParityInventory.ps1 -Check
current: 0 product gaps
```

The existing whole-window evidence remains unchanged at 33/33 paired passes;
this slice does not alter generated command, dialog/pane, or whole-window counts.

## Residuals

This closes the WPF editor-rebind gesture leak. It does not claim complete
physical pointer coverage for every WPF/Avalonia surface, PowerPoint-authoritative
visual parity, or native picker equivalence. The existing multi-selection preview
remains selection-chrome geometry rather than a duplicate filled-shape compositor
paint, and the broader documented PowerPoint baseline limitations remain open.
