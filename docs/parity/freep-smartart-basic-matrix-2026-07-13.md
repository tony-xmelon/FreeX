# FreeP SmartArt Basic Matrix Live Layout - 2026-07-13

## Scope

This slice adds bounded no-COM geometry evidence for PowerPoint `basicMatrix`
and `matrix1` SmartArt imports.

The reader now classifies matrix layout IDs as `SmartArtFamily.Matrix` and
admits only `basicMatrix`/`matrix1` into live layout. Unsupported matrix
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
