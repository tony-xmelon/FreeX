# Avalonia Parity Wave 79 - FreeX - 2026-07-31

## Chosen functional gap

The Page Layout ribbon's `Scale Width`, `Scale Height`, and `Scale Percent` controls did not have WPF behavior in Avalonia.

WPF treats each selection as a value commit. It parses the selected text with `PageLayoutRibbonPolicyPlanner`, builds a grouped `SetScaleToFitCommand`, applies it to the selected worksheets, and refreshes the sheet. Avalonia registered the same three command ids through the generic page-layout action map, whose fallback opens the Page Setup dialog. Selecting a scale value therefore opened a dialog instead of applying the value.

This was an internal, user-visible functional mismatch. The generated command matrix did not expose it because these are value-bearing controls rather than click-only commands.

## Fix

- Added value-aware callbacks for the three scale controls to the Avalonia ribbon host.
- Registered those callbacks after the generic page-layout action map so they override the dialog fallback for the same command ids.
- Reused the shared WPF policy/parser and `PageLayoutRibbonCommandPlanner`.
- Applied the resulting `SetScaleToFitCommand` to the current grouped sheet selection and refreshed the Avalonia shell.
- Added a regression theory covering width, height, and percent selections. It verifies that the selected value reaches the value callback and that the Page Setup fallback is not invoked.

## Changed files

- `src/FreeX.App.Avalonia/Ribbon/AvaloniaRibbonHost.cs`
- `src/FreeX.App.Avalonia/MainWindow.cs`
- `src/FreeX.App.Avalonia/MainWindow.PageLayoutRibbon.cs`
- `tests/FreeX.App.Avalonia.Tests/AvaloniaRibbonHostCallbackTests.cs`

## Verification

Command:

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~AvaloniaRibbonHostCallbackTests" --logger "console;verbosity=minimal"
```

Result: 134 passed, 0 failed, 0 skipped.

## Residual

The shared Avalonia ribbon renderer still presents these controls as list selections, while WPF also supports free-form editable combo input and focus-loss/Enter commits. This slice closes the selected-value action mismatch; arbitrary typed scale text and full control-value resynchronization remain a separate functional/UI slice.
