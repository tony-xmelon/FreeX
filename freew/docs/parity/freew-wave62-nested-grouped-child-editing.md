# FreeW Wave 62 nested grouped-child editing parity

Wave 62 closes the nested-child residual after Wave 61. A leaf at child path `0,1` can be selected, moved, and resized through the composed inner and outer DrawingGroup transforms. The shared command path changes only the leaf's local offset and size; neither the outer group nor the inner owning group is mutated.

## Coverage

- Shared model path resolution and undoable position/size/rotation commands support arbitrary child paths.
- Shared presentation planners compose child, inner-group, and outer-group transforms for body hit-testing, handles, move, and resize.
- WPF host selection and command routing recursively target a nested leaf.
- Avalonia selection, visible handles, pointer move, resize, rotate/flip state, and undo use the same path-aware contracts.
- DOCX persistence verifies exact nested leaf geometry and unchanged outer/inner geometry.
- The Linux/X11 physical fixture creates a nested document, captures baseline/selection/move/resize screenshots, saves DOCX, and verifies the saved geometry with `DocxReader`.

## Physical command

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeWWave62NestedGroupChildValidation.ps1 -Port 6092 -OutputDir freew/artifacts/wave62-linux
```

The physical lane is intentionally FreeW-specific and stops only its owned container. The completed run selects the nested leaf, moves it, resizes it from the transformed bottom-right handle, saves, and reopens the DOCX through `FreeW.Core.IO`. Exact inspection proves:

- outer placement/size/transform remain `180,150` / `240,150` pt / `22deg,flipH=False,flipV=False`;
- inner offset/size/transform remain `58,38` / `128,76` pt / `-17deg,flipH=False,flipV=True`;
- leaf path `0,1` moves from `34,21` pt to `68.31251968503938,7.438897637795276` pt;
- leaf size grows from `64,32` pt to `69.12858267716535,34.9048031496063` pt;
- leaf transform remains exactly `10deg,flipH=True,flipV=False`;
- `04-nested-child-resized-selected.png` shows the leaf ellipse with eight handles.

The retained physical evidence is under `freew/artifacts/wave62-linux-followup3/freew/sessions/20260730T015844322Z/nested-group-child-wave62/`, with the exact persisted-geometry manifest at `freew/artifacts/wave62-linux-followup3/freew-wave62-nested-group-child-validation.json`.

## Residuals

This slice does not add a separate WPF/X11 physical lane; WPF parity is covered by the managed host path and undo test. Other grouped-object residuals, if any, remain outside nested child selection/move/resize and should be treated as separate waves.
