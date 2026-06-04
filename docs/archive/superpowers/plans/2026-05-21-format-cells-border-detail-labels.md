# Format Cells Border Detail Labels

## Goal

Improve keyboard navigation in the Border tab's individual side-detail grid by making the side captions target the corresponding side style controls.

## Scope

- Add XAML assertions for Top, Right, Bottom, and Left side label targets.
- Convert the side captions from passive `TextBlock`s to compact targeted `Label`s.
- Keep the existing grid geometry and side color controls unchanged.

## Verification

- Red: focused side-detail label test fails before the XAML change.
- Green: side-detail label and existing Border layout tests pass after the XAML change.
- Run `git diff --check` before commit.
