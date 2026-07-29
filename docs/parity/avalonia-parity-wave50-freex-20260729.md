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
- Replaced the unavailable container `unzip` dependency with Python `zipfile` package inspection and passed the mounted fixture filename explicitly through `FREEX_X11_DOCUMENT_PATH`.
- Fixed the shared OPC relationship classifier so a single package-root slash (`/xl/...`) remains internal on Linux, while `//host/...` and URI-scheme targets remain external.

## Validation

- PowerShell parser validation passed.
- Linux X11 calibration passed at 1280x801 with a 64x20 cell grid.
- The shared relationship tests passed (13 tests), and the focused headless Pivot evidence tests pass after the namespace qualification fix.
- The latest physical run loaded one PivotTable on Linux, visibly exposed the PivotTable Fields pane and contextual tabs, saved after each drag, and passed both required X11 results: cross-bucket insertion persisted `rows=1,0; pages=; values=2`; same-bucket reorder persisted `rows=0,1; pages=; values=2`.

## Evidence

Latest run: `artifacts/linux-interactive/freex/sessions/20260729T013303878Z/x11-validation/`.

The runner can be focused with `-PhysicalProbeSelector pivot-field-list` and supplied with `-PhysicalDocumentPath` pointing at the fixture. The probe records screenshots, saved-package layout postconditions, and result rows under the session's `x11-validation` directory. The Windows host-only dirty paths were not staged for this slice.
