# PivotTable Update Format Options

## Goal

Turn the visible PivotTable Options checkboxes for "Autofit column widths on update" and "Preserve cell formatting on
update" into modeled, undoable PivotTable state instead of UI-only defaults.

## Checklist

- [x] Add red dialog tests proving the options flow through `PivotTableOptionsDialogResult`.
- [x] Add red command tests proving the options are updated and restored by undo while quick callers preserve them.
- [x] Add red XLSX package coverage for `applyWidthHeightFormats` and `preserveFormatting`.
- [x] Thread options through `PivotTableModel`, sheet clone, command snapshot, host dialog wrapper, and XLSX reader/writer.
- [x] Update architecture and command-parity documentation.

## Verification

- Red: focused Core.Model/App.Host/Core.IO tests failed because the visible Autofit column widths and Preserve formatting
  options were not modeled.
- Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ConfigurePivotTableOptionsCommand_UpdatesFormatOptionsAndUndoRestores|FullyQualifiedName~ConfigurePivotTableOptionsCommand_PreservesModeledAdvancedOptionsWhenCallerOmitsThem" -v minimal` passed 2 tests.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings|FullyQualifiedName~PivotTableOptionsDialog_FromPivotTable_UsesCurrentPivotSettings|FullyQualifiedName~PivotTableOptionsDialog_ResultIncludesPrintingAndAltText" -v minimal` passed 3 tests.
- Green: `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~XlsxAdapter_Save_WritesAuthoredPivotTablePackageParts" -v minimal` passed 1 test.
