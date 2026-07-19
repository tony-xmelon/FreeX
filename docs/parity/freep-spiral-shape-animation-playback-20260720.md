# FreeP Spiral Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Spiral` was preserved in the model and shared playback plan, but both hosts executed it through the linear `SpinEffect` path. Spiral and Spin were therefore visually identical during playback.

## Change

WPF and Avalonia now use a distinct two-phase Spiral rotation: 82% of the planned rotation is reached by 70% of the animation, then the remaining angle settles during the final 30%. The shared `SlideShowPlaybackFramePlanner` mirrors that profile so host playback and evidence frames agree. Spin and Swivel retain their separate paths.

## Verification

- `SlideShowPlaybackPlannerTests`: 40/40
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

Exact PowerPoint motion-curve parity still requires authoritative COM frame capture; this slice establishes the distinct Spiral behavior and keeps the curve calibration isolated.
