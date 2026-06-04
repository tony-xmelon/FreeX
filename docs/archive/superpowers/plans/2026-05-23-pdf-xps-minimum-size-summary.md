# PDF/XPS Minimum-Size Summary

## Goal

Make export option summaries clearer when users choose XPS with the minimum-size quality option. Minimum-size changes
the PDF raster DPI; XPS uses the fixed-document print pipeline, so the XPS summary should identify that option as
PDF-only.

## Checklist

- [x] Add red host test for XPS minimum-size summary text.
- [x] Keep generic/PDF option summaries unchanged.
- [x] Route format-aware summaries through a quality description helper.
- [x] Update architecture and command-parity documentation.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyMinimumSize" -v minimal` failed because XPS summaries said `minimum size`.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyMinimumSize|FullyQualifiedName~ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyBookmarks|FullyQualifiedName~ExportOptions_DescribeSelectionAndOpenAfterPublish" -v minimal` passed 3 tests.
