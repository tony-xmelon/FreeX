# FreeW Wave 61 grouped-child editing parity

## Scope

Wave 61 closes the Wave 52 residual for direct-child editing inside a transformed `DrawingGroup`. A selected child now uses group-local coordinates for move and resize gestures, while the owning group remains unchanged.

The shared model owns undoable child position and size commands. The shared presentation planner owns inverse group transforms, local move and resize geometry, transformed handle rectangles, and hit-testing. Avalonia routes pointer gestures and selection rendering through those helpers. The WPF host exposes the same child selection and command path for host parity and regression coverage.

## Verified behavior

- Child body movement maps screen deltas through the group rotation and flips before persisting `ChildOffsets`.
- Child resize maps transformed handles through the group and child transforms, persists child dimensions, and persists the local top-left adjustment for top/left handles.
- Selection remains on the child after command execution, with eight visible handles in transformed screen space.
- Undo restores child offset and size without changing the owning group.
- DOCX round-trip preserves exact local child geometry.
- Linux/X11 physical validation opens a transformed fixture, selects child 1, moves it, resizes its bottom-right handle, saves, and verifies the persisted DOCX with `DocxReader`.

## Commands and evidence

Run the focused tests with the commands recorded in the Wave 61 task report. Run the physical lane with:

```powershell
powershell -NoProfile -File tools/Run-FreeWWave61GroupedChildValidation.ps1
```

The wrapper writes the exact persisted geometry and screenshots under `freew/artifacts/wave61-linux/` and stops only the owned FreeW container when complete. The manifest is validated by `tools/LinuxInteractiveDocker/freew-group-child-validation.schema.json`.

## Residuals

Nested-child editing beyond a direct child remains outside this bounded Wave 61 slice. WPF does not have a separate Linux/X11 visual lane; its shared host command and selection state are covered by STA regression tests.
