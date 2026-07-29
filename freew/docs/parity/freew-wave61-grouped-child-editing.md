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
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeWWave61GroupedChildValidation.ps1 -Port 6091 -OutputDir freew/artifacts/wave61-linux
```

The wrapper writes the exact persisted geometry and screenshots under `freew/artifacts/wave61-linux/` and stops only the owned FreeW container when complete. The manifest is validated by `tools/LinuxInteractiveDocker/freew-group-child-validation.schema.json`.

The verified physical run passed all four manifest checks. `inspect-before.txt` recorded group offset/size `180,150` / `210,130` pt and child 1 offset/size `110,55` / `65,35` pt. `inspect-after.txt` recorded unchanged group geometry `180,150` / `210,130` pt and child 1 offset/size `69.76582677165354,56.099291338582674` / `301.9988188976378,95.97937007874016` pt. The visible child selection postcondition was `childIndex=1`, `handleCount=8`, with evidence in `04-child-resized-selected.png`.

Retained physical evidence:

- `freew/artifacts/wave61-linux/freew-wave61-group-child-validation.json`
- `freew/artifacts/wave61-linux/inspect-before.txt`
- `freew/artifacts/wave61-linux/inspect-after.txt`
- `freew/artifacts/wave61-linux/freew/sessions/20260729T231558276Z/group-child-wave61/02-child-selected.png`
- `freew/artifacts/wave61-linux/freew/sessions/20260729T231558276Z/group-child-wave61/03-child-moved.png`
- `freew/artifacts/wave61-linux/freew/sessions/20260729T231558276Z/group-child-wave61/04-child-resized-selected.png`

## Residuals

Nested-child editing beyond a direct child remains outside this bounded Wave 61 slice. WPF does not have a separate Linux/X11 visual lane; its shared host command and selection state are covered by STA regression tests.
