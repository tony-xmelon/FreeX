# FreeP Wave Animation Effect Options - 2026-07-29

The shared Animation Pane now exposes PowerPoint's horizontal and vertical
effect choices for the `Wave` emphasis preset.

The option mutation uses the existing `ShapeAnimation.Direction` command path,
so WPF and Avalonia share selection state, undo behavior, and PPTX persistence.
Wave direction round-trip coverage verifies the `horizontal` and `vertical`
PresentationML subtype values.

This slice is functional authoring parity. It does not claim a new playback
renderer; the existing shared slideshow planner already consumes the Wave
animation family.
