# FreeP imported Strips transition playback - 2026-07-19

## Scope

PresentationML already preserved `p:strips` transitions and their diagonal
direction, but slideshow playback routed `TransitionKind.Strips` through the
generic fade fallback. The shared mask planner already had the same diagonal
strip polygons used by imported shape animations; this slice connects that
neutral geometry to the transition playback path.

## Behavior

- `SlideShowTransitionPlanner` keeps `TransitionKind.Strips` as a dedicated
  playback kind and maps `ld`/`ru` to the descending strip slope used by the
  existing shape-animation route.
- `SlideShowPlaybackPlanner` exposes a dedicated `Strips` action and carries
  the slope through the host-neutral plan.
- WPF and Avalonia reveal the incoming slide through six shared diagonal
  polygons over a 30-frame timeline, then clear the clip at completion.
- The existing `SlideShowMaskGeometryPlanner.BuildStrips` implementation remains
  the single geometry owner; host code only converts polygons to native clip
  geometry.

## Verification

- Presentation planner/mask tests: `28/28`.
- WPF transition/source-policy tests: `119/119`.
- Avalonia transition/source-policy tests: `3/3`.
- Release builds for Presentation, WPF Host, and Avalonia: `0` warnings, `0`
  errors.

This is function parity for the imported transition route. PowerPoint frame
capture remains a separate visual-evidence task because transition playback is
time-dependent.
