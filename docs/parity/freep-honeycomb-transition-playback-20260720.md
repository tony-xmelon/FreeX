# FreeP Honeycomb transition playback

## Scope

`TransitionKind.Honeycomb` now maps to a dedicated shared playback action.
`SlideShowHoneycombTransitionPlanner` emits a deterministic, direction-aware
field of six-point cells. Each cell opens over a short staggered window and
grows to its full hexagon, producing a tiled honeycomb reveal of the incoming
slide.

WPF animates the shared polygon set through `ObjectAnimationUsingKeyFrames`.
Avalonia uses the same polygons with a render-priority timer. Both hosts keep
the outgoing snapshot behind the clipped incoming surface and clear the clip
at completion.

This is a 2-D tiled reveal projection. It does not claim PowerPoint's more
specialized lighting, depth, or 3-D camera behavior for the other exciting
transitions.

## Verification

- Honeycomb planner/action and hex-cell determinism tests are included in the
  focused Presentation planner lane.
- WPF and Avalonia Release application builds: **0 warnings, 0 errors**.
- WPF `SlideShowHostPolicySourceTests`: **2/2** compile-first and no-build.
- Avalonia `SlideShowHostPolicySourceTests`: **3/3** compile-first and no-build.
- `git diff --check`: passed.

No new PowerPoint COM export was required for this transition-function slice.
