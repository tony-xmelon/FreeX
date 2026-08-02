# Avalonia Parity Wave 106 - FreeX - 2026-08-02

## Scope

Closed the Wave79 residual for the Page Layout ribbon's `Scale Width`, `Scale Height`, and `Scale Percent` controls.

## Behavior

- Avalonia editable ribbon combos now commit arbitrary typed values on Enter and on focus loss.
- Selection commits remain single-shot when the control immediately loses focus; a selection event is not duplicated by the subsequent focus event.
- The existing shared `PageLayoutRibbonPolicyPlanner` and `PageLayoutInputParser` remain the only parsing and policy path. Page counts accept typed values such as `4 pages`; scale percentages accept typed values such as `175%` within the shared 10%-400% bounds.
- The three FreeX scale commands now expose live state through the existing Avalonia ribbon state refresh hook. Full shell refreshes therefore resynchronize the displayed values after selection, sheet changes, workbook replacement, and command application.
- Invalid typed input restores the current valid display value, matching the WPF host behavior.

## Changed files

- `shared/Free.Shared.Ribbon.Avalonia/AvaloniaRibbonRenderer.cs`
- `src/FreeX.App.Avalonia/MainWindow.cs`
- `src/FreeX.App.Avalonia/MainWindow.PageLayoutRibbon.cs`
- `src/FreeX.App.Avalonia/Ribbon/AvaloniaRibbonHost.cs`
- `tests/FreeX.App.Avalonia.Tests/AvaloniaEditableRibbonComboParityTests.cs`
- `tests/FreeX.App.Avalonia.Tests/AvaloniaRibbonHostCallbackTests.cs`

## Verification

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~AvaloniaEditableRibbonComboParityTests|FullyQualifiedName~AvaloniaRibbonHostCallbackTests"
```

Result: 137 passed, 0 failed, 0 skipped.

The test project restored successfully before the focused run because this linked worktree initially had no `project.assets.json`. Docker and generated parity reports were intentionally not run or modified for this scoped slice.
