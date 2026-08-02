# FreeW imported picture reflection fade stops

## Scope

The picture reflection payload retained DrawingML `stA`, `stPos`, `endA`, and `endPos`, but both
hosts always rendered a preset mask from 50% or 100% at position 0 to transparent at position 1.

## Change

- The shared picture reflection plan now carries both authored alpha values and both normalized
  stop positions.
- WPF applies those values to the existing two-stop `OpacityMask`.
- Avalonia applies the same values to its existing two-stop opacity mask.
- Preset-only reflections retain their prior start alpha and 0-to-1 fade.
- Reflection transform orientation, scale, skew, and alignment remain unchanged.

## Verification

- `PictureEffectVisualPlannerTests`: 18/18, including imported 35%@0.2 to 10%@0.8 and preset
  controls
- `FloatingImageRenderTests`: 26/26; both WPF gradient-stop alpha and offset values asserted
- Avalonia `DocumentViewFloatingImageTests` plus `DocumentViewPictureRenderingTests`: 38/38

This is source-semantic and host-consumption evidence. No Word visual ROI is claimed.
