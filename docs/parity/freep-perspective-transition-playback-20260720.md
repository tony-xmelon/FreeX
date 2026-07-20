# FreeP perspective transition playback

## Scope

FreeP now maps `TransitionKind.Flip`, `Cube`, `Rotate`, `Switch`, `Orbit`, and
`Ferris` to dedicated renderer-neutral playback actions. The shared
`SlideShowPerspectiveTransitionPlanner` preserves direction and chooses a
host-neutral projection:

- Flip: near-edge-on scale collapse on the travel axis.
- Cube: stronger axis collapse, 90-degree rotation, and a short travel factor.
- Rotate: reduced uniform scale with a 90-degree rotation and short travel.
- Switch: reduced uniform scale with a 90-degree directional exchange.
- Orbit: deeper scale reduction with a 180-degree orbit projection.
- Ferris: a lighter rotating-panel projection with shorter travel.

WPF uses centered `ScaleTransform`/`RotateTransform`/`TranslateTransform`
storyboard groups. Avalonia uses the corresponding centered matrix transforms
and timer-driven interpolation. Both hosts animate an outgoing snapshot in
the opposite direction and restore the live slide surface on completion.

This is a faithful 2-D projection boundary, not a claim of PowerPoint's full
3-D camera, face shading, or perspective distortion. The remaining extended
transition kinds still use the shared fade fallback until their visual
semantics have a suitable surface model.

## Verification

- `SlideShowHostPlannerTests` + `SlideShowPlaybackPlannerTests`: **127/127**
  compile-first and no-build.
- WPF and Avalonia Release application builds: **0 warnings, 0 errors**.
- WPF `SlideShowHostPolicySourceTests`: **2/2** compile-first and no-build.
- Avalonia `SlideShowHostPolicySourceTests`: **3/3** compile-first and no-build.
- `TransitionCompletenessTests`: **124/124** in the focused transition and
  host-policy filter.
- `git diff --check`: passed.

No new PowerPoint COM export was required for this playback-function slice;
the next parity pass should validate the frame projection against a COM
capture when the transition corpus is available.
