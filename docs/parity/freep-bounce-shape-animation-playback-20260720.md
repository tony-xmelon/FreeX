# FreeP Bounce Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Bounce` was preserved and planned as a distinct effect, but
both slideshow hosts executed it through the linear FlyIn path. That lost the
defining overshoot and rebound behavior.

## Change

WPF and Avalonia now use the planner's authored direction factors to animate a
damped bounce: the shape enters or exits along the direction, overshoots the
destination by 8%, rebounds by 4%, and settles at the planned endpoint. Opacity,
delay, and reveal timing remain driven by the shared playback plan. Float,
Swoop, and Boomerang remain separate approximation paths.

## Verification

- `SlideShowPlaybackPlannerTests`: 40/40
- WPF `SlideShowHostPolicySourceTests`: 2/2
- Avalonia `SlideShowHostPolicySourceTests`: 3/3
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed

Exact PowerPoint motion-curve parity still requires authoritative playback
frames; this slice removes the incorrect FlyIn collapse.
