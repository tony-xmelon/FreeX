# PDF/XPS Bookmark Format Scope

## Goal

Make the existing export bookmark option honest across formats: PDF writes sheet-name outlines, while XPS does not expose an equivalent modeled bookmark pipeline.

## Decisions

- Keep `ExportOptions.CreateBookmarks` as the shared option because the publish dialog is format-adjacent and already feeds both PDF and XPS requests.
- Treat bookmarks as PDF-only at the planner boundary. PDF summaries keep "bookmarks use sheet names"; XPS summaries now say "bookmarks are PDF-only" when the user selected the option.
- Label the dialog checkbox as "Create PDF bookmarks using sheet names" so the limitation is visible before export.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyBookmarks|ExportOptionsDialog_ExposesKeyboardAccessKeys" -v minimal` failed for the missing XPS summary text and old dialog label.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportOptions_DescribeWithXpsFormatExplainsPdfOnlyBookmarks|ExportOptionsDialog_ExposesKeyboardAccessKeys" -v minimal` passed 2 tests.
