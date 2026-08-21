# FreeX Avalonia parity wave170: inline-edit physical evidence

## Trigger

The authoritative Linux Docker interaction lane was run against FreeX at 1280x820 and 96 DPI. The first physical failure was `inline-edit-f2-enter-commit`: the X11 screenshot showed the complete committed value in G8, but the probe read `clipboard='selection-failed'` immediately after Enter.

The same full lane also stopped at the existing schema gate because the nested outline rows reported planned artifacts that were not captured. That separate reporting issue remains open; no schema, threshold, or assertion was weakened here.

## Change

- Reuse the passing keyboard reselection path for formula readback after an inline edit commits.
- Add an `inline-edit` focused selector to the runner and probe script.
- Make the focused probe report only the exact artifacts it captures.
- Add a regression test covering the selector, keyboard readback, and artifact contract.

## Evidence

Before: full physical lane reported 19 passed and 14 failed rows; the first failure was `inline-edit-f2-enter-commit` with `selection-failed` readback.

After:

```text
Run-FreeXLinuxInteractionValidation.ps1 -Port 6083 -TimeoutMinutes 20 -PhysicalOnly -PhysicalProbeSelector inline-edit
schemaVersion=2, physical-only
physicalX11: passed=1, failed=0, total=1
X11 clipboard='X11InlineCommit'
window=1280x820, calibration=passed, cellWidth=64, cellHeight=20, selectionColor=#217346
```

The generated report is under `artifacts/linux-interactive/freex/interaction-validation/20260821T223423Z/interaction-validation.html`, with before, editing, after, and cell-crop PNG evidence.

## Verification and remaining work

`LinuxFreeXInteractionValidationToolTests`: 16 passed, 0 failed.

The full all-probes lane still needs follow-up for the remaining physical failures, including save/clipboard/context-menu, split-pane, nested-outline seeding/artifact capture, and bounded mouse-move timeout behavior. The full-lane schema gate must also be resolved without hiding those failures.
