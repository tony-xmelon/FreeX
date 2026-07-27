# FreeX picture crop parity, Wave 36

## Scope

The Avalonia Picture Format `Crop Picture` entry previously only refreshed the status text. This
slice ports the WPF live crop-mode behavior through the existing shared planner and command paths.

## Authority and shared behavior

- WPF authority: `src/FreeX.App.Host/MainWindow.Drawing.cs` enters crop mode from
  `PictureCropBtn_Click`, resets through `SetPictureCropCommand`, and receives live crop updates in
  `OnPictureCropped`.
- Shared planner: `src/FreeX.App.Presentation/DrawingInteraction/PictureCropPlanner.cs` owns handle
  hit-testing, crop-ratio math, minimum visible area, and visible-rectangle mapping.
- Avalonia: `MainWindow.PictureShapeTabs.cs` enters crop mode; `MainWindow.cs` selects the crop
  adorner and routes Escape/selection changes; `MainWindow.DrawingObjectInteraction.cs` handles the
  pointer drag preview and commits `SetPictureCropCommand`.

## Evidence

- `AvaloniaPictureCropRuntimeTests` exercises the ribbon route, crop adorner, shared crop ratios,
  undoable command, and undo.
- `PictureCropPlannerTests` covers both-axis corner clamping and the existing eight-handle geometry.
- `DrawCommandSourceTests` verifies the WPF entry, focus/invalidation, reset, and shared command route.
