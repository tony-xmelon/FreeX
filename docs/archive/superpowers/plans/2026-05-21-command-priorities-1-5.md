# Command Priorities 1-5 Fidelity Loop

## Scope

Advance the five user-prioritized Commands parity areas with one bounded, test-backed fidelity slice each:

1. Export to PDF/XPS
2. Custom Number Format / locale fidelity
3. PivotTable
4. PivotChart
5. Tables / Format as Table

Each slice must be developed on an isolated `codex/` branch, verified with focused tests, merged to `main`, pushed, and documented before the next slice starts.

## Slice Plan

### 1. Export to PDF/XPS

- [x] Target the remaining publish-options gap without replacing the existing WPF print-renderer pipeline.
- [x] Prefer planner/exporter behavior that is easy to test without UI automation.
- [x] Update architecture and parity docs to distinguish supported options from still-raster PDF limitations.

### 2. Custom Number Format / Locale Fidelity

- [x] Continue the table-driven locale catalog rather than adding formatter branches.
- [x] Add deterministic coverage for a common LCID or accounting/custom-format behavior that currently falls back to invariant output.
- [x] Keep OS culture independence as an architectural constraint.

### 3. PivotTable

- [x] Improve model-first PivotTable fidelity in command/refresh code rather than adding UI-only state.
- [x] Prefer a slice that affects materialized output or persisted metadata and can be covered by Core.Model/Core.IO tests.
- [x] Keep external/OLAP/data-model pivot execution out of scope.

### 4. PivotChart

- [x] Improve bound PivotChart behavior while preserving the PivotTable connection.
- [x] Prefer modeled chart metadata or field-button/tooling state over decorative UI work.
- [x] Keep full Excel PivotChart Tools layout/design parity out of scope.

### 5. Tables / Format as Table

- [x] Improve structured table behavior through `StructuredTableModel` and commands.
- [x] Prefer totals-row or structured-reference behavior because docs identify it as the most visible remaining gap.
- [x] Keep full Excel table-style theme semantics out of scope for this loop.

## Verification Log

- PDF/XPS quality slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~ExportPlannerTests" -v minimal` failed because `ExportQuality` did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~ExportPlannerTests" -v minimal` passed 47 tests.
- XPS extensionless explicit-format slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "PlanExport_AppendsXpsExtensionForExplicitExtensionlessXpsRequests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because no explicit-format overload existed.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "ExportPlannerTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 49 tests.
- PDF/XPS ignore-print-areas slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "RenderWorksheet_CanIgnoreConfiguredPrintAreaForExport|ExportOptions_DefaultsToActiveSheetWithoutDocumentProperties|ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|ExportOptionsDialog_ExposesOnlyHonoredPdfXpsChoices" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v normal` failed because `IgnorePrintAreas` and `ignorePrintArea` did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "RenderWorksheet_CanIgnoreConfiguredPrintAreaForExport|ExportOptions_DefaultsToActiveSheetWithoutDocumentProperties|ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|ExportOptionsDialog_ExposesOnlyHonoredPdfXpsChoices" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 6 tests.
- PDF sheet-name bookmarks slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|PdfDocumentExporter_WritesRequestedBookmarksAndFiltersThemToPageRange" -v minimal` failed because `CreateBookmarks`, `PdfBookmark`, and the PDF exporter bookmark overload did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|PdfDocumentExporter_WritesRequestedBookmarksAndFiltersThemToPageRange" -v minimal` passed 4 tests.
- Custom-number East Asian LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcid" --logger "console;verbosity=detailed"` failed for Korean `412` date separators before catalog support.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_UsesKnownLcid" -v minimal` passed 39 tests.
- Custom-number Latin American Spanish LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed for Latin American Spanish LCIDs that still used invariant separators.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 55 tests.
- Custom-number Indian grouping slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `[$₹-4009]#,##0.00` rendered Western grouping as `₹1,234,567.89`.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 45 tests.
- Custom-number French Canada / Commonwealth LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed because `C0C` and `1C09` still rendered with invariant separators.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 63 tests.
- Custom-number native Indian LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed because `439`, `445`, `449`, `44A`, and `44E` used Western grouping and invariant date separators.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 71 tests.
- Custom-number Middle East / Southeast Asia LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` reported failing Vietnam `42A` and Indonesia `421` separator expectations before timing out.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 81 tests.
- Custom-number Balkan/Baltic LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed 19 cases for missing `402`, `408`, `418`, `41A`, `41B`, `424`, `425`, `426`, `427`, and `241A` separator mappings.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 101 tests.
- Custom-number Arabic/Persian LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed for Persian `429` decimal slash, Pashto `463` separators, and Moroccan Arabic `1801` date hyphen.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 117 tests.
- Custom-number African LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed for Afrikaans/Xhosa grouping, French Morocco/Senegal separators, and Afrikaans date hyphen.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 137 tests.
- Custom-number Central Asia/Caucasus LCID slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` failed 12 cases for missing `42B`, `42C`, `437`, `43F`, `440`, `443`, `450`, `454`, and `45B` separator mappings.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_UsesKnownLcidDecimalAndGroupSeparators|CustomNumberSubset_UsesKnownLcidDateSeparatorsForDateValues" -v minimal` passed 161 tests.
- Format Cells live number preview slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FormatCellsDialog_NumberTab_UpdatesSamplePreviewFromResolvedNumberFormat" -v minimal` failed because synthesized currency formats still previewed as static `1234.56`.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FormatCellsDialog_NumberTab_UpdatesSamplePreviewFromResolvedNumberFormat" -v minimal` passed 1 test.
- PivotTable empty-value display slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MatrixUsesEmptyValueTextForMissingIntersections" -v minimal` failed because `PivotTableModel.EmptyValueText` did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests|FullyQualifiedName~PivotTableCommandTests" -v minimal` passed 99 tests.
- PivotTable style gallery fidelity slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_ExposesBroaderPivotStyleGalleryAndPreservesCurrentStyle" -v normal` failed because only four style names were available and `PivotStyleMedium10`/`PivotStyleDark7` were missing.
  - Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MapsAdditionalBuiltInPivotStyleFamilies" -v minimal` failed because `PivotStyleMedium2` rendered as the generic medium fallback.
  - Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_ExposesBroaderPivotStyleGalleryAndPreservesCurrentStyle" -v minimal` passed 1 test.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotTableRefreshServiceTests.Refresh_MapsAdditionalBuiltInPivotStyleFamilies" -v minimal` passed 5 tests.
- PivotChart field-button visibility slice:
  - Red: `dotnet test FreeX\tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~ChartRendererTests.PivotChartRenderer_HidesIndividualFieldButtonAnnotations|FullyQualifiedName~ChartRendererTests.GridView_DoesNotHitTestIndividuallyHiddenPivotChartFieldButtons" -v minimal` failed because `ChartModel.ShowPivotChartValueFieldButtons` did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~ChartRendererTests" -v minimal` passed 62 tests.
- PivotChart Native JSON option persistence slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_PivotChartOptions" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because PivotChart flags loaded as default non-PivotChart values.
  - Green: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_PivotChartOptions" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Native JSON chart design metadata slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_ChartDesignMetadata" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `PivotFormatsXml` and related design metadata were not loaded.
  - Green: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "NativeJsonAdapter_RoundTrip_ChartDesignMetadata" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Table totals-row refresh slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~StructuredTableCommandTests.RefreshStructuredTableTotalsCommand_MaterializesLabelsAndCommonFunctionsWithUndo" -v minimal` failed because `RefreshStructuredTableTotalsCommand` did not exist.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~StructuredTableCommandTests" -v minimal` passed 10 tests.
- Structured-reference formula evaluation slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `Sales[Amount]` stopped at an unexpected `[` token.
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceDependencyTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` also initially hit a compiler output-file lock when run concurrently with the formula red test; subsequent verification is run sequentially.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceDependencyTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Structured-reference selector slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `#Headers`, `#Data`, and `#All` selectors resolved as unknown column names.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 5 tests after a transient `csc.exe -1` rerun with build servers shut down.
- Combined structured-reference selector slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because nested `[[#Section],[Column]]` references stopped at the first inner closing bracket.
  - Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter Serialize_CombinedStructuredReference --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because serialization over-escaped nested structured-reference brackets.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "StructuredReferenceFormulaTests|Serialize_CombinedStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 10 tests after clearing a transient blank compiler-server failure.
- Current-row structured-reference slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceCurrentRowTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `[@Amount]` evaluated as `#VALUE!`.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceCurrentRowTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "Serialize_CurrentRowStructuredReference|Serialize_TableQualifiedCurrentRowStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
- Multi-column structured-reference slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter MultiColumnStructuredReference_ResolvesColumnRange --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v normal` failed because multi-column selectors returned `#NAME?`.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "MultiColumnStructuredReference_ResolvesColumnRange|Serialize_MultiColumnStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 4 tests.
- `#This Row` structured-reference slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_ThisRowStructuredReference_UsesFormulaCellTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `Sales[[#This Row],[Amount]:[Tax]]` returned `#NAME?`.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_ThisRowStructuredReference_UsesFormulaCellTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Unqualified `#This Row` structured-reference slice:
  - Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_UnqualifiedThisRowStructuredReference_UsesContainingTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because standalone `[[#This Row],[Amount]:[Tax]]` parsed to `#VALUE!`.
  - Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_UnqualifiedThisRowStructuredReference_UsesContainingTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Custom Number CultureInfo LCID fallback slice:
  - Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "Format_LcidToken_FallsBackToDotNetCultureSeparatorsForUncatalogedLocale|Format_LcidCurrencyToken_PreservesSymbolWhenUsingCultureFallback" -v minimal` failed because uncataloged `0C07` still rendered with invariant `1,234.50`.
  - Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "Format_LcidToken_FallsBackToDotNetCultureSeparatorsForUncatalogedLocale|Format_LcidCurrencyToken_PreservesSymbolWhenUsingCultureFallback" -v minimal` passed 2 tests.
- PivotTable cache options UI slice:
  - Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ConfigurePivotTableOptionsCommand_UpdatesPivotCacheDataOptionsAndUndoRestores" -v minimal` failed because `ConfigurePivotTableOptionsCommand` had no `refreshOnOpen` parameter.
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotTableOptionsDialog_FromPivotTable_UsesConnectedCacheDataOptions|PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings" -v minimal` failed because the dialog result did not expose cache data options.
  - Green: focused Core.Model command test passed 1 test and focused App.Host dialog tests passed 2 tests.
- PDF/XPS bookmark format-scope slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyBookmarks|ExportOptionsDialog_ExposesKeyboardAccessKeys" -v minimal` failed because XPS summaries omitted selected bookmarks and the dialog label did not say PDF bookmarks.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyBookmarks|ExportOptionsDialog_ExposesKeyboardAccessKeys" -v minimal` passed 2 tests.
- Pivot value-field number-format preset slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` failed for missing comma, red-negative, date/time, elapsed-time, fraction, percentage, and compact scientific labels.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` passed 40 tests.
- Pivot value-field Format Cells seed slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolvePresetNumberFormatCode_MapsExcelStylePresetLabels" -v minimal` failed to compile because `ResolvePresetNumberFormatCode` did not exist.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsInputParserTests" -v minimal` passed 49 tests.
- Pivot value-field preset stale-code slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsDialog_PresetSelectionClearsStaleCustomFormatCode" -v minimal` failed because selecting Currency left the hidden custom code as `#,##0.0 "kg"`.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsDialog_PresetSelectionClearsStaleCustomFormatCode" -v minimal` passed 1 test.
- Pivot value-field built-in code resolution slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolveBuiltInNumberFormatIdForCode_MapsKnownPresetCodes" -v minimal` failed to compile because `ResolveBuiltInNumberFormatIdForCode` did not exist.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ResolveBuiltInNumberFormatIdForCode_MapsKnownPresetCodes" -v minimal` passed 8 tests.
- PivotTable compact row-label indentation slice:
  - Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ConfigurePivotTableOptionsCommand_UpdatesCompactRowLabelIndentAndUndoRestores|FullyQualifiedName~Refresh_CompactReportLayoutAppliesConfiguredRowLabelIndent" -v minimal` failed because `CompactRowLabelIndent` did not exist.
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~PivotTableOptionsDialog_CreateResult_CapturesModeledLayoutAndStyleSettings|FullyQualifiedName~PivotTableOptionsDialog_FromPivotTable_UsesCurrentPivotSettings|FullyQualifiedName~PivotTableOptionsDialog_ResultIncludesPrintingAndAltText|FullyQualifiedName~PivotTableOptionsDialog_LabelsEditableOptionsWithAccessKeyTargets|FullyQualifiedName~PivotTableOptionsDialog_UsesExcelStyleTabbedOptionShell" -v minimal` failed because the dialog did not expose the option.
  - Green: focused Core.Model tests passed 2 tests and focused App.Host tests passed 5 tests.
- Built-in number-format catalog slice:
  - Red: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "BuiltInNumberFormatCatalogTests" -v minimal` failed to compile because `BuiltInNumberFormatCatalog` did not exist.
  - Green: `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "BuiltInNumberFormatCatalogTests|PivotTableRefreshServiceTests" -v minimal` passed 80 tests.
- Pivot accounting format preset slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotValueFieldSettingsInputParserTests" -v minimal` failed 7 cases because accounting built-ins 41, 42, and 43 had no selectable labels.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "FullyQualifiedName~PivotValueFieldSettingsInputParserTests" -v minimal` passed 64 tests.
- Export explicit-format extension slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PlanExport_NormalizesMismatchedExtensionForExplicitFormatRequests" -v minimal` failed 4 cases because the explicit PDF/XPS save-dialog format preserved mismatched extensions.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportPlannerTests" -v minimal` passed 62 tests.
- Custom number single text-section slice:
  - Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_AppliesSingleTextSectionWhenItContainsPlaceholder" -v minimal` failed 3 cases because single-section text placeholders were ignored.
  - Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "NumberFormatterTests" -v minimal` passed 261 tests.
- Custom number escaped section-delimiter slice:
  - Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_HandlesEscapedLiteralsAndCommaScaling" -v minimal` failed because `0\;` rendered as `12` instead of `12;`.
  - Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_HandlesEscapedLiteralsAndCommaScaling" -v minimal` passed 6 tests.
- PDF metadata trim slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExportPlannerTests.PdfDocumentExporter_TrimsDocumentPropertiesBeforeWriting" -v minimal` failed because explicit PDF Info title metadata retained leading/trailing spaces.
  - Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExportPlannerTests.PdfDocumentExporter_TrimsDocumentPropertiesBeforeWriting" -v minimal` passed 1 test.
- PivotTable display expand/collapse option slice:
  - Red: focused Core.Model/App.Host/Core.IO tests failed because `PivotTableModel.ShowExpandCollapseButtons`, the dialog result parameter, command option, and XLSX `showDrill` round-trip did not exist.
  - Green: focused Core.Model command tests passed 2 tests, focused App.Host PivotTable option-dialog tests passed 4 tests, and the authored PivotTable package smoke test passed 1 test.
- Custom number escaped placeholders in quoted-affix formats slice:
  - Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_HandlesEscapedLiteralsAndCommaScaling" -v minimal` failed because `"ID "\0`, `"ID "\#`, and `"ID "\#0` treated escaped placeholder characters as numeric placeholders.
  - Review fix: preserve escapes for non-placeholder characters inside extracted numeric patterns and add guards for escaped `?`, escaped percent, and escaped comma.
  - Green: the same focused formatter test passed 12 tests; `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests" -v minimal` passed 268 tests.
- PDF/XPS minimum-size summary slice:
  - Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyMinimumSize" -v minimal` failed because XPS summaries said `minimum size`.
  - Green: focused export option summary tests passed 3 tests.
- PivotTable update formatting options slice:
  - Red: focused Core.Model/App.Host/Core.IO tests failed because the visible Autofit column widths and Preserve formatting options were not modeled.
  - Green: focused Core.Model command tests passed 2 tests, focused App.Host dialog tests passed 3 tests, and the authored PivotTable XLSX package smoke test passed 1 test.
