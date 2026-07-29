# Parity Wave 60: FreeW Table Properties on Linux/X11

This lane validates the production Avalonia FreeW Table Properties dialog in a physical Linux/X11 desktop.

The validation-only startup seed creates and selects a deterministic 2x2 table. The standalone X11 probe opens the real dialog, records the production automation IDs observed during focus traversal, edits `IndentFromLeftPt` to `12`, moves focus to the real OK button, and presses Enter. The app writes the exact shared-model result; the probe requires a 2x2 shape, `Applied` status, and `IndentFromLeftPt == 12`.

Run from the repository root:

```powershell
powershell -File tools/Run-FreeWTablePropertiesX11Validation.ps1
```

Artifacts are written to `artifacts/freew-table-properties-x11/`: the physical result, app-side model result, schema copy, focus/traversal screenshots, and the owned Docker session metadata.
