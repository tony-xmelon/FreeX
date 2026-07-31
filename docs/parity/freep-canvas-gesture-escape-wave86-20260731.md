# FreeP canvas parity wave 86: Escape gesture cancellation

## Scope

This slice aligns the WPF and Avalonia canvas gesture lifecycle for Escape while preserving
the existing Format Painter Escape behavior. It covers active move, resize, rotate, preset
geometry-edit, and marquee gestures.

## Implementation

- `CanvasGesturePlanner.ResolveEscapeAction` is the shared Escape precedence decision:
  Format Painter cancels first, an active canvas gesture cancels second, and an unrelated
  Escape remains unhandled.
- WPF and Avalonia now share the same completion/cancellation shape. Cancellation clears
  the active gesture, drag and operation state, pending move/geometry state, preview,
  marquee, geometry-preview, and snap-guide visuals before releasing pointer/mouse capture.
- A stale mouse/pointer-up after Escape runs through the normal completion path with no
  active gesture and cannot issue a model command.
- Capture-loss cancellation remains separate and does not try to recapture an already
  released pointer.

## Runtime evidence

The paired tests seed an active resize plus all transient interaction visuals, send Escape,
then deliver a stale release. Both hosts prove that the gesture and pending state are clear,
all transient visuals are clear, the shape is unchanged, and the command bus has no undo
entry.

Verified commands:

```text
dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~CanvasGesturePlannerTests --logger "console;verbosity=minimal"
13 passed, 0 failed

dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~GestureHandler_ --logger "console;verbosity=minimal"
4 passed, 0 failed

dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~GestureHandler_ --logger "console;verbosity=minimal"
3 passed, 0 failed
```

The paired Escape tests are included in the two `GestureHandler_` results above. The initial
Avalonia run exposed and corrected only a fixture expectation; the implementation then passed
the same test in both hosts.

## Residuals

This slice does not add live Docker or desktop automation coverage. The existing broader FreeP
canvas gaps remain outside this change, including active-drag Escape behavior in text-editing
surfaces and deeper PowerPoint-authoritative visual evidence for advanced drawing families.
