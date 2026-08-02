# FreeP Motion-Path Arc-Length Timing

## Scope

FreeP slideshow motion paths now allocate playback progress by measured path
length instead of giving every line or cubic segment the same duration. This
matches the authored `p:animMotion` path contract more closely: a short segment
no longer consumes the same time as a much longer segment.

The change is shared by WPF and Avalonia because both hosts consume
`SlideShowPlaybackPlanner` keyframes generated from `MotionPathEvaluator`.
Line segments use exact Euclidean length; cubic segments use a bounded
64-sample arc-length approximation and interpolate within the measured samples.
Move and close commands remain non-drawing path controls.

## Verification

- `MotionPathTriggerTests`: non-uniform line and cubic/line sampling regressions.
- Existing motion-path package round-trip and trigger tests remain in the same
  focused host test lane.
- WPF and Avalonia consume the same planner output; no host-local timing policy
  was added.
