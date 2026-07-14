# FreeP scatter smooth render planning - 2026-07-14

## Scope

This slice closes a bounded chart-fidelity gap for PowerPoint-authored scatter
charts that use smooth lines (`c:scatterStyle` values `smooth` or
`smoothMarker`) or per-series `c:smooth` decisions.

## Implementation

- `ChartRenderPlanner` now emits shared scatter line path figures alongside the
  existing point slots, straight line segments, markers, axes, and labels.
- Smooth scatter series use the same renderer-neutral cubic path approximation
  as smoothed line charts. Explicit per-series `SmoothLine = false` keeps that
  series straight even when the chart-level scatter style is smooth.
- WPF and Avalonia scatter rendering consume the shared path figures, so the
  smooth/straight decision is no longer duplicated in platform drawing code.

## Limits

This is a no-COM, bounded fidelity guard. It does not claim exact PowerPoint
curve-tension parity or add bitmap baselines for authored scatter decks. Those
remain follow-up work once authoritative PowerPoint render evidence is available.
