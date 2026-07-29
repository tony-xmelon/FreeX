# Wave 60 FreeX Linux Grid Drag Parity

## Scope

This slice closes the physical Avalonia/X11 pointer residuals for:

- autofill-handle drag;
- selection-border move drag;
- Ctrl-copy selection-border drag.

The selector seeds deterministic values, performs real X11 pointer gestures, captures selection geometry immediately after each gesture, and verifies persisted values/formulas from the saved workbook. Selection assertions use calibrated coordinate tolerance rather than exact pixel equality.

## Production change

`FreeX.App.Avalonia.MainWindow.CommitSelectionMoveDragAsync` now rebuilds the shell after the Ctrl-copy command and again after restoring the complete destination selection. The generic edit command temporarily collapses selection to the first affected cell; the second selection/rebuild pass prevents Avalonia from leaving the visible marquee on the source range after a successful copy drag.

Focused regression coverage was added for the host selection state and the source-level rebuild ordering contract.

## Physical evidence

### First calibration/timing exposure: 2/3

First manifest:
`artifacts/linux-interactive/freex/interaction-validation/20260729T205727Z/x11-validation/x11-input-results.json`

Result: `2 passed, 1 failed, 3 total`.

- Autofill passed with `C3:C7 = 10,20,30,40,50` and the completed selection visible.
- Move physically succeeded and the target selection was visible, but the early harness read a blank source through the clipboard helper after the gesture and observed stale clipboard text (`50,50`). This exposed a harness timing/observation defect, not a move-data defect. The selector was changed to save and read exact CSV cell values, and to capture selection before any helper that changes selection.
- Ctrl-copy preserved source and destination values, but the visible selection remained on source `G3:G4` at approximately `(413,276)` instead of destination `G6:G7` at approximately `(413,336)`. This was treated as a real Avalonia production parity defect.

The first-run evidence is intentionally retained as an honest calibration/timing record.

### Final physical run: 3/3

Final manifest:
`artifacts/linux-interactive/freex/interaction-validation/20260729T210928Z/x11-validation/x11-input-results.json`

Result: `3 passed, 0 failed, 3 total`.

- `grid-autofill-handle-drag-physical`: passed. `C3:C7 = 10,20,30,40,50`; selection approximately `(157,276)`.
- `grid-selection-border-move-physical`: passed. `E3:E4` is empty; `E6:E7 = MoveTop,MoveBottom`; selection approximately `(285,336)`.
- `grid-selection-border-copy-physical`: passed. `G3:G4 = CopyTop,CopyBottom`; `G6:G7 = CopyTop,CopyBottom`; selection approximately `(413,336)`.

Retained final evidence is listed by the manifest and includes the before/after PNGs for all three gestures plus `grid-drag-postcondition.txt`.

## Focused tests

- `tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj`, filtered to the Ctrl-copy host regression and source contract: `2 passed, 0 failed, 0 skipped, 2 total`.
- `tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj`, filtered to `GridSelectionMovePlanner`: `7 passed, 0 failed, 0 skipped, 7 total`.
- Physical selector: `3 passed, 0 failed, 3 total`.

## Residuals

This slice is complete for the requested FreeX physical grid-drag contract. WPF live physical pointer automation was not available in the Linux Docker harness; the Ctrl-copy behavior is covered by the existing application contract and managed planner/host tests, then verified against the Avalonia physical result.
