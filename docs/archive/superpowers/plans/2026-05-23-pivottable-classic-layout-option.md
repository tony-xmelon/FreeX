# PivotTable Classic Layout Option

## Goal

Expose and preserve Excel's classic PivotTable layout option that enables dragging fields in the grid.

## Scope

- Add `PivotTableModel.ShowClassicLayout`, defaulting to disabled.
- Preserve it through sheet cloning and undoable PivotTable Options snapshots.
- Surface it in the PivotTable Options Display tab.
- Round-trip the native XLSX `showDropZones` attribute.
- Update architecture and command parity documentation.

## Verification

- Red: focused Core.Model command tests failed because the model flag and command parameter did not exist.
- Green: focused Core.Model command tests, App.Host PivotTable Options dialog tests, and Core.IO authored PivotTable package tests passed.
- Full solution build.
