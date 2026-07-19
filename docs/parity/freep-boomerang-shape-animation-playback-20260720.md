# FreeP Boomerang Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Boomerang` was preserved and planned with its authored
direction, but both slideshow hosts executed it through the linear `FlyIn`
path. The effect therefore lacked its characteristic overshoot and return.

## Change

WPF and Avalonia now execute Boomerang as a direction-aware two-stage path.
Entrance playback travels from the planned offset beyond the destination and
settles back to the authored position; exit playback mirrors the same
overshoot outside the slide. Shared opacity, delay, and reveal timing remain
authoritative.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 1/1
- Avalonia `SlideShowHostPolicySourceTests`: 1/1
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic host playback correction. Exact PowerPoint motion-curve
parity still requires authoritative frame capture from PowerPoint COM.
