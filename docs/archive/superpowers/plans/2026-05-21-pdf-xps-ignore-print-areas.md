# PDF/XPS Ignore Print Areas

## Scope

- [x] Add an Excel-style "Ignore print areas" option to the PDF/XPS export model and dialog.
- [x] Include the option in export summaries for PDF and XPS.
- [x] Route active-sheet and workbook exports through `PrintRenderer` with print areas ignored when requested.
- [x] Keep explicit selected-range export precedence over the ignore-print-areas flag.
- [x] Keep bookmark generation and selectable/vector PDF text out of scope.

## Architectural Decision

`ExportOptions` owns the publish option, and `PrintRenderer` owns the actual range selection behavior. The renderer now accepts `ignorePrintArea`; when no explicit selection range is supplied, it chooses either `Sheet.PrintArea` or the used range according to that flag. Workbook export passes the same option to each visible worksheet so PDF fixed documents and XPS paginators stay aligned.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "RenderWorksheet_CanIgnoreConfiguredPrintAreaForExport|ExportOptions_DefaultsToActiveSheetWithoutDocumentProperties|ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|ExportOptionsDialog_ExposesOnlyHonoredPdfXpsChoices" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v normal` failed because `IgnorePrintAreas` and `ignorePrintArea` did not exist.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "RenderWorksheet_CanIgnoreConfiguredPrintAreaForExport|ExportOptions_DefaultsToActiveSheetWithoutDocumentProperties|ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|ExportOptionsDialog_ExposesOnlyHonoredPdfXpsChoices" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 6 tests.
