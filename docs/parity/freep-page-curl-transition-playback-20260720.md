# FreeP Page Curl transition playback

## Scope

`TransitionKind.PageCurlSingle` now maps to a dedicated shared playback
action. The incoming slide is rendered as the base surface while the outgoing
snapshot remains above it and is clipped by a direction-aware folded-page
polygon. The clip starts as the full page and narrows to an empty geometry,
with a center fold depth that preserves the page-turn silhouette.

WPF animates the shared clip polygons with discrete storyboard keyframes.
Avalonia applies the same polygons from a render-priority timer. Both hosts
restore the normal slide-layer ownership when the fold completes.

`TransitionKind.PageCurlDouble` now shares the same action and owns two
opposing fold polygons. It is intentionally modeled separately from the
single-fold geometry so the center reveal and two outgoing page wings remain
distinct.

## Verification

- `SlideShowHostPlannerTests` + `SlideShowPlaybackPlannerTests`: **130/130**
  compile-first and no-build.
- WPF and Avalonia Release application builds: **0 warnings, 0 errors**.
- WPF `SlideShowHostPolicySourceTests`: **2/2** compile-first and no-build.
- Avalonia `SlideShowHostPolicySourceTests`: **3/3** compile-first and no-build.
- Page Curl package/completeness coverage remains green.

No new PowerPoint COM raster export was required for this transition-function
slice.
