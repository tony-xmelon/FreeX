# FreeX Avalonia parity Wave 78

## Scope

This slice audits the FreeX quick access toolbar (QAT) against the WPF host after
synchronizing with `origin/main` at `ed62ffe9f22803cf6b7eaab0c915fad07ffaf508`.
The generated command inventory already reported complete command-ID coverage, so
the audit followed the actual click and enablement behavior.

## Gap found

WPF dispatches every `QuickAccessToolbarCommandIds` value directly to its host
action in `MainWindow.QuickAccessToolbar.cs`. Avalonia handled only Save, Undo,
and Redo directly. Every other QAT command fell through to a text search over the
currently rendered ribbon controls. That made commands whose owning ribbon tab was
not selected inert, despite being present and enabled in the QAT. The same fallback
also did not provide a reliable route for the Fill Color and Font Color palette
commands.

Avalonia also hardcoded `HasActiveWorksheet` and `HasSelection` to `true` while
refreshing QAT state. The WPF host derives those values from the live workbook and
selection, so the Avalonia state contract could become stale after a workbook or
selection transition.

## Fix

- Added direct Avalonia host dispatch for the full QAT catalog, including workbook
  workflows, editing, formatting, calculation, data, review, view, and palette
  commands.
- Kept the existing rendered-control fallback only for commands outside the direct
  catalog route.
- Derive Avalonia QAT worksheet and selection availability from the active workbook
  and `SelectedRanges` instead of constants.

## Verification

Focused Release regression:

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj \
  --configuration Release --no-restore \
  --filter FullyQualifiedName~AvaloniaQuickAccessToolbarFunctionalParityTests

Passed: 1, Failed: 0, Skipped: 0, Total: 1
```

The broader Avalonia QAT-focused filter also passed:

```text
Passed: 4, Failed: 0, Skipped: 0, Total: 4
```

The regression configures `Calculate Sheet` as the only QAT command, creates an
explicit active worksheet and selection, and invokes the same dispatch entry point
used by the Avalonia button. It verifies that the command reports the recalculation
status without selecting the Formulas ribbon tab.

## Residuals

This slice does not change the shared command catalog, generated parity inventories,
or the separate QAT history/customization context-menu implementation. The
existing history and customization menus remain covered by their current tests.
