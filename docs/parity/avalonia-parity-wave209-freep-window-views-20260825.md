# Wave 209 — FreeP Window Commands

## Scope

This slice adds the PowerPoint-style **New Window** and **Arrange All**
commands to FreeP's View ribbon and wires them through both native hosts. It
has no external dependency. Ink/Draw behavior and map-chart fidelity remain
outside the active parity scope.

## Change

New Window creates an independent editable presentation snapshot through the
existing in-memory PPTX writer and reader. The snapshot retains the source
path and dirty state, and establishes a fresh file timestamp baseline so the
existing external-modification guard continues to protect its first save.
Windows are intentionally not live-synchronized after creation.

Arrange All tiles visible FreeP editor windows across the desktop work area.
The WPF host uses the system work area, while the Avalonia host uses its
display work area and the existing DPI-bound translation helper. Slide show,
presenter, and dialog windows are excluded.

Switch Windows remains deferred: it needs a dynamic window registry and menu
surface rather than a static ribbon definition.

## Evidence

The fresh View-ribbon capture is retained at
`artifacts/wave209-freep-window-view/view-ribbon.png`; it shows New Window and
Arrange All in the new Window group. The generated command inventory now
reports 712 commands, all shared by the WPF and Avalonia profiles.

## Verification

- `FreeP.App.Presentation` Release build: passed, zero warnings/errors.
- `FreeP.App.Host` Release build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` Release build: passed, zero warnings/errors.
- Focused window-planner and ribbon workflow suite: 45 passed, 0 failed.
- `Generate-FreePCommandParityInventory.ps1` and `-Check`: passed.
