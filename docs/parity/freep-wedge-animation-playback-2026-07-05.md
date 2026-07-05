# FreeP Wedge Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Wedge approximation for imported preset animations.

Shared status:

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Wedge` to renderer-neutral `SlideShowGeometricMaskKind.Wedge` metadata with the same center-in/center-out direction semantics used by Circle, Diamond, and Plus.
- WPF and Avalonia slideshow hosts consume that shared mask plan through thin geometric-mask adapters.
- WPF translates Wedge to deterministic centered radial sector clip keyframes; Avalonia rebuilds the matching wedge clip during timer-driven playback.

Remaining blockers:

- Wedge playback remains an approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, Plus, and Wedge slices remains incremental.
