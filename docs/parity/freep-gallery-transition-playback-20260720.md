# FreeP Gallery Transition Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

Imported and authored `TransitionKind.Gallery` was grouped with Conveyor and
Window as `PushLike`, which ultimately played the same incoming-only cover
transition. Gallery therefore lost its two-surface exchange semantics at
playback time even though the package model preserved the kind.

## Change

Gallery now has a dedicated shared playback action. WPF and Avalonia start the
incoming slide as a centered 0.78x panel at the authored directional offset,
while the outgoing snapshot moves in the same direction and settles at 0.88x.
Both surfaces ease to the settled frame over the authored duration. Conveyor
and Window remain on their existing fallback path pending separate effect
models.

## Verification

- `SlideShowPlaybackPlannerTests`: 42/42
- `SlideShowHostPlannerTests`: 68/68
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic 2-D playback approximation until authoritative
PowerPoint frame captures establish Gallery's exact perspective and easing
curve.
