# FreeP Picture Crop Handles

FreeP now exposes four interactive crop handles for a selected picture in both WPF and Avalonia.
The handles are planned from the picture frame and normalized source-crop fractions, so dragging
one edge preserves the opposing crop values and leaves a minimum visible source region.

The gesture previews the constrained handle position and commits one `SetPictureCropCommand` on
release. Undo/redo therefore treats a crop drag as one authoring action. Ribbon crop presets and
reset continue to use the same shared planner and command bus.

The shared planner contract is covered by edge-position, opposing-edge preservation, clamping,
non-picture rejection, and command undo/redo tests. Host source contracts verify that WPF and
Avalonia route the gesture through `PictureCropAuthoringPlanner` and `EditingSession.SetPictureCrop`.
