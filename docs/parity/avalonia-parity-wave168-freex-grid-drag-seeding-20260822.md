# FreeX Avalonia physical grid-drag parity

## Gap selected

The Linux Docker selector for the worksheet's highest-value drag workflows could
not reach the drag gestures reliably. After an inline edit committed, pointer
reselection was not deterministic, and an empty cell did not replace the X11
clipboard owner after `Ctrl+C`. The selector therefore stopped during fixture
seeding and did not provide evidence for autofill, selection-border move, or
Ctrl-drag copy.

## Implementation

`tools/LinuxInteractiveDocker/run-freex-input-probes.sh` now uses a keyboard
reselection route (`Ctrl+Home` plus calibrated arrows) for post-commit readback,
while retaining the bounded sentinel clipboard owner for empty-cell assertions.
Empty values do not send an empty `xdotool type` packet. The change is limited to
the physical validation path; Avalonia production drag behavior remains the
authoritative behavior under test.

`LinuxFreeXInteractionValidationToolTests` pins the helper contract so future
probe changes cannot silently return to pointer-only readback or lose empty-cell
handling.

## Authoritative evidence

Command:

```text
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector grid-drag -TimeoutMinutes 20 -ResumeReportDirectory artifacts/linux-interactive/freex/interaction-validation/20260821T211424Z -SkipImageBuild -SkipPublish
```

Result: **3 passed, 0 failed** at `1280x820`, 96 DPI, with calibration passed.

- Autofill: `C3:C7 = 10,20,30,40,50`, completed range selected.
- Move: `E3:E4` cleared and moved to `E6:E7 = MoveTop,MoveBottom`.
- Ctrl-drag copy: `G3:G4` preserved and copied to `G6:G7`.

Retained evidence is under
`artifacts/linux-interactive/freex/interaction-validation/20260821T211424Z/x11-validation/`.

## Remaining FreeX gaps

This closes the focused physical grid-drag selector. The broader Linux physical
matrix, Excel-paired visual comparison, and other backlog families remain outside
this slice.
