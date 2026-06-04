# Format Cells Border Line Labels

## Goal

Bring the Border tab's primary Line controls closer to Excel keyboard behavior by using targeted WPF labels for line style and line color.

## Scope

- Add XAML assertions for the Border tab Line style/color label targets.
- Convert the primary Line `Style` and `Color` captions from passive text to `Label` controls.
- Leave the individual border-detail grid for a separate, smaller iteration.

## Verification

- Red: focused Border Line XAML test fails before the XAML change.
- Green: focused Border Line and existing Border layout tests pass after the XAML change.
- Run `git diff --check` before commit.
