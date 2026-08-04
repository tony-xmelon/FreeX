# FreeP Zoom Frame Border Patterns

Date: 2026-08-04

FreeP now supports authoring explicit DrawingML pattern borders for Zoom frames. The
supported hatch, stripe, percentage, and grid presets are represented by a shared
`ZoomFrameBorderPattern` model, persisted through native `a:pattFill` foreground and
background colors, undoable through the existing Zoom property command, and exposed
in both WPF and Avalonia authoring dialogs.

The WPF and Avalonia compositors consume the same pattern fill for frame pens while
preserving the existing solid, gradient, and dash behavior. Unsupported or malformed
native pattern payloads remain preserved as raw package content rather than being
silently rewritten. This slice is functionally verified; it does not claim a new
PowerPoint raster score.
