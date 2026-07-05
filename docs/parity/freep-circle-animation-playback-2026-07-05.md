# FreeP Circle Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Circle approximation for imported preset animations.

Shared status:

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Circle` to renderer-neutral `SlideShowGeometricMaskKind.Circle` metadata with the same center-in/center-out direction semantics used by Diamond.
- WPF and Avalonia slideshow hosts consume that shared mask plan through thin geometric-mask adapters.
- WPF translates Circle to an animated ellipse clip; Avalonia rebuilds the matching ellipse clip during timer-driven playback.

Remaining blockers:

- Circle playback remains an approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, and Diamond slices remains incremental.
