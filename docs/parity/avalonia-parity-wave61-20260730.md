# FreeX Avalonia Parity Wave 61

## Scope

This slice closes the deep multi-area formula-edit residual after Wave 56's keyboard-created append path. The exercised operation edits an already-authored quoted two-area formula: `F5` is retained, `H7` is changed to `I7` through a reverse caret selection, and a plain point click replaces that existing area with `J7`.

The audit used the shared `FormulaRangeEntryPlanner`, the WPF authority in `src/FreeX.App.Host/MainWindow.FormulaReferenceEditing.cs`, and the Avalonia implementation in `src/FreeX.App.Avalonia/MainWindow.cs`. WPF preserves the live span through text/caret changes. Avalonia previously cleared it during the formula-box text path and could also clear it during transient reverse-selection notifications, causing the next point click to insert a third reference.

## Implementation

- Avalonia no longer unconditionally clears the formula reference span on formula-box text changes.
- Reverse Avalonia selections are retained while their independent selection property notifications settle.
- Ordinary Avalonia point replacement recovers the trailing authored reference through the shared quoted-reference span planner when transient input has lost tracking.
- The managed test uses a reverse `SelectionStart`/`SelectionEnd` pair and asserts exact formula text, saved formula, result, and selected replacement area.
- The physical selector is `formula-multi-area-edit`; it verifies the red formula-reference outline at `Revenue Data!J7` before commit, then reads the committed formula/result from `Sheet2!G10`.

No shared cross-app files were changed.

## Verification

Managed focused test:

`dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~FormulaPointEdit_PreservesQuotedAreaSpanBeforeReplacingExistingArea --logger "console;verbosity=minimal"`

Result: passed, `1/1`.

Focused R53 suite:

`dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~R53_CrossSheetFormulaPointModeTests --logger "console;verbosity=minimal"`

Result: passed, `9/9`.

Physical Linux/X11 lane:

`powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector formula-multi-area-edit -Port 6089 -TimeoutMinutes 20`

Result: passed, `1/1`; owned container stopped cleanly.

Exact physical postconditions:

- saved formula: `=SUM('Revenue Data'!F5,'Revenue Data'!J7)`
- calculated result: `30`
- selection before readback: `Revenue Data!J7`

Retained evidence:

- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-authored.png`
- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-caret.png`
- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-replaced.png`
- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-selected.png`
- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-committed.png`
- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/formula-multi-area-edit-postcondition.txt`
- `artifacts/linux-interactive/freex/interaction-validation/20260729T224733Z/interaction-validation.json`
- `artifacts/linux-interactive/freex/interaction-validation/20260729T224733Z/interaction-validation.html`

## Residuals

The selector intentionally does not duplicate the Wave 56 F8/Shift+F8 append workflow. It covers the existing-area mutation/replacement path only. Broader formula grammar, drag-edit, and non-quoted reference variants remain outside this Wave 61 slice.
