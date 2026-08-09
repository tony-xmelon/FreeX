# FreeP Avalonia authored animation timing

## Scope

Avalonia live slideshow shape playback now consumes the authored acceleration
and deceleration values from `SlideShowShapeAnimationPlaybackPlan` through
`SlideShowPlaybackPlanner.ApplyTimingEasing`. The timing is threaded through
opacity, translation, motion paths, multi-stage motion, rectangular and
geometric clips, scale/rotation, keyframe, color, and emphasis effects.

Transition playback and the fallback slide-wide emphasis path retain their
existing cubic behavior because they do not have a shape timing plan.

## Verification

- Avalonia host Release build: 0 warnings, 0 errors.
- Avalonia slideshow host policy/source tests: 6/6.
- Focused authored-timing source contract: 1/1.
- Shared timing contracts: 2/2.

The source contract checks that the live shape region delegates timing to the
shared planner and contains no fixed `EaseInOut` call sites.
