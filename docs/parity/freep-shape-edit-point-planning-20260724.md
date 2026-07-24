# FreeP shared shape edit-point planning

The presentation layer now exposes a renderer-neutral edit-point plan for the
`Chord` preset shape. The plan reads the authored DrawingML `adj1` and `adj2`
angle guides, projects them onto the rendered ellipse bounds, and reduces a
drag position back to DrawingML angle units (`degrees * 60000`). The existing
`SetShapeGeometryAdjustmentCommand` remains the mutation and undo boundary.

This gives WPF and Avalonia the same handle labels, positions, bounds, and
pointer-to-value conversion. It intentionally supports only `Chord` today;
other presets report a disabled plan until their shared compositor geometry is
understood. Host adorner interaction still needs to consume this plan and
commit through the existing editing session command API.

Focused planner tests and the full FreeP Release build are the verification
gate for this functional slice. No visual calibration is included.
