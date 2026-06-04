# PivotTable Compact Indent Fidelity

## Scope

- [x] Model Excel's "When in compact form indent row labels" PivotTable option as command-owned state.
- [x] Apply the option to generated compact PivotTable output without mutating label text.
- [x] Surface the option in the PivotTable Options dialog and preserve it through command undo.
- [x] Persist the option through authored/loaded XLSX pivot table metadata.

## Verification Log

- Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ConfigurePivotTableOptionsCommand_UpdatesCompactRowLabelIndentAndUndoRestores|FullyQualifiedName~Refresh_CompactReportLayoutAppliesConfiguredRowLabelIndent" -v minimal` failed because `PivotTableModel.CompactRowLabelIndent` and the command parameter did not exist.
- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings|FullyQualifiedName~PivotTableOptionsDialog_FromPivotTable_UsesCurrentPivotSettings|FullyQualifiedName~PivotTableOptionsDialog_ResultIncludesPrintingAndAltText|FullyQualifiedName~PivotTableOptionsDialog_LabelsEditableOptionsWithAccessKeyTargets|FullyQualifiedName~PivotTableOptionsDialog_UsesExcelStyleTabbedOptionShell" -v minimal` failed because the dialog result and control did not expose compact indentation.
- Review fix: `ConfigurePivotTableOptionsCommand` and the host PivotTable option wrapper preserve compact indent, print options, and alt text when callers omit those advanced options; the full Options dialog passes explicit values.
- Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableCommandTests|FullyQualifiedName~PivotTableRefreshServiceTests" -v minimal` passed 106 tests.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotWorkflowDialogTests|FullyQualifiedName~MainWindowXamlKeyTipTests" -v minimal` passed 129 tests.
- Green: `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~XlsxAdapter_Save_WritesAuthoredPivotTablePackageParts" -v minimal` passed 1 test.
- Green: `dotnet build FreeX.slnx --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v minimal` passed.

## Architecture Decision

Compact indentation is represented as `CellStyle.IndentLevel` on generated compact row-label cells, not as leading spaces in the label value. The model stores the requested indentation once on `PivotTableModel`, and refresh applies it after PivotTable visual styling so style palettes, number formats, and indentation compose through the normal style registry.
