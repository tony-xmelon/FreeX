# FreeP Picture Crop Authoring

FreeP already retained `a:srcRect` crop fractions in `PictureFormat` and both host renderers
consumed them. This slice closes the shared editing boundary: `PictureCropAuthoringPlanner`
validates source-edge fractions, `EditingSession.SetPictureCrop` applies them through
`SetPictureCropCommand`, and the command bus provides one undoable edit per crop operation.

Existing picture color effects remain attached to the same `PictureFormat`; resetting crop does
not discard them. A later host slice can bind the same shared operation to interactive crop
handles or a numeric dialog without changing the model or undo contract.

Verification: `PresentationCommandTests` and `PictureCropAuthoringPlannerTests`, 74 passed.
