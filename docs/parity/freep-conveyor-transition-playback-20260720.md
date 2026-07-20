# FreeP Conveyor Transition Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

Imported and authored `TransitionKind.Conveyor` was grouped with Gallery and
Window as `PushLike`, so it played as a rigid incoming cover/push rather than a
Dynamic Content belt exchange.

## Change

Conveyor now has a dedicated shared playback action. WPF and Avalonia move the
incoming and outgoing slide surfaces through the complete authored direction,
apply a small centered scale change, and add a 3-degree tilt plus an 8% lift
on the perpendicular axis to suggest the belt path. Gallery and Window remain
separate actions/fallbacks and are not changed by this slice.

## Verification

- `SlideShowPlaybackPlannerTests`: 43/43
- `SlideShowHostPlannerTests`: 68/68
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic 2-D playback approximation until authoritative
PowerPoint frame captures establish Conveyor's exact perspective, background
separation, and easing curve.
