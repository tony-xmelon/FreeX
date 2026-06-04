# PivotTable Merge Labels Option

## Goal

Expose and preserve Excel's PivotTable "Merge and center cells with labels" layout option.

## Scope

- Add `PivotTableModel.MergeAndCenterLabels`, defaulting to disabled.
- Preserve it through sheet cloning and undoable PivotTable Options snapshots.
- Surface it in the PivotTable Options Layout & Format tab.
- Round-trip the native XLSX `mergeItem` attribute.
- Document that exact merged-cell rendering is still separate visual fidelity work.

## Verification

- Red: focused Core.Model command tests failed because the model flag and command parameter did not exist.
- Green: focused Core.Model command tests, App.Host PivotTable Options dialog tests, and Core.IO authored PivotTable package tests passed.
- Full solution build.
