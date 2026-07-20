# FreeP Drape transition playback

## Scope

Drape is now mapped from `TransitionKind.Drape` to a shared playback action.
The planner emits segmented panels whose leading edge varies sinusoidally,
producing a stable draped wave-front in both WPF and Avalonia. The shared
four-point polygons preserve direction and timing across hosts.

This is a deterministic 2-D projection of the Drape silhouette; it does not
claim a full cloth or perspective-surface simulation.

## Verification

- Planner mapping and Drape geometry tests pass in the focused Presentation
  lane.
- WPF and Avalonia source guards cover the action, shared planner, and host
  geometry builders.
- No PowerPoint COM raster export was issued for this function-focused slice.
