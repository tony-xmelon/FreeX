# Wave190 FreeX: Linux X11 Date AutoFilter Reopen

Date: 2026-08-23
Branch: `codex/parity-wave190-freex-20260823`
Base: `origin/main` at `2aef931ca017f5c3755d86b302099597c72947db`

## Outcome

The production Linux X11 `Date Filters > After > February 1` save/reopen lane now passes
strictly. The fix is harness-only and keeps the production app, rendered B1 glyph, native
Open Workbook dialog, Save operation, and OOXML verification in the acceptance path.

The first post-save `Ctrl+F12` can be rejected while the Avalonia `MainWindow` still owns the
save boundary (`_isSaving`). The probe now waits for three consecutive clean-title reads, then
retries the same production shortcut up to four bounded times. A retry is credited only after a
real additional visible X11 window appears, the dialog is used to reopen the workbook, the dialog
closes, and the exact rendered state is read back. The final read uses the existing production
`Ctrl+G`/formula-bar path for worksheet `A5`, because rows 2-4 are collapsed by the filter and
the normal unfiltered selection geometry cannot validate the rendered row-5 slot.

## Physical Evidence

Baseline Wave189 run, before the fix:

`artifacts/linux-interactive/freex/interaction-validation/20260823T090024Z/x11-validation/autofilter-date-postcondition.txt`

The Before workflow passed, but the After workflow ended with `after-dialog-open=false`,
`after-dialog-closed=false`, and `after-reopened=,,` (1/2 strict probes).

Clean final run:

`artifacts/linux-interactive/freex/interaction-validation/20260823T094004Z/x11-validation/`

Authoritative postcondition:

```text
before-menu-open=true
before-criteria=date<:2024-02-01
before-visible=Jan01,Jan15,
before-save-clean=true
before-package=ref=A1:B5|colId=1|operator=lessThan|value=45323
before-dialog-open=true
before-dialog-closed=true
before-reopened=Jan01,Jan15,
after-menu-open=true
after-criteria=date>:2024-02-01
after-visible=Mar15,,
after-save-clean=true
after-package=ref=A1:B5|colId=1|operator=greaterThan|value=45323
after-open-attempts=2
after-dialog-open=true
after-dialog-closed=true
after-reopened=Mar15,,
```

Rendered evidence from the clean run:

- `autofilter-date-after-before.png`: B1 has the rendered filter glyph before the After action.
- `autofilter-date-after-menu-open.png`: the production Date Filters flyout is visible.
- `autofilter-date-after-applied.png`: the rendered sheet shows `Mar15` and the filter glyph.
- `autofilter-date-after-reopened.png`: after the real second Open/Save cycle, the rendered sheet still shows `Mar15` and the filter glyph.
- `autofilter-date-after-open-cycle.txt`: X11 ownership diagnostic for every real `Ctrl+F12` attempt.

The diagnostic records no additional visible window on attempt 1, then on attempt 2 records a
real `Open Workbook` window, `wmctrl-window-count=2`, and `active-window-pid=29`, the same PID as
the FreeX main window. This identifies the modal owner as the production Avalonia MainWindow
open workflow, not a hidden alternate dialog or direct package operation.

## Verification

Focused source guard:

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~Wave189AutoFilterDatePhysicalSourceTests --logger "console;verbosity=minimal"
Passed: 2, Failed: 0, Skipped: 0
```

Physical validation:

```text
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector autofilter-date-criteria-persistence -TimeoutMinutes 20
Summary: passed 2, failed 0, total 2
```

The physical run stopped its owned interactive container. No direct XLSX/package manipulation was
used, and no cross-app dashboard or integration note was changed.
