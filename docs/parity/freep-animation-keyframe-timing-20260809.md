# FreeP Keyframe Timing Parity

Date: 2026-08-09

## Function slice

FreeP's shared playback timing policy already applies to WPF scalar
`DoubleAnimation` timelines. Multi-phase effects use WPF
`DoubleAnimationUsingKeyFrames`, which has no timeline-level easing property and
previously bypassed the same authored acceleration/deceleration policy.

The shared planner now exposes the monotonic inverse of its host timing curve.
WPF retimes only percentage `DoubleKeyFrame` positions through that inverse,
preserving authored values, keyframe kinds, splines, and discrete steps. Avalonia
continues to consume the shared timing policy directly from its frame loop.

## Verification

- `SlideShowPlaybackPlannerTests`: 105/105.
- WPF `SlideShowHostPolicySourceTests`: 5/5.
- Avalonia `SlideShowHostPolicySourceTests`: 7/7.
- WPF consuming Release test build: 0 warnings, 0 errors.
- Avalonia consuming Release build: 0 warnings, 0 errors.

This is a playback-semantics change; no slide geometry or raster calibration is
claimed.
