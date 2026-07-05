# FreeP Wheel Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Wheel approximation for imported preset animations.

Shared status:

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Wheel` to renderer-neutral `SlideShowGeometricMaskKind.Wheel` metadata with the same center-in/center-out direction semantics used by Circle, Diamond, Plus, and Wedge.
- `ShapeAnimation` retains valid imported PowerPoint Wheel spoke metadata, the PPTX writer emits it as a Wheel `animEffect` filter, and the shared planner forwards that value through `GeometricMaskSpokeCount`.
- The deterministic four-spoke Wheel approximation remains the fallback only when a PPTX/model does not provide a valid spoke count.
- WPF and Avalonia slideshow hosts consume that shared mask plan through thin geometric-mask adapters.
- WPF translates Wheel to deterministic centered radial spoke clip keyframes; Avalonia rebuilds the matching spoke clip during timer-driven playback.

Remaining blockers:

- Wheel playback remains visually approximate until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Diamond, Plus, Wedge, and Wheel slices remains incremental.
