# Avalonia Parity Wave 52: FreeX

## Slice

Formula point-mode selection was incomplete in Avalonia. Clicking a worksheet
cell while editing a formula updated the formula text and reference adornment,
but the session selection and name box stayed on the formula source cell. WPF
keeps those concepts separate: the pointed range is selected while the source
cell remains the formula edit target.

## Implementation

- Added `WorkbookSession.SelectRangeForFormulaEdit`, which selects the pointed
  range while preserving `FormulaEditAddress`.
- Updated Avalonia formula range entry to use that transition and refresh the
  name-box range and selection statistics without rebuilding the live inline
  editor.

## Verification

- `dotnet test tests/FreeX.App.Services.Tests/FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~R52_FormulaPointModeSelectionTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"`
  - 1 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~RawFormulaBarPointModeClick_AfterF2Toggle_InsertsReferenceAndCommitsFormula --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"`
  - 1 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~RawInlinePointMode --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"`
  - 2 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~PointMode" --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"`
  - 7 passed.

## Residual

This slice covers the formula-bar and inline-editor point-mode selection state.
Broader pointer workflows such as autofill, selection move-drag, and cross-sheet
visual comparison remain separate parity slices.
