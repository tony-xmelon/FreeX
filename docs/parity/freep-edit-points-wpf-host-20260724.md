# FreeP WPF Edit Points host route

The WPF slide canvas now consumes the shared preset-geometry edit-point plan.
Supported shapes expose their planner-provided handles through the selection
adorner; a pointer drag is reduced in slide-DIP coordinates and committed on
mouse-up through `EditingSession.SetShapeGeometryAdjustment`. That preserves
the existing command bus and makes each edit-point drag one undoable mutation.

The initial shared geometry is `Chord` (`adj1`/`adj2` angle guides). The host
mode is available through `SlideCanvas.EditPointsEnabled` and
`SlideCanvas.SetEditPointsMode(bool)`. Unsupported presets remain ordinary
selection/resize interactions until a shared geometry plan exists.

The canvas currently previews the dragged handle in the adorner; the shape
repaints after the command is committed. WPF host STA coverage validates handle
hit testing, mode routing, and the planner-to-command source boundary.
