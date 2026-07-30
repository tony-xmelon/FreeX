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

The physical lane is intentionally FreeW-specific and stops only its owned container. Its current run reaches the nested leaf selection and move stages and captures the corresponding screenshots, but the post-move transformed-handle coordinate still enters the outer-group resize path. The saved DOCX therefore reports this exact blocker:

- outer placement changed from `180,150` to `187.5,145.5` pt;
- inner offset/size remained `58,38` / `128,76` pt;
- leaf path `0,1` moved from `34,21` pt to `68.31251968503938,7.438897637795276` pt;
- leaf size remained `64,32` pt;
- `04-nested-child-resized-selected.png` shows outer-group handles rather than leaf handles.

The retained physical evidence is under `freew/artifacts/wave62-linux/freew/sessions/20260730T013154227Z/nested-group-child-wave62/`. The remaining physical residual is to derive the post-move bottom-right handle in the same document-surface coordinate space used by the X11 pointer and prove the resize/save postcondition without selecting the outer group. Managed WPF/Avalonia coverage and the exact DOCX round-trip test pass independently.

## Residuals

This slice does not add a separate WPF/X11 physical lane; WPF parity is covered by the managed host path and undo test. Other grouped-object residuals, if any, remain outside nested child selection/move/resize and should be treated as separate waves.
