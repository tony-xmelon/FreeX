# Create PivotTable Range Labels

## Goal

Bring the Create PivotTable dialog's source and destination range editors up to the same keyboard-access standard as the newer Pivot dialogs.

## Implementation Notes

- Added a failing App.Host source test for targeted source range and location labels.
- Added a local `AddLabeledReferenceEditor` helper that creates `Label.Target` access-key labels while preserving the indented reference-picker layout.
- Architecture decision: keep the helper local because this dialog has custom indentation and picker layout that differs from the shared Pivot workflow helper.
