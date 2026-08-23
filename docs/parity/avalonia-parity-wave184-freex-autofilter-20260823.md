# FreeX Wave 184 AutoFilter Physical Parity

Date: 2026-08-23

## Scope

This slice closes the next unproven FreeX Linux workbook workflow after the
Wave 183 Name Box evidence: opening a worksheet AutoFilter, applying a value
filter, changing it, clearing it, and observing the dependent
`SUBTOTAL(109,...)` result.

## Gap and correction

The first physical run against the Wave 183 source opened the real AutoFilter
flyout but failed the WPF/Excel value contract, observing `30 -> 20 -> 20 ->
30` instead of `30 -> 10 -> 20 -> 30`. The keyboard route used the stale
selected-cell border as its flyout anchor, so the Linux realization did not
reliably bind to the rendered header control.

The Avalonia keyboard fallback now resolves the live `AutoFilterButton_*`
header control and anchors the flyout to that control, with the cell border as
an explicit fallback. The Docker probe now fail-closes when the flyout does
not visibly open and uses calibrated offsets for the rendered North/South
checkboxes and OK button. This preserves the real X11 input and value
postconditions rather than crediting a dismissed popup.

## Evidence

Final Docker/X11 run:

- Command: `tools\Run-FreeXLinuxInteractionValidation.ps1 -Port 62844 -TimeoutMinutes 15 -PhysicalOnly -PhysicalProbeSelector autofilter-recalculation -SkipImageBuild`
- Report: `artifacts/linux-interactive/freex/interaction-validation/20260823T003352Z/interaction-validation.json`
- Result: `autofilter-recalculation-apply-change-clear-physical` passed `1/1`.
- Postcondition: `initial=30`, `north=10`, `south=20`, `cleared=30`.
- Physical calibration: 1280x820, 96 DPI, A1 origin `(29,236)`, cell pitch `64x20`.
- Retained evidence includes the opened flyout, checked/committed states,
  post-filter screenshots, cleared state, and
  `autofilter-recalculation-postcondition.txt`.

## Verification

- `FreeXCleanupMED1Tests`: 10/10 passed, including the live header-anchor assertion.
- `LinuxPhysicalProbe_IsGeometryCalibratedClipboardBackedAndSchemaVersioned`: passed with the AutoFilter selector contract assertions.
- Final physical selector: 1/1 passed.

## Remaining

This closes the bounded AutoFilter value/recalculation workflow. Broader
AutoFilter criteria, color, sort, and persistence combinations remain outside
this Wave 184 evidence row.

## Cleanup

The session-owned Docker containers on ports 62184, 62841, 62842, 62843, and
62844 were stopped by the runner or failed before startup. No other containers
or processes were terminated.
