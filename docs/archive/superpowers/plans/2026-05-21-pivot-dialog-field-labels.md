# Pivot Dialog Field Labels

## Goal

Improve PivotTable/PivotChart dialog keyboard fidelity by making auxiliary dialog field labels focus their editable controls.

## Implementation Notes

- Added a failing App.Host source test covering Pivot data-source, slicer, timeline, PivotChart, grouping, calculated field, and calculated item dialogs.
- Added a shared `PivotDialogLayout.AddLabeledControl` helper that creates WPF `Label.Target` access-key labels.
- Replaced decorative `TextBlock` labels for modeled Pivot editable fields with targeted labels.
- Architecture decision: keep this as a Host-layer dialog accessibility helper; no command/model changes are involved.
