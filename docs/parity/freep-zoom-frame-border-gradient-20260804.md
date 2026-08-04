# FreeP Zoom Frame Border Gradient

## Functional slice

FreeP now supports the bounded two-stop linear gradient form used by native
PowerPoint Zoom frame borders. The shared `ZoomObjectProperties` projection
stores normalized start/end RGB colors and the DrawingML angle, while the
native `a:gradFill/a:gsLst/a:lin` payload remains the persistence authority.

WPF and Avalonia expose the same gradient toggle, two color fields, and angle
field in the existing Zoom Format dialog. The existing undoable Zoom command
updates single Zooms and Summary Zoom tiles together, and reopening the package
reconstructs the gradient projection. The shared compositor resolves the
gradient into the existing `ResolvedOutline.Gradient` path consumed by both
desktop renderers.

## Boundary

This slice intentionally supports two explicit RGB stops and a linear angle.
Pattern fills, theme-derived gradient stops, and line effects remain preserved
in native XML rather than being guessed into a different authoring state.

## Verification

- Shared planner/compositor gradient tests: 5/5.
- WPF Zoom package and host-contract tests: 5/5.
- Avalonia Zoom host-contract tests: 4/4.
- Release consuming WPF and Avalonia project graphs built without warnings or
  errors during the focused lanes.
