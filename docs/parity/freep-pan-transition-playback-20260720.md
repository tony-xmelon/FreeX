# FreeP Pan Transition Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

Imported and authored `TransitionKind.Pan` was grouped with Gallery, Conveyor, and Window as `PushLike`, which ultimately played the same cover transition. Pan therefore lost its motion and scale semantics at playback time even though the package model preserved the kind.

## Change

Pan now has a dedicated shared playback action. WPF and Avalonia start the incoming slide at the authored direction offset with a 1.12x centered scale, then ease translation and scale back to the settled slide frame. The outgoing snapshot remains visible underneath until completion. Other `PushLike` transition families remain unchanged.

## Verification

- `SlideShowPlaybackPlannerTests`: 41/41
- `SlideShowHostPlannerTests`: 68/68
- WPF source guard: 1/1
- Avalonia source guard: 1/1
- WPF/Avalonia Release host builds: 0 warnings, 0 errors
- `git diff --check`: passed

This is a deterministic 2-D playback approximation until authoritative PowerPoint frame captures establish the exact Pan perspective and easing curve.
