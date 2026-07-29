# Avalonia parity wave 50

Date: 2026-07-29

## Closed slices

- FreeX: added physical Linux/X11 PivotTable field-list drag coverage for a
  Filters-to-Rows move and a same-bucket Rows reorder. Both persisted XLSX
  postconditions passed. The investigation also fixed shared OPC relationship
  classification so package-root `/xl/...` targets remain internal on Linux while
  URI, UNC, and explicitly external targets remain external.
- FreeW: closed Avalonia Drawing Format text-direction execution for Horizontal,
  Rotate 90, and Rotate 270 through a shared undoable command and renderer plan.
  The generated command inventory now records the Avalonia registry routes.
- FreeP: added genuine physical Linux/X11 Animation Pane evidence covering pane
  open, seeded row visibility, row selection, close, and reopen. The family
  physical contract is now 24 rows.

## Validation

- Focused regression lanes: 43 passed, 0 failed.
- FreeP Linux family physical contract:
  `artifacts/avalonia-parity-wave50/freep-linux-family-rerun/freep/sessions/20260729T014425121Z/family-validation/family-x11-results.json`
  passed 24/24.
- FreeX Linux PivotTable physical report:
  `artifacts/linux-interactive/freex/interaction-validation/20260729T014521Z/interaction-validation.json`
  passed 2/2.
- Repository preflight passed after regenerating the affected parity inventories.
- Full Release solution build passed with 0 warnings and 0 errors.
- Default test lane passed 33,043 executed tests with 0 failures; 133 tests were
  skipped by their existing opt-in/performance conditions. One unrelated
  clipboard/navigation-cache test failed transiently in the broad rerun, then
  passed five isolated repetitions and the complete 1,447-test Host Logic
  assembly rerun.

## Remaining work

- FreeX generated command and dialog route coverage is complete for the current
  inputs, but this does not establish pixel-level or workflow-complete visual
  parity. Continue physical interaction and human visual review as new residuals
  are identified.
- FreeW still needs authoritative Word PNG comparisons, a Linux screenshot route
  for rotated text, and deeper direct grouped-child editing evidence.
- FreeP still needs PowerPoint-authoritative Animation Pane visual/playback
  baselines, broader chart/SmartArt/math/media comparisons, and real hardware
  microphone/camera validation.

This wave advances functional and physical evidence coverage; it does not claim
100% Avalonia/WPF parity.
