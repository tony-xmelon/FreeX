# Worker Excel Ribbon Pairing - 2026-06-09

Scope: paired Microsoft Excel and FreeX main-ribbon screenshot evidence for `UI-CMD-HARNESS-001`, `UI-CMD-RIBBON-004`, and `UI-CAT-RIBBON-001A`.

## Harness Repair

- Updated `tools/screenshot_excel.ps1` so normal ribbon captures use the existing retrying Excel foreground activation helper before initial setup and each width resize.
- Updated `tools/screenshot_ribbon.ps1` with the same retrying foreground activation pattern for FreeX normal ribbon captures.
- Kept the existing hard foreground guards before global keyboard/mouse input and before `CopyFromScreen`; failed guards still clear the normal ribbon evidence matrix.

## Live Capture Attempt

Focused subset attempted first: width `1100` across the default nine main tabs (`Home`, `Insert`, `Draw`, `Page Layout`, `Formulas`, `Data`, `Review`, `View`, `Help`).

Commands and outcomes:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_excel.ps1 -Widths 1100
```

Outcome: blocked before initial capture setup. Exact guard failure:

```text
Blocked: foreground window 'Rakuten Viber' (PID 73912) does not match expected 'Excel' (PID 81848) before initial capture setup.
```

Earlier pre-repair Excel attempt also blocked before width resize setup:

```text
Blocked: foreground window 'Rakuten Viber' (PID 73912) does not match expected 'Excel' (PID 70456) before window resize capture setup.
```

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\screenshot_ribbon.ps1 -Widths 1100
```

Outcome: blocked before initial capture setup. Exact guard failure:

```text
Blocked: foreground window 'Rakuten Viber' (PID 73912) does not match expected 'Book1 - FreeX' (PID 70780) before initial capture setup.
```

No new paired main-ribbon screenshots or `tools/screenshots*/screenshot_manifest.json` files were produced. The scripts cleared the normal ribbon evidence matrix on guard failure, as intended. Existing checked-in interactive popup/dialog artifacts under `tools/screenshots/` and `tools/screenshots_excel/` were not used as evidence for this main-ribbon pairing attempt.

## Status

`UI-CMD-HARNESS-001`, `UI-CMD-RIBBON-004`, and `UI-CAT-RIBBON-001A` remain open for paired Excel/FreeX main-ribbon screenshot evidence. A runner with foreground control over Excel and FreeX should rerun the focused `-Widths 1100` pair first, then expand to `max,1100,900,750` after the manifests show complete 9-tab coverage.
