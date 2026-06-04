# PDF Sheet-Name Bookmarks

## Goal

Close the PDF bookmark option gap for the supported print-renderer export path.

## Scope

- [x] Add `ExportOptions.CreateBookmarks`.
- [x] Expose "Create bookmarks using sheet names" in the PDF/XPS export options dialog.
- [x] Write PDF outline entries through PDFsharp for requested sheet-name bookmarks.
- [x] Filter and re-index bookmarks after page-range export so outlines only target exported pages.
- [x] Keep heading-based bookmarks, selectable/vector PDF text, and full Excel publish options out of scope.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|PdfDocumentExporter_WritesRequestedBookmarksAndFiltersThemToPageRange" -v minimal` failed because `CreateBookmarks`, `PdfBookmark`, and the PDF exporter bookmark overload did not exist.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeSelectionAndOpenAfterPublish|ExportOptionsDialog_CreateResult_NormalizesExcelOptions|ExportOptionsDialog_ExposesKeyboardAccessKeys|PdfDocumentExporter_WritesRequestedBookmarksAndFiltersThemToPageRange" -v minimal` passed 4 tests.
