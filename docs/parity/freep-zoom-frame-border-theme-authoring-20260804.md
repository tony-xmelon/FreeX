# FreeP Zoom frame-border theme authoring

FreeP Zoom frame borders now preserve a theme color slot when authored through either desktop
dialog. The value is stored as `ZoomObjectProperties.FrameBorderThemeColor` and written as
DrawingML `a:solidFill/a:schemeClr`, so changing the presentation theme updates the border without
requiring a second object edit.

The slot is mutually exclusive with literal RGB, gradient, pattern, and no-fill states. Native
`schemeClr` values continue to be read from imported packages, while the shared compositor resolves
the model fallback against the live presentation theme. WPF and Avalonia expose the same checkbox
and slot list and route changes through the existing undoable Zoom-properties command.

This is a functional/source-authority slice. It makes no new raster-fidelity claim.
