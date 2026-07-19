# FreeP Swivel Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Swivel` was preserved in the package model and shared playback plan, but both slideshow hosts executed it through the flat `SpinEffect` path. The resulting playback had no depth cue and was indistinguishable from Spin.

## Change

WPF and Avalonia now use a bounded 2-D projection of a vertical-axis swivel. Rotation advances linearly through the planned 360 degrees while horizontal projection narrows to 4% at each edge-on quarter-turn and returns to full width at the half and final turns. The shared frame planner exposes the same `HorizontalScale` profile and includes it in evidence summaries; Spin and Spiral remain separate paths.

## Verification

- `SlideShowPlaybackPlannerTests`: 40/40
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

This is a renderer-neutral approximation until authoritative PowerPoint playback frames are captured; the exact PowerPoint 3-D perspective and easing curve remain an explicit follow-up rather than being implied by this no-COM slice.
