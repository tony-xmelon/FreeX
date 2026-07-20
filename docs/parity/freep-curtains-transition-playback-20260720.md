# FreeP Curtains transition playback

## Scope

Curtains is now mapped from `TransitionKind.Curtains` to a shared playback
action. The planner produces deterministic center-out panels with a bounded
pleat offset; WPF and Avalonia consume the same four-point polygons as native
clip geometries. Direction chooses the panel axis and opening orientation.

This is a shared 2-D projection of the Curtains silhouette. It preserves the
center reveal, sequencing, and direction without claiming a full 3-D cloth
simulation.

## Verification

- Planner mapping and Curtains geometry tests pass in the focused Presentation
  lane.
- WPF and Avalonia source guards cover the action, shared planner, and host
  geometry builders.
- No PowerPoint COM raster export was issued for this function-focused slice.
