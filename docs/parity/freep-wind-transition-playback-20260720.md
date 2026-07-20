# FreeP Wind transition playback

## Scope

Wind is now mapped from `TransitionKind.Wind` to a shared playback action. The
planner produces eight direction-aware bands with staggered starts and a
skewed leading edge. WPF and Avalonia consume the same four-point polygons as
native clip geometries, so the visual ownership and timing remain aligned
across hosts.

This is a 2-D projection of the Wind silhouette. It preserves the authored
direction and staggered sweep without claiming PowerPoint's unavailable
surface-deformation implementation.

## Verification

- Planner mapping and Wind geometry tests pass in the focused Presentation lane.
- WPF and Avalonia source guards cover the action, shared planner, and host
  geometry builders.
- No PowerPoint COM raster export was issued for this function-focused slice.
