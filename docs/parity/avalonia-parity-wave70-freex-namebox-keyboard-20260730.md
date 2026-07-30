# FreeX Wave 70: Name Box Keyboard and Pointer Interaction

Date: 2026-07-30
Scope: FreeX Avalonia production behavior and native X11 interaction evidence.

## Production change

The Avalonia Name Box now opens its production autocomplete popup from the same keyboard gestures
as the WPF editable `ComboBox`: `Alt+Down` and `F4` while the Name Box has focus. Previously the
window-level `Alt+Down` route skipped the Name Box and only attempted worksheet data-validation,
autofilter, or text-entry lists.

Existing managed coverage already proves list movement and Enter commit. This slice adds only the
opening regression guard and native proof for the real input paths.

## Physical command

The orchestrator should run the existing focused lane from this checkout:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeXLinuxInteractionValidation.ps1 `
  -PhysicalOnly `
  -PhysicalProbeSelector name-box-dropdown `
  -Port 6082
```

The lane now requires these additional result ids:

- `name-box-dropdown-keyboard-physical`: native X11 click-to-focus, `Alt+Down`, `Home/Down/Enter`,
  and exact `North<TAB>120` clipboard output from the `PhysicalTable` entry.
- `name-box-dropdown-mouse-physical`: native X11 chevron click, pointer click on the
  `PhysicalTable` row, and the same exact clipboard output.

Both results reference `name-box-dropdown-interaction-postcondition.txt`, which is checked by the
PowerShell runner for the exact gestures and clipboard values. No managed popup bitmap is credited
as physical evidence.

## Residuals

The physical lane has not been run in this agent slice because Docker execution is orchestrator-owned.
The pointer row coordinate remains calibrated from the production fixed-height popup and must be
confirmed by the orchestrator's native run. Existing Wave69 visual popup comparison is unchanged.
