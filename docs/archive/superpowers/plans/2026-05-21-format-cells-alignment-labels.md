# Format Cells Alignment Labels

## Goal

Improve Format Cells Alignment dialog keyboard fidelity by making editable alignment labels focus their associated controls.

## Implementation Notes

- Added a failing XAML source test for targeted alignment labels.
- Replaced decorative labels for horizontal alignment, vertical alignment, indent level, and text rotation with WPF `Label.Target` access-key labels.
- Architecture decision: this is Host-layer dialog accessibility polish; style diff and alignment model semantics are unchanged.
