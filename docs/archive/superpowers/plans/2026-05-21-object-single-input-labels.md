# Object Single Input Labels

## Goal

Improve keyboard and accessibility behavior for object-related single-input dialogs by associating helper-created captions with their text boxes.

## Scope

- Add a source assertion that shared object input helpers use targeted labels instead of passive text.
- Convert `ObjectSizeDialog.AddLabeledTextBox` to add a targeted `Label`.
- Convert `ObjectSizeDialog.CreateSingleInputContent` to add a targeted `Label`.

## Verification

- Red: focused helper-label test fails before implementation.
- Green: focused object dialog tests pass after implementation.
- Run `git diff --check` before commit.
