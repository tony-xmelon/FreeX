# FreeP Wave 62: transformed table-cell inline edit

## Gap

The residual was a shared planning gap in both hosts, not a WPF authority behavior. Table rendering, hit testing, editor placement, and PPTX table graphic-frame I/O all dropped the table frame rotation and horizontal/vertical flips. WPF and Avalonia therefore agreed on the same incorrect axis-aligned behavior.

## Implementation

- Added table-frame rotation and flip state to the shared `DrawOp.Table` path.
- Added shared forward/inverse transform planning for table rendering, cell hit testing, and editor placement.
- Applied the same placement transform to WPF and Avalonia table-cell editors and their selection highlights.
- Preserved table graphic-frame `rot`, `flipH`, and `flipV` through PPTX read/write.
- Added managed tests for transformed placement, inverse hit testing, source parity, and PPTX round-trip persistence.
- Added a FreeP-only Linux/X11 validation schema, probe, and wrapper with exact text, geometry, rotation, flip, commit, and cancel postconditions.

## Verification

Managed checks passed:

- `FreeP.App.Presentation.Tests`: **61/61** focused tests passed, including the transformed planner, hit-test, and PPTX round-trip tests.
- `FreeP.App.Rendering.Avalonia.Tests`: **134/134** focused tests passed, including transformed editor commit/cancel persistence.
- `FreeP.App.Rendering.Wpf`: Release build passed with **0 warnings, 0 errors**, with Windows targeting enabled.

Physical Linux/X11 evidence passed:

- Session: `artifacts/freep-transformed-table-cell-edit-wave62-rerun/freep/sessions/20260730T011542857Z`
- Contract: `freep-transformed-table-cell-edit-validation/results.json`
- Result: **5/5 passed, 0 failed**.
- Evidence includes `baseline.png`, `transformed-editor-entry.png`, `transformed-editor-input.png`, `transformed-editor-committed.png`, `transformed-editor-canceled.png`, and `transformed-editor-after-escape.png`.
- The saved package contains exact text `Typed transformed cell text`, bounds `x=1651000,y=1778000,cx=8890000,cy=3302000`, rotation `30`, and both flips enabled.

## Residuals

No residual remains in the requested transformed table-cell path on the Avalonia/X11 FreeP workflow. A Windows WPF physical run was not available in this Linux validation environment; the WPF renderer builds successfully and uses the same shared planner, so Windows pixel/runtime confirmation remains an environment-level follow-up rather than an unverified code claim.
