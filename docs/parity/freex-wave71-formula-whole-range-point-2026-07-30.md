# FreeX Wave71: physical whole-range formula point mode

The established Linux X11 harness now has a dedicated `formula-whole-range-point` selector for the three formula-bar point interactions already green in headless coverage:

- a real column-header click inserts the exact `B:B` reference;
- a real row-header click inserts the exact `3:3` reference;
- a real select-all corner click inserts the exact `A1:XFD1048576` reference while the formula edit remains active.

Each result requires calibrated screenshots, formula-bar clipboard text, committed cell-package formula readback where applicable, and `formula-whole-range-point-postcondition.txt`. The PowerShell runner validates the exact semantic postcondition and fails closed for missing, malformed, or failed evidence.

## Verification

The managed source-contract guard passed 1/1.

Physical Linux validation passed all three interactions:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector formula-whole-range-point -Port 6711 -TimeoutMinutes 20
```

The session manifest reports 3 passed, 0 failed:

- Column header: formula-bar and committed-cell readback both equal `=SUM(B:B)`.
- Row header: formula-bar and committed-cell readback both equal `=SUM(3:3)`.
- Select-all corner: active-edit readback equals `=SUM(A1:XFD1048576)`, followed by an exact blank-cell readback after cancellation.

Evidence:
`artifacts/linux-interactive/freex/sessions/20260730T212641359Z/x11-validation/x11-input-results.json`.
The runner removed its harness-owned container after completion.
