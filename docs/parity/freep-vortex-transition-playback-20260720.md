# FreeP Vortex transition playback

## Scope

Vortex is now mapped from `TransitionKind.Vortex` to a shared playback action.
The planner emits a growing center core plus rotated quadrilateral sectors,
creating a deterministic radial spiral reveal that WPF and Avalonia consume
through the same clip geometry.

This is a 2-D radial-spiral projection. It preserves the defining reveal
silhouette and direction without claiming a full deforming vortex mesh.

## Verification

- Planner mapping and Vortex geometry tests pass in the focused Presentation
  lane.
- WPF and Avalonia source guards cover the action, shared planner, and host
  geometry builders.
- No PowerPoint COM raster export was issued for this function-focused slice.
