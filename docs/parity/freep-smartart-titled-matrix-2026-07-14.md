# FreeP SmartArt Titled Matrix Live Layout - 2026-07-14

## Scope

This slice admits PowerPoint `titledMatrix` SmartArt imports into the existing
bounded matrix-family live-layout path.

The reader now classifies `titledMatrix` as `SmartArtFamily.Matrix` and marks it
live only through the explicit allowlist. Other matrix-family siblings remain on
the cached `dsp:drawing` fallback path until their geometry is owned.

## Shared Behavior

- `SmartArtLayoutEngine` emits up to four parsed nodes as ordinary shared
  rectangle shapes in row-major quadrant order.
- `titledMatrix` uses the same renderer-neutral matrix-family plan as
  `basicMatrix`, with no connector ops and no renderer-local SmartArt policy.
- WPF and Avalonia consume the same compositor draw ops and the same fallback
  policy for unsupported matrix siblings.

## Evidence

- `SmartArtLayoutTests` covers `titledMatrix` quadrant ordering, live compositor
  output over cached fallback, and fallback preservation for an unsupported
  matrix sibling.
- `SmartArtTests` builds synthetic PPTX fixtures proving `titledMatrix` imports
  as a live matrix-family layout while an unsupported matrix sibling stays on
  cached fallback.

## Residual Limitations

The planner represents `titledMatrix` as renderer-neutral quadrant rectangles,
not exact PowerPoint title-band geometry or variant styling.
PowerPoint-authoritative visual baselines, richer SmartArt matrix variants, and
SmartArt authoring/editing remain deferred.
