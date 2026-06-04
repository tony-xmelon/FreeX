# Hyperlink Dialog Labels

## Goal

Improve keyboard navigation in the Insert Hyperlink dialog by targeting the display-text and address text boxes with access-key labels.

## Scope

- Add a source assertion for hyperlink text-row labels and targets.
- Add access-key markers to the display and address row labels.
- Convert `AddTextRow` from a passive `TextBlock` caption to a targeted `Label`.

## Verification

- Red: focused Hyperlink label test fails before implementation.
- Green: focused Hyperlink/shared object helper tests pass after implementation.
- Run `git diff --check` before commit.
