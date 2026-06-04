# Format Cells Number Labels

## Goal

Improve custom-number UI keyboard fidelity by making the Format Cells Number tab labels focus their associated controls.

## Implementation Notes

- Added failing XAML source tests for targeted Number tab labels.
- Replaced decorative Number tab captions for category, type, decimal places, symbol, and negative numbers with WPF `Label.Target` access-key labels.
- Architecture decision: this is dialog-level accessibility polish; number-format parsing and model semantics are unchanged.
