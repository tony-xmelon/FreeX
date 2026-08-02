# FreeW imported picture reflection alpha and distance

## Scope

Imported picture reflection start alpha and distance were retained in `ShapeEffectLst`, but both
hosts rendered only the nearest reflection preset values.

## Change

- Added a shared picture reflection visual plan.
- Imported reflections use `ReflectionStartAlpha` and `ReflectionDist` from the DrawingML payload.
- WPF uses the values for the first opacity-mask stop and reflection margin in inline and floating
  picture paths.
- Avalonia uses the same values for the fade mask, reflection rectangle, and flow-height
  reservation.
- Preset-only reflections retain their existing opacity and distance.
- The existing measured 13pt WPF object-format registration remains authoritative for its exact
  fixture signature.

Reflection transform, mask direction, end alpha, and fade positions are unchanged because those
remain compositor-sensitive visual work.

## Verification

- `PictureEffectVisualPlannerTests`: 18/18
- `FloatingImageRenderTests`: 26/26; WPF mask begins at 35% with a 4 DIP imported gap
- Avalonia `DocumentViewFloatingImageTests` plus `DocumentViewPictureRenderingTests`: 38/38

This is source-semantic and host-consumption evidence. No Word visual ROI is claimed.
