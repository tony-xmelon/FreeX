# Pivot Checkbox Access Keys

## Goal

Close the remaining keyboard-access gap on modeled PivotTable and PivotChart checkbox options.

## Implementation Notes

- Added failing App.Host source tests for PivotTable Options, PivotChart Options, and grouping checkbox mnemonics.
- Added access keys to modeled Pivot options checkboxes, PivotChart field-button visibility, and grouping ungroup.
- Chose distinct mnemonics within the same options tab where practical.
- Architecture decision: this remains Host-layer WPF command-surface polish; no command/model behavior changed.
