# FreeP Shape Geometry Authoring

FreeP now exposes an undoable semantic mutation for one DrawingML preset-geometry adjustment.
`EditingSession.SetShapeGeometryAdjustment` accepts an adjustment guide name and value, or
`null` to remove an authored guide and restore the preset default. The existing reader, shared
compositor, and writer already preserve and consume `PresetGeometryAdjustments`, so the mutation
flows through the normal save and reopen path without a host-specific geometry representation.

This is the model/command foundation for Edit Points. It intentionally does not claim a complete
interactive vertex adorner or arbitrary custom-path authoring yet; those remain separate UI and
custom-geometry work. Both setting a new guide and removing/restoring an existing guide are
covered by undo tests.
