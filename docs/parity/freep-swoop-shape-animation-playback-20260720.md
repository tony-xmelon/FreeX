# FreeP Swoop Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Swoop` was preserved and planned with its authored direction,
but both slideshow hosts executed it through the linear `FlyIn` path. The
effect identity therefore had no visible playback consequence.

## Change

WPF and Avalonia now execute Swoop with a deeper direction-aware sweeping arc:
the shape begins at the planned directional offset, crosses a perpendicular
midpoint at 55% of the duration, and settles at the authored position. Exit
effects mirror that path outward. Shared opacity, delay, and reveal timing
remain authoritative; Float and Boomerang retain their own routes.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 1/1
- Avalonia `SlideShowHostPolicySourceTests`: 1/1
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic host playback correction. Exact PowerPoint motion-curve
parity still requires authoritative frame capture from PowerPoint COM.
