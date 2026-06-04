# Chart Dialog Helper Labels

## Goal

Improve keyboard and accessibility behavior across chart formatting dialogs by making helper-created captions target their editable controls.

## Scope

- Add source assertions for targeted labels in chart helper methods.
- Convert Chart Titles inputs, Chart Style selector, and `ChartDialogHelpers` combo/text/color helpers from passive captions to targeted `Label`s.
- Preserve existing color-picker button routing and formatting behavior.

## Verification

- Red: focused chart helper label test fails before implementation.
- Green: focused chart helper/color-picker tests pass after implementation.
- Run `git diff --check` before commit.
