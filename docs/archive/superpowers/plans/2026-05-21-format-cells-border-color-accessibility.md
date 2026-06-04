# Format Cells Border Color Accessibility

## Goal

Make the individual border side color inputs distinguishable to assistive technology without expanding the compact Border tab detail grid.

## Scope

- Add XAML assertions for explicit automation names on the Top, Right, Bottom, and Left color inputs.
- Add `AutomationProperties.Name` to each side color text box.
- Avoid layout changes; the prior side labels continue to target the side style controls.

## Verification

- Red: focused color accessibility test fails before the XAML attribute change.
- Green: color accessibility and existing Border layout tests pass after the XAML change.
- Run `git diff --check` before commit.
