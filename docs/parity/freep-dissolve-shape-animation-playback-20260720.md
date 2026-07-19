# FreeP Dissolve Shape-Animation Playback

Date: 2026-07-20
Branch: `codex/freep-parity-surface3d-shading-next-20260716`

## Finding

`AnimationPreset.Dissolve` was preserved by the package and resolved by the
shared planner, but WPF and Avalonia both executed it as a generic opacity
fade. The hosts already had a deterministic tile-order dissolve mask for
slide transitions, so the shape path was missing only its host consumption.

## Change

Shape-level Dissolve now uses the shared `BuildDissolveTransitionRects` mask at
the rendered element bounds. Entrance animations reveal tiles in the shared
order; exit animations reverse that order and finish at the planned opacity.
Existing delay and reveal-callback semantics remain intact, and slide-level
Dissolve behavior is unchanged.

## Verification

- Presentation mask/planner tests: 53/53
- WPF `SlideShowHostPolicySourceTests`: 2/2
- Avalonia `SlideShowHostPolicySourceTests`: 3/3
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
- `git diff --check`: passed
