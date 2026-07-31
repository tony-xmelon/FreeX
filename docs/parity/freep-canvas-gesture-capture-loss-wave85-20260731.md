# FreeP canvas parity wave 85: capture-loss cancellation

## Verified divergence

Avalonia already cancelled an active move/resize/rotate/geometry/marquee gesture when
pointer capture was lost. WPF had no `LostMouseCapture` route, so an interrupted drag could
retain its gesture state and later commit when a mouse-up arrived.

## Change and evidence

WPF now subscribes to `LostMouseCapture` and uses the same guarded reset as Avalonia. Both
renderers clear the active gesture, pending move/geometry state, and preview/snap visuals before
normal capture release can re-enter the handler. Paired runtime tests cover cancellation of a
pending resize in `FreeP.App.Host.Tests` and `FreeP.App.Rendering.Avalonia.Tests`.

The comparison also confirmed parity for live Alt/Shift modifiers through the shared move,
resize, and rotate planner; grouped-child hit selection through the shared hit tester; and
double-click text entry deferral. Escape currently cancels Format Painter in both hosts, while
active drag cancellation remains a separate follow-up.
