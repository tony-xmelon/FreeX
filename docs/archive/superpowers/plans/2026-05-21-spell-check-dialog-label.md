# Spell Check Dialog Label

## Goal

Improve keyboard navigation in the Spelling dialog by targeting the replacement text box with an access-key label.

## Scope

- Add a source assertion for the `_Change to:` label target.
- Replace the passive `Change to:` caption with a compact targeted `Label`.
- Keep spelling actions and result creation unchanged.

## Verification

- Red: focused Spelling label test fails before implementation.
- Green: focused Spelling tests pass after implementation.
- Run `git diff --check` before commit.
