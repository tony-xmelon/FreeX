# FreeP Flash Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Flash` was already preserved by the package reader and
resolved by the shared playback planner, but both slideshow hosts executed
the effect through the generic `FadeEffect` path. That made a valid Flash
animation behaviorally indistinguishable from Fade at runtime.

## Change

WPF and Avalonia now use a dedicated Flash opacity waveform. Entrance and exit
animations preserve the authored delay and reveal timing while stepping through
`0/1 -> 0.7 -> 0.35 -> 1/0`, giving the object a brief flash before settling at
its planned final opacity. Other animation presets and the shared model are
unchanged.

## Verification

- `SlideShowPlaybackPlannerTests`: 40/40
- WPF `SlideShowHostPolicySourceTests`: 2/2
- Avalonia `SlideShowHostPolicySourceTests`: 3/3
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed

This is a functional playback slice; static slide PNGs are unchanged by the
runtime-only animation path.
