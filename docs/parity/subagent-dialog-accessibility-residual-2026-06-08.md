# Dialog Accessibility Residual Sweep - 2026-06-08

## Scope

Worker branch: `codex/dialog-accessibility-residual-20260608`

Worktree: `.worktrees/dialog-accessibility-residual-20260608`

Catalog row inspected: `docs/testing/ui-test-catalog.md` row `UI-CMD-DIALOG-001`.

This sweep stayed out of the active AutoFilter flyout, Page Layout product files, status/footer, Insert table/pivot product files, Formula product files, Draw UI, titlebar/QAT, chart data-source, data import, protected-sheet command-matrix, and paste residual areas. The focused dialogs were Data Validation and Format Cells, with Options inspected as a reference because it already has stronger category/action automation metadata.

## Evidence Added

Data Validation:

- Added stable automation IDs for the dialog's focusable fields and command buttons, including allow/data selectors, formula fields, range picker buttons, message/error editors, Clear All, OK, and Cancel.
- Kept the existing default focus contract on the Allow selector, invalid-criteria focus return to the Settings tab and invalid formula field, Enter default through OK, and Escape cancel through the button row.
- Removed visible English access-key collisions in the common Settings tab states by moving `Ignore blank` to `B` and the same-settings checkbox to `W`; base English and regional English resources were updated.
- Added focused source/XAML tests for the new automation IDs, default/cancel button metadata, and visible English access-key collision coverage.

Format Cells:

- Added stable automation IDs for the OK and Cancel buttons while preserving the existing `IsDefault`/`IsCancel` behavior.
- Extended the existing Format Cells keyboard/accessibility source test so the button-row automation IDs are covered alongside access keys and Enter/Escape semantics.

## Remaining Gaps

- Full UIA pattern verification, live tab order, and screenshot evidence remain pending for `UI-CMD-DIALOG-001`.
- Non-English access-key collision coverage remains a larger localization pass; this slice only adjusted base English and regional English Data Validation strings.
- Options already has source/runtime coverage for category default focus and action automation metadata, so this slice did not change it.

## Verification

Completed in this worktree:

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DataValidationDialogTests|FullyQualifiedName~FormatCellsDialogXamlTests" --logger "trx;LogFileName=dialog-accessibility-residual.trx"`: passed 122 tests.
- `git diff --check`: passed; Git reported line-ending conversion warnings only.
