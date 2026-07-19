# FreeP Float Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Float` was preserved by the reader and shared playback
planner, but both slideshow hosts executed it through the linear `FlyIn` path.
That discarded the defining arcing motion of the Float effect while retaining
the authored direction, delay, opacity, and reveal contract.

## Change

WPF and Avalonia now give Float its own direction-aware arc. Entrance playback
starts at the planned directional offset, follows a shallow perpendicular arc,
and settles at the authored position; exit playback follows the mirrored path
outward. The shared plan remains authoritative for timing, opacity, and reveal
ownership. Swoop and Boomerang remain separate approximation paths for later
playback slices.

## Verification

- `SlideShowPlaybackPlannerTests`: 40/40
- WPF `SlideShowHostPolicySourceTests`: 1/1
- Avalonia `SlideShowHostPolicySourceTests`: 1/1
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed

Exact PowerPoint motion-curve parity still requires authoritative playback
frames; this slice removes the incorrect FlyIn collapse for Float.
