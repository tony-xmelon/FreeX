# FreeP SmartArt Basic Matrix Live Layout - 2026-07-13

## Scope

This historical note was superseded by Wave 115. The current bounded layout
admission is for PowerPoint `basicMatrix` only; `matrix1` has no fixture/package
evidence in this app and stays on cached fallback.

The reader now classifies matrix layout IDs as `SmartArtFamily.Matrix` and
admits only `basicMatrix` into live layout. Unsupported matrix
siblings keep the cached `dsp:drawing` fallback path.

## Shared Behavior

- `SmartArtLayoutEngine` emits up to four parsed nodes as ordinary shared
  rectangle shapes in row-major quadrant order.
- Matrix layouts emit no connector ops.
- WPF and Avalonia consume the same compositor draw ops; no renderer-local
  SmartArt policy is introduced.

## Evidence

- `SmartArtLayoutTests` covers quadrant ordering, the four-node admission
  boundary, unsupported matrix fallback, and live compositor output over cached
  fallback.
- `SmartArtTests` builds synthetic PPTX fixtures proving `basicMatrix` imports
  as a live matrix-family layout while unsupported matrix siblings stay on
  cached fallback.

## Residual Limitations

The planner represents matrix SmartArt as renderer-neutral quadrant rectangles,
not exact PowerPoint variant styling. Matrix variants beyond `basicMatrix` and
`matrix1`, PowerPoint-authoritative visual baselines, and SmartArt
authoring/editing remain deferred.
