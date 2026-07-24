# FreeP shared shape edit-point planning

The presentation layer exposes a renderer-neutral edit-point plan for authored
`Chord` and `Rounded Rectangle` preset guides, plus imported custom-geometry
`MoveTo`/`LineTo` vertices and cubic/quadratic control points. Preset handles read
their DrawingML guide values and reduce drag positions back to the source units.
Custom handles map slide-space pointer positions back to each path's authored
coordinate space.

This gives WPF and Avalonia the same handle labels, positions, bounds, and
pointer-to-value conversion. Preset mutations use
`SetShapeGeometryAdjustmentCommand`; custom vertices use
`SetCustomGeometryPointCommand`, each as one undoable operation. Arc control
editing and insertion/deletion of vertices remain separate follow-up work.

Focused planner tests and the full FreeP Release build are the verification
gate for this functional slice. No visual calibration is included.
