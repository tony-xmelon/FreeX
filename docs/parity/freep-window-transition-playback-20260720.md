# FreeP Window Transition Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

Imported and authored `TransitionKind.Window` was grouped with Conveyor and
Gallery as `PushLike`, so it played as a directional incoming cover rather than
opening the new slide through a centered window.

## Change

Window now has a dedicated shared playback action. WPF and Avalonia start the
incoming slide at a centered 18% aperture with a 0.92x scale, then expand the
aperture and scale to the settled frame over the authored duration. The
existing Box transition remains a separate full-range centered rectangle.

## Verification

- `SlideShowPlaybackPlannerTests`: 44/44
- `SlideShowHostPlannerTests`: 68/68
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic 2-D playback approximation until authoritative
PowerPoint frame captures establish Window's exact aperture geometry, layering,
and easing curve.
