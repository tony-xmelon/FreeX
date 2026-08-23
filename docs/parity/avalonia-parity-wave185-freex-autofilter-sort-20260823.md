# FreeX Wave 185 AutoFilter Sort Persistence

Date: 2026-08-23

## Scope

Physical Linux X11 FreeX AutoFilter Sort A to Z, save, reopen, and Sort Z to A.

## Physical Evidence

Command:

```text
pwsh -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 62857 -TimeoutMinutes 15 -PhysicalOnly -PhysicalProbeSelector autofilter-sort-persistence -SkipImageBuild
```

The physical probe result was **passed 1/1**. Captured manifest:
`artifacts/linux-interactive/freex/sessions/20260823T015509857Z/x11-validation/x11-input-results.json`

Exact postconditions:

- Ascending menu visible: `true`; visible order: `East,North,South,West`.
- Save clean: `true`; ascending package signature: `ref=A2:B5|condition=A2:A5|descending=|order=East,North,South,West`.
- Reopen dialog closed: `true`; reopened order: `East,North,South,West`.
- Descending menu visible: `true`; visible order: `West,South,North,East`.
- Descending package signature: `ref=A2:B5|condition=A2:A5|descending=1|order=West,South,North,East`.

The selector fails closed when the required menu-visible, dialog, order, save-clean, or package state/value postconditions are absent. Evidence artifacts include the before, both menu-open, both sorted, reopened, and postcondition captures.

## Verification

- `FreeX.App.Avalonia.Tests`: 20 passed, 0 failed.
- `WorksheetFilterWorkflowSessionTests`: 8 passed, 0 failed.
- Production build: `src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj` in Release configuration.

## Remaining

Broader AutoFilter text, number, date, color, and multi-column criteria workflows remain outside Wave 185.
