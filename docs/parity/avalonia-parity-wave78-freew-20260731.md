# FreeW Avalonia parity wave 78

## Resolved functional mismatch

The WPF `freew.table` command is the primary action for the Insert > Table
dropdown. Its button face inserts a bordered 2x2 table at the caret, while the
arrow opens the table-size menu. Avalonia had the same command ID but registered
the primary action as an empty dropdown opener, so clicking the main button did
nothing even though the 2x2, 3x3, 4x4, and 5x2 menu entries worked.

Avalonia now inserts the same 2x2 default table from the primary action. The
focused registry test verifies the resulting model shape, including both rows
and both cells in each row.

## Changed files

- `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs`
- `freew/FreeW.App.Avalonia.Tests/InsertDropdownPrimaryActionParityTests.cs`
- `freew/FreeW.App.Avalonia/Editing/DocumentView.cs` (updated the stale default
  `ChartScene` initializer to the current shared scene contract so the project
  remains buildable after the upstream chart-scene field additions)

## Verification

The focused Release test command is:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~InsertDropdownPrimaryActionParityTests`

The focused command-registry lane also passed `52/52` tests with:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~CommandRegistryTests|FullyQualifiedName~InsertDropdownPrimaryActionParityTests"`

## Residuals

This slice covers the Insert > Table primary action only. The Avalonia cover
page, equation, caption, and other gallery controls remain separate parity
contracts and are not implied to be complete by this change. No Docker or
Microsoft Word COM validation was run for this bounded model-level fix.
