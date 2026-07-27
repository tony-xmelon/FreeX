# FreeX picture context-menu crop parity, Wave 37

## Scope

The WPF picture context menu and Picture Format ribbon both enter live crop mode. Avalonia's
picture context-menu `Crop Picture` action incorrectly opened the numeric crop dialog, so pointer
users could not use the shared eight-handle crop interaction from that route.

## Evidence and fix

- WPF authority: `src/FreeX.App.Host/MainWindow.WorksheetContextMenu.cs` routes
  `WorksheetContextMenuAction.CropPicture` to `PictureCropBtn_Click`, which enters
  `EnterPictureCropMode`.
- Avalonia fix: `src/FreeX.App.Avalonia/MainWindow.DrawingObjectInteraction.cs` now routes the
  same action to the existing `BeginSelectedPictureCropMode` path used by the Picture Format ribbon.
- No shared planner or command changes were needed. Entering crop mode remains non-mutating; the
  existing `SetPictureCropCommand` is still created only when a crop drag is committed.

## Verification

- Avalonia `AvaloniaPictureCropRuntimeTests`: 2/2 passed, including the context-menu command-id
  dispatch and no-undo-entry assertion.
- WPF `DrawCommandSourceTests`: authority routing checks passed after the source assertion was
  corrected to avoid line-ending sensitivity.
