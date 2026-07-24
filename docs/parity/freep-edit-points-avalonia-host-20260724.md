# FreeP Avalonia Edit Points host route

Avalonia now consumes the same shared preset-geometry edit-point plan as the
WPF canvas. The selection overlay projects planner handles into Avalonia
coordinates, the pointer handler reduces a drag in slide-DIP space, and the
release path commits one `EditingSession.SetShapeGeometryAdjustment` command.

The host exposes `SlideCanvas.EditPointsEnabled` and
`SlideCanvas.SetEditPointsMode(bool)`; `MainWindow` attaches the handler so the
mode is shared with the actual interaction surface. The initial supported
preset is `Chord` with `adj1` and `adj2` angle guides. Unsupported presets keep
their existing selection/resize behavior.

Headless Avalonia coverage validates edit-point hit testing; the shared planner
and command tests remain the authoritative geometry and undo gates.
