# FreeX Wave199: Home ribbon font-family focus convergence

Wave199 changed the production Linux X11 probe so it measures the real worksheet keyboard route immediately after selecting `Arial` in the Home Font combo, before any explicit worksheet reselect. The existing explicit reselect and XLSX package checks remain as separate diagnostics.

The single production focus candidate was rejected after the decisive Docker/X11 run. The candidate captured combo focus synchronously and deferred the worksheet handoff, but the physical result remained `automatic-focus-after-combo=false`; the next `Right` and `Ctrl+C` still observed the original `A1` value. The same run also reported `save-clean=false` and a package signature containing `Calibri`, so it did not satisfy the retained font persistence requirement. Production `MainWindow.cs` therefore has zero net candidate change.

The WPF authority remains the native `FontNameBox_SelectionChanged` application path plus the worksheet keyboard route in `MainWindow.Selection.cs`. The Avalonia production path still uses the existing guarded `DropDownClosed` handoff; the unresolved gap is now measured truthfully rather than represented as not measured.

## Verification

Run from the repository root:

```powershell
pwsh -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector ribbon-font-family -TimeoutMinutes 8
```

The accepted Wave199 result is intentionally a rejected candidate: the physical row is `failed`, with `automatic-focus-after-combo=false`, `worksheet-focus-after-reselect=true`, `save-clean=false`, and `font-name=Calibri`. The durable run is recorded in [FINAL-EVIDENCE.md](FINAL-EVIDENCE.md).

The existing accepted Wave198 evidence remains the persistence reference for the font-family workflow: it proves clean save and an Arial font record after an explicit worksheet reselect. Wave199 does not claim that persistence passed in its rejected candidate run.
