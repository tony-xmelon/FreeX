# FreeP Strips Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Strips approximation for imported preset animations.

## Scope

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Strips` to renderer-neutral `SlideShowGeometricMaskKind.Strips` metadata.
- The shared plan carries deterministic strip count and diagonal orientation metadata from the imported animation direction.
- WPF and Avalonia consume that metadata through their existing geometric-mask playback paths and build native diagonal strip clip geometry.
- Focused planner and host source tests cover the shared plan and both renderer adapters.

## Limits

- Strips playback remains a deterministic approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, Plus, Strips, Wedge, and Wheel slices remains incremental.
