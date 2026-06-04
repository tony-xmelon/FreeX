# PivotTable Show Drill Option

## Goal

Bring PivotTable Options closer to Excel by modeling on-screen expand/collapse button visibility separately from the
existing print expand/collapse option.

## Checklist

- [x] Add failing command coverage for undoable display-button changes independent from print-button changes.
- [x] Add failing PivotTable Options dialog coverage for the Display-tab checkbox and dialog-result state.
- [x] Add failing XLSX package coverage for `showDrill` load/save independent from `printDrill`.
- [x] Implement `PivotTableModel.ShowExpandCollapseButtons` and thread it through command snapshots, dialog state,
      sheet cloning, and XLSX reader/writer.
- [x] Update architecture and command-parity documentation.

## Verification

- Red: focused Core.Model/App.Host/Core.IO tests failed because the model, command, dialog result, and XLSX
  `showDrill` option did not exist.
- Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ConfigurePivotTableOptionsCommand_UpdatesShowExpandCollapseButtonsAndUndoRestores|FullyQualifiedName~ConfigurePivotTableOptionsCommand_PreservesModeledAdvancedOptionsWhenCallerOmitsThem" -v minimal` passed 2 tests.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_ResultIncludesPrintingAndAltText|FullyQualifiedName~PivotTableOptionsDialog_FromPivotTable_UsesCurrentPivotSettings|FullyQualifiedName~PivotTableOptionsDialog_ExposesAccessKeysForModeledCheckboxes|FullyQualifiedName~PivotTableOptionsDialog_UsesExcelStyleTabbedOptionShell" -v minimal` passed 4 tests.
- Green: `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~XlsxAdapter_Save_WritesAuthoredPivotTablePackageParts" -v minimal` passed 1 test.
