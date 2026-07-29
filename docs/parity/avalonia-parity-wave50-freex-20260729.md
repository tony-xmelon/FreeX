# FreeX Avalonia parity wave 50

Date: 2026-07-29

## Scope

This slice adds Linux X11 evidence coverage for PivotTable field-list interaction in FreeX Avalonia. The intended scenarios are a physical Filters-to-Rows drag and a physical same-bucket Rows reorder, with persisted PivotTable layout checks as the observable postconditions.

## Changes

- Added the deterministic fixture `tests/FreeX.App.Avalonia.Tests/Fixtures/FreeX_wave50_pivot_fields.xlsx`.
- Added model and source-route tests in `tests/FreeX.App.Avalonia.Tests/PivotFieldListLinuxEvidenceTests.cs`.
- Refreshed the PivotTable field pane whenever the contextual PivotTable route is refreshed in `src/FreeX.App.Avalonia/MainWindow.PivotTabs.cs`.
- Added the `pivot-field-list` physical probe to `tools/LinuxInteractiveDocker/run-freex-input-probes.sh`.
- Added selector and document-path plumbing plus Pivot-specific required evidence IDs to `tools/Run-FreeXLinuxInteractionValidation.ps1`.

## Validation

- PowerShell parser validation passed.
- Linux X11 calibration passed at 1280x801 with a 64x20 cell grid.
- The fixture loaded with one PivotTable and an active target-cell resolver in the focused test lane before the final physical rerun.
- The latest physical run produced calibration and pre/cross screenshots, but the field pane was not exposed in the captured session. The cross-bucket and same-bucket layout postconditions were empty, and the runner correctly rejected the missing reorder screenshot. This remains the next validation task; no passing physical drag claim is made by this note.

## Evidence

Latest run: `artifacts/linux-interactive/freex/sessions/20260729T003938197Z/x11-validation/`.

The runner can be focused with `-PhysicalProbeSelector pivot-field-list` and supplied with `-PhysicalDocumentPath` pointing at the fixture. The probe records screenshots, layout postconditions, and result rows under the session's `x11-validation` directory.
