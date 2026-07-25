# FreeW Linux Field Shortcut Physical Lane

This document records the dedicated Linux Docker evidence lane for FreeW Avalonia's generic complex
field shortcuts. It is intentionally **not exhaustive** and does not change the clean/untitled
FreeW family baseline in `family-linux-physical-baseline-2026-07-23.md`.

## Scope

The lane launches a real FreeW Avalonia window with a generated DOCX containing a stale cached `TITLE`
complex field. It injects the real X11 key chords `Alt+F9`, `Alt+F9`, `F9`, and `Ctrl+S` through
`xdotool`; no direct editor method calls stand in for physical dispatch.

The four exact manifest rows are:

- `visible-window-discovery`
- `field-code-shortcut-show`
- `field-code-shortcut-hide`
- `field-update-shortcut-persist`

The two Alt+F9 rows retain full-screen and editor-region screenshots, region hashes, and active/focus
state. The F9 row retains the physical save state and the host-side structured `DocxReader` inspection,
which proves the persisted `TITLE` cache equals `FreeW deterministic field shortcut title`.

## Command

Run the dedicated lane from the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeWFieldShortcutValidation.ps1
```

The authoritative manifest is written below the generated session directory as
`field-shortcut-validation/field-shortcut-results.json`. The runner stops only its own FreeW container
unless `-KeepContainer` is supplied. The fixture is generated at runtime through
`FreeW.Core.Model`, `FreeW.Core.IO.DocxWriter`, and `FreeW.Core.IO.DocxReader`; no opaque binary fixture is
committed.
