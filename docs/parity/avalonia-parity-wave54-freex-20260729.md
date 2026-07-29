# FreeX Avalonia parity Wave 54: modifier cross-sheet formula pointing

## Scope

This slice closes the next bounded formula-reference workflow gap after Wave 53's plain
cross-sheet point mode:

- Avalonia keeps the source formula edit alive when a sheet-tab click uses Shift, Ctrl, or Meta
  modifiers, matching the WPF host's `_formulaEditCell` lifetime across grouped-tab navigation.
- Ctrl/Meta-clicking another cell while pointing appends a comma-separated disjoint area instead of
  replacing the existing reference.
- Appended references are qualified with the pointed sheet name when the target sheet differs from
  the formula source sheet, including names that require quoting.
- WPF and Avalonia now use the same `FormulaRangeEntryPlanner` append calculation, preventing
  cross-sheet qualification and tracked-span behavior from drifting between hosts.
- A subsequent point drag continues to replace only the newly appended reference span.

## Evidence

- `tests/FreeX.App.Services.Tests/R53_CrossSheetFormulaPointModeTests.cs` covers grouped modifier
  tab selection while preserving `FormulaEditAddress`.
- `tests/FreeX.App.Avalonia.Tests/R53_CrossSheetFormulaPointModeTests.cs` covers modifier tab
  navigation, cross-sheet qualified append, selected-range ownership, and cancel restoration.
- `tests/FreeX.App.Host.Logic.Tests/FormulaRangeEntryPlannerTests.RangeSelection.cs` covers the
  shared cross-sheet disjoint append and quoted sheet-name span.
- WPF authority: `src/FreeX.App.Host/MainWindow.Selection.cs` routes Ctrl-point append through the
  shared planner and `src/FreeX.App.Host/MainWindow.SheetTabs.cs` updates grouped tabs without
  committing the active formula edit.

## Remaining gaps

This does not attempt full formula grammar parity for every multi-area edit operation. Remaining
work includes keyboard-driven disjoint reference construction, 3-D sheet-span references, and
modifier-aware whole-row/whole-column multi-area pointing.
