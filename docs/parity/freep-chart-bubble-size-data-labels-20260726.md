# FreeP Chart Bubble-Size Data Labels

Date: 2026-07-26

PowerPoint chart data labels can include the size dimension for bubble charts. FreeP now
preserves and exposes that option at chart, series, and selected-point scope in both WPF and
Avalonia.

- `c:showBubbleSize` is read and written in schema order and survives PPTX round-trip.
- The shared chart display, series, and point planners expose one undoable authoring path for
  the option, with matching WPF and Avalonia controls.
- The shared renderer formats each bubble label from the corresponding `BubbleSizes` datum,
  using the authored label number format when present.
- Clone and undo paths retain the option without changing unrelated label components.

This slice establishes functional/package parity. PowerPoint-authoritative raster baselines for
bubble-size label typography and placement remain a separate visual-fidelity gate.
