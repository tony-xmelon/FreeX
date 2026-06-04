# Format Cells Fill Labels

## Goal

Move the Fill tab's editable-field captions from passive text to targeted WPF labels so keyboard users can jump to the corresponding inputs with access keys.

## Scope

- Add XAML assertions for Fill tab label access keys and targets.
- Convert Fill tab captions for background color, pattern color, and pattern style to `Label` controls.
- Keep behavior and layout unchanged outside the caption controls.

## Verification

- Red: focused Fill tab XAML tests fail before the XAML change.
- Green: focused Fill tab XAML tests pass after the XAML change.
- Run `git diff --check` before commit.
