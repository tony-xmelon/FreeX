# FreeP Wheel Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Wheel approximation for imported preset animations.

Shared status:

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Wheel` to renderer-neutral `SlideShowGeometricMaskKind.Wheel` metadata with the same center-in/center-out direction semantics used by Circle, Diamond, Plus, and Wedge.
- The current imported animation model does not retain PowerPoint's `spokes` attribute, so the shared planner uses a deterministic four-spoke Wheel approximation.
- WPF and Avalonia slideshow hosts consume that shared mask plan through thin geometric-mask adapters.
- WPF translates Wheel to deterministic centered radial spoke clip keyframes; Avalonia rebuilds the matching spoke clip during timer-driven playback.

Remaining blockers:

- Wheel playback remains an approximation until PowerPoint COM visual baselines are available on a COM-capable machine and imported spoke metadata is retained.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, Plus, Wedge, and Wheel slices remains incremental.
