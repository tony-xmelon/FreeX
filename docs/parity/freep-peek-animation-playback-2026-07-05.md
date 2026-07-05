# FreeP Peek Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Peek approximation for imported preset animations.

## Scope

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Peek` to a renderer-neutral `SlideShowShapeAnimationEffectKind.Peek` plan.
- The shared plan carries deterministic direction-derived offset factors, duration, delay, and reveal timing.
- WPF and Avalonia slideshow hosts consume the shared plan through thin `PeekEffect` adapters that translate the shape overlay into place with a slide-sized clip.
- Focused planner and host source tests cover the shared plan and both renderer adapters.

## Limits

- Peek playback remains a deterministic translation/reveal approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, Peek, Plus, Strips, Wedge, and Wheel slices remains incremental.
