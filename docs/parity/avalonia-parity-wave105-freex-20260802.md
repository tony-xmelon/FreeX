# FreeX Avalonia parity Wave 105

Date: 2026-08-02

## Residual selected

The source audit compared the concrete WPF `SheetGrid_MouseWheel` route, the Avalonia
`SheetScrollViewer_PointerWheelChanged` route, their shared viewport planning, and the
platform-specific input boundary. WPF preserves a raw mouse-wheel delta of 240 as two
notches through `WorkbookViewportScrollPlanner.NormalizeWheelNotches`. Avalonia instead
converted every nonzero `PointerWheelEventArgs.Delta` component to `+1` or `-1` before
calling `PanViewport`.

That was a functional residual for Linux high-resolution wheel and touchpad devices that
coalesce multiple logical notches into one Avalonia pointer event: the worksheet moved one
wheel step even when the event carried three. The loss was observable in the production
worksheet route, not only in generated command metadata.

## Fix

`WorkbookViewportScrollPlanner` now exposes `NormalizePointerWheelNotches`, retaining the
whole pointer-delta magnitude while preserving a signed one-notch result for sub-notch
input. Avalonia uses that shared result for vertical, horizontal, Shift-wheel, and
Ctrl-wheel zoom routes. WPF remains the authority for native 120-unit mouse-wheel input
through its existing thin `ViewportScrollCalculator` facade.

Focused tests cover the shared normalization, WPF facade delegation, Avalonia source
consumption, and a real Avalonia headless worksheet event comparing one and three coalesced
pointer notches.

## Remaining boundary

Avalonia still uses the cross-platform default of three rows or columns per logical notch
on Linux because Linux desktop wheel-line preferences are not exposed by the current host
boundary. WPF continues to read the Windows system wheel-line setting and maps its
one-screen sentinel using the native scrollbar viewport. This wave closes delta-magnitude
loss only; it does not claim identical OS preference discovery or native toolkit scrolling
physics.
