# Sparkline Dialog Labels

## Goal

Bring the Insert Sparkline dialog closer to Excel keyboard behavior by labeling the editable range and type controls with access-key targets.

## Scope

- Add source assertions for targeted labels on Data range, Location, and Sparkline type.
- Replace passive range captions with targeted `Label` controls.
- Add a targeted label for the sparkline type combo box.

## Verification

- Red: focused Sparkline label test fails before implementation.
- Green: focused Sparkline label and range-picker tests pass after implementation.
- Run `git diff --check` before commit.
