# Wave 210 — FreeP Cascade Windows

## Scope

This follow-up completes another practical View > Window command: **Cascade
Windows**. It uses no external dependency. Ink/Draw behavior and map-chart
fidelity remain outside the active parity scope.

## Change

Cascade Windows operates on visible FreeP editor windows only. Both native
hosts use the shared `ArrangeAllLayoutPlanner` cascade geometry, then translate
the result through their own work-area boundary; Avalonia also uses the existing
DPI translation helper. This excludes slide-show, presenter, and dialog
windows. The View > Window labels and key tips are now localized through the
FreeP resource surface.

## Evidence

The fresh View-ribbon capture at
`artifacts/wave210-freep-cascade-window/view-ribbon.png` shows New Window,
Arrange All, and Cascade Windows together. The generated command inventory now
reports 713 commands, all shared by the WPF and Avalonia profiles.

## Verification

- `FreeP.App.Presentation` Release build: passed, zero warnings/errors.
- `FreeP.App.Host` Release build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` Release build: passed, zero warnings/errors.
- Focused ribbon workflow suite: 44 passed, 0 failed.
- `Generate-FreePCommandParityInventory.ps1` and `-Check`: passed.
