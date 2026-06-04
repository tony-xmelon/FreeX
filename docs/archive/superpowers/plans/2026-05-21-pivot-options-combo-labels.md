# Pivot Options Combo Labels

## Goal

Close the remaining keyboard fidelity gap in the PivotTable Options dialog by making editable option labels focus their associated controls.

## Implementation Notes

- Added a failing App.Host source test for PivotTable Options editable fields.
- Replaced decorative `TextBlock` labels for report layout, empty-cell display text, subtotal placement, and style with `Label.Target` access-key labels.
- Kept the change scoped to dialog accessibility; no model or command architecture changed.
