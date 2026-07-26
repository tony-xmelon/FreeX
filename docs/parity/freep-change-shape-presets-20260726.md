# FreeP Change Shape Presets

FreeP's Arrange > Change Shape workflow now reaches Hexagon and 5-Point Star in
addition to Rectangle, Ellipse, Triangle, Diamond, and Right Arrow.

Both new entries use the existing shared `EditingSession.ChangeSelectedAutoShapeKind`
command. Text, authored frame geometry, undo/redo, and PPTX shape serialization stay
on the established path; no host-specific shape mutation was added.

The same presets are now registered in WPF and Avalonia and are covered by the
shared planner's route list, the Avalonia headless registry test, and the WPF
command-routing coverage.
