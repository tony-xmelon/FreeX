# Format Cells Font Labels

## Goal

Improve Format Cells Font tab keyboard fidelity by making font option labels focus their associated controls.

## Implementation Notes

- Added failing XAML source tests for targeted Font tab labels.
- Replaced decorative labels for font name, font style, size, underline, and color with WPF `Label.Target` access-key labels.
- Architecture decision: this remains dialog-level accessibility polish; font style modeling and style diff behavior are unchanged.
