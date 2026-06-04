# Unhide Sheet Dialog Label

## Goal

Improve keyboard navigation in the Unhide Sheet dialog by targeting the editable sheet picker with an access-key label.

## Scope

- Add a source assertion for the `_Sheet:` label target.
- Replace the passive `Sheet:` caption with a compact targeted `Label`.
- Keep result parsing and dialog layout otherwise unchanged.

## Verification

- Red: focused Unhide Sheet label test fails before implementation.
- Green: focused Unhide Sheet tests pass after implementation.
- Run `git diff --check` before commit.
