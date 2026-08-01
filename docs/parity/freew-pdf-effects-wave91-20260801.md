# FreeW PDF effect fidelity, Wave 91

This slice improves the shared vector PDF effect result used by FreeW Avalonia export while
leaving the WPF raster path and the existing grouped visual transforms unchanged.

## Implemented

- Reflection data from `ShapeEffectLst` now reaches the PDF operation model: start/end alpha and
  positions, reflection/fade direction, blur radius, scale, and skew are preserved by the FreeW
  presentation planner and PDF export adapter.
- The Skia backend renders shadow, glow, and soft-edge passes through Skia image filters instead of
  translated silhouette passes. Reflection is rendered to a layer, transformed with the Office
  direction/scale/skew values, and composited through a directional start-to-end alpha mask.
- The portable backend keeps its dependency-free bounded fallback. Reflection uses six clipped,
  opacity-stepped bands and the same direction/scale/skew transform, so a portable PDF retains a
  visible fade cue without requiring a soft-mask or raster filter.
- Reflection operations remain nested inside the existing group rotation and clip operations, so
  grouped and ungrouped export use the same child geometry and transforms.

## Verification

- Shared PDF operation test proves the portable reflection fallback emits bounded fade bands and
  Office transform operators.
- Shared Skia pixel test proves a blurred soft-edge perimeter and a fading reflected tail.
- FreeW Avalonia PDF export test proves reflection parameters survive planner-to-operation mapping
  and both PDF writers still emit the document.

## Residuals

Portable PDF cannot express a true vector blur or arbitrary alpha soft mask with the current shared
resource model, so its effect fallback remains banded. Full material/3-D bevel geometry and exact
Office reflection alignment semantics remain outside this slice.
