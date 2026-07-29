# Avalonia Parity Wave 53: FreeX

## Slice

Cross-sheet formula point-mode selection now keeps the formula source cell as
the edit and commit target while the visible worksheet and selection move to a
pointed range on another sheet.

## Implementation

- Added a shared `WorkbookSession.SelectSheetForFormulaEdit` transition so
  Avalonia worksheet-tab navigation preserves the live formula edit.
- Extended the shared formula range-entry planner to qualify cross-sheet
  references and quote sheet names through `SheetNameFormatter`.
- Allowed shared formula commits to land on a source sheet different from the
  currently visible pointed sheet, and restored that source context on cancel.
- Added service, shared planner, and Avalonia headless coverage for selection,
  quoting, commit, and cancel behavior.

## Residual

This slice covers ordinary and keyboard worksheet-tab navigation while formula
point mode is active. Sheet grouping/modifier selection and broader formula
reference workflows remain outside the bounded point/commit route.

## Verification

- `FreeX.App.Services.Tests`: `R53_CrossSheetFormulaPointModeTests` 2/2 and
  `R52_FormulaPointModeSelectionTests` 1/1.
- `FreeX.App.Host.Logic.Tests`: `FormulaRangeEntryPlannerTests` 21/21.
- `FreeX.App.Avalonia.Tests`: `R53_CrossSheetFormulaPointModeTests` 1/1 and
  `AvaloniaWorksheetKeyboardEditingTests` 8/8.
- Avalonia test project Release build: 0 warnings, 0 errors.
