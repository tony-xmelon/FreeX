# FreeP pie and doughnut point explosion

FreeP now preserves PowerPoint's per-point `c:explosion` value for pie and doughnut charts through the presentation model and PPTX read/write path. The shared chart planner moves only the authored slice, and its data label, along the slice bisector; WPF and Avalonia consume the same planned center.

The slice is intentionally scoped to point-level pie/doughnut geometry. It does not change general chart spacing, palette, label, or 3-D rendering behavior.
