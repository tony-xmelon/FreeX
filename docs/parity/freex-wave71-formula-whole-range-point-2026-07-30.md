# FreeX Wave71: physical whole-range formula point mode

The established Linux X11 harness now has a dedicated `formula-whole-range-point` selector for the three formula-bar point interactions already green in headless coverage:

- a real column-header click inserts the exact `B:B` reference;
- a real row-header click inserts the exact `3:3` reference;
- a real select-all corner click inserts the exact `A1:XFD1048576` reference while the formula edit remains active.

Each result requires calibrated screenshots, formula-bar clipboard text, committed cell-package formula readback where applicable, and `formula-whole-range-point-postcondition.txt`. The PowerShell runner validates the exact semantic postcondition and fails closed for missing, malformed, or failed evidence.

The physical run is pending orchestrator execution. Future command, using reserved port `6711` and the unique UTC-stamped output directory produced by the runner:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\tools\Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector formula-whole-range-point -Port 6711 -TimeoutMinutes 20
```

Expected output root: `artifacts/linux-interactive/freex/interaction-validation/<UTC timestamp>/x11-validation/`.
