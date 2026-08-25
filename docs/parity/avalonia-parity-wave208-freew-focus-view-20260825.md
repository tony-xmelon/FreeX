# Wave 208 — FreeW Focus View

## Scope

This slice adds Word-style Focus to FreeW's View ribbon and wires it to both
native desktop hosts. It has no external dependency. Ink/Draw behavior and
map-chart fidelity remain outside the active parity scope.

## Change

Focus is a reversible editing mode, distinct from FreeW's existing Read Mode.
It keeps the live document editor and its normal page treatment active while
temporarily hiding application chrome and docked inspection panes. Escape exits
Focus even though the ribbon is hidden, so the command has a keyboard-safe
return path. The shared View workflow exposes a stateful `freew.focus` command
and both WPF and Avalonia bind it to their native chrome.

## Evidence

The fresh WPF capture is retained at
`artifacts/wave208-freew-focus/ribbon-8-View.png`; it shows Focus in
the new Immersive View-ribbon group. The generated FreeW inventory now reports
953 commands, with 732 present in both compiled profiles.

## Verification

- `FreeW.App.Presentation.Tests` View-ribbon workflow suite: 5 passed, 0 failed.
- `FreeW.App.Host` Release build: passed, zero warnings/errors.
- `FreeW.App.Avalonia` Release build: passed, zero warnings/errors.
- `Generate-FreeWCommandInventory.ps1` and `-Check`: passed.
- WPF View-ribbon capture: passed.

The broad WPF `FreeWRibbonParityTests` filter has one confirmed baseline
failure in `InsertTab_GroupsBackedCommandsLikeWord`: its Insert/Text expected
list includes five commands absent from the same `origin/main` test-support
profile. This View-only change does not modify the Insert tab.
