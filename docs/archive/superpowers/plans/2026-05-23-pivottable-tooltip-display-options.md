# PivotTable Tooltip Display Options

## Goal

Close another PivotTable Options display gap by modeling Excel's tooltip-related PivotTable display flags.

## Scope

- Add `ShowContextualTooltips` and `ShowPropertiesInTooltips` to `PivotTableModel`, defaulting to enabled.
- Preserve both flags through sheet cloning and undoable `ConfigurePivotTableOptionsCommand` snapshots.
- Surface both options in the PivotTable Options Display tab and flow dialog results into commands.
- Round-trip the native XLSX `showDataTips` and `showMemberPropertyTips` attributes.
- Update architecture and command parity documentation.

## Verification

- Red: focused Core.Model tests failed because the model and command parameters did not exist.
- Green: focused Core.Model command tests, App.Host PivotTable Options dialog tests, and Core.IO authored PivotTable package tests passed.
- Full solution build.
