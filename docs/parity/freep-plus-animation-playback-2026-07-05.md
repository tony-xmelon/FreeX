# FreeP Plus Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Plus approximation for imported preset animations.

Shared status:

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Plus` to renderer-neutral `SlideShowGeometricMaskKind.Plus` metadata with the same center-in/center-out direction semantics used by Circle and Diamond.
- WPF and Avalonia slideshow hosts consume that shared mask plan through thin geometric-mask adapters.
- WPF translates Plus to animated centered horizontal and vertical rectangle clips; Avalonia rebuilds the matching plus clip during timer-driven playback.

Remaining blockers:

- Plus playback remains an approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, and Plus slices remains incremental.
