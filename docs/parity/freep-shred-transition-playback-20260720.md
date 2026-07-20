# FreeP Shred transition playback

## Scope

Shred is now mapped from `TransitionKind.Shred` to a shared playback action.
The planner emits a stable interleaved set of horizontal or vertical
fragments, each with an alternating diagonal leading edge. WPF and Avalonia
consume the same four-point polygons as native clip geometries.

This is a deterministic 2-D projection of the Shred silhouette. It preserves
fragment order, direction, and torn-edge timing without claiming a full
particle or surface-fragment simulation.

## Verification

- Planner mapping and Shred geometry tests pass in the focused Presentation
  lane.
- WPF and Avalonia source guards cover the action, shared planner, and host
  geometry builders.
- No PowerPoint COM raster export was issued for this function-focused slice.
