# Comprehensive Code Review - 2026-06-21 Iteration 2

Branch: `codex/review-iterate-20260621-2`

Base reviewed: `origin/main` at `c07ef5276`.

Scope: follow-up review/fix cycle after iteration 1, focused on sibling issues around workbook protection metadata, FreeW HTML/MHTML import fidelity, repository workflow/preflight coverage, and the Avalonia Move or Copy Sheet workflow.

## Findings

### P2 - XLSX lockWindows was promoted to structure protection

`XlsxWorkbookMetadataReader` treated `lockWindows` and `revisionsPassword` as workbook structure protection. That contradicted the XLS fix from iteration 1 and could incorrectly block structure operations after loading a window-only or revision-only protected XLSX workbook.

Fix: XLSX load now models only `lockStructure` and `workbookPassword` as `Workbook.IsStructureProtected` / `StructureProtectionPassword`. Window and revision protection remain preserved as native workbook protection metadata.

### P2 - FreeW/FreeP projects could escape solution preflight

`Test-RepositoryPreflight.ps1` only invoked `Test-SolutionProjects.ps1` for `FreeX.slnx`. A new `freew/` or `freep/` project omitted from `FreeW.slnx` or `FreeP.slnx` would not be caught by repository preflight.

Fix: solution-project preflight now supports explicit project path prefixes, and repository preflight validates `FreeX.slnx`, `FreeW.slnx`, and `FreeP.slnx`.

### P2 - pull_request_target guard missed inline workflow syntax

`Test-GitHubWorkflows.ps1` rejected block-style `pull_request_target:` events but missed valid inline syntax such as `on: pull_request_target` and `on: [push, pull_request_target]`.

Fix: workflow preflight now rejects block, scalar, and inline-list `pull_request_target` forms. Host tests cover all guarded forms.

### P2 - MHTML import dropped Content-Location images

`MhtmlFileAdapter` indexed image parts only by `Content-Id`, while HTML import passed non-`cid:` image `src` values to the resolver. Real MHTML that references embedded images by `Content-Location` or filename therefore lost images on load.

Fix: MHTML image parts are indexed by content ID, content location, and filename-derived keys.

### P2 - Nested HTML table rows were promoted into the outer table

`HtmlFileAdapter` used descendant `tr` selection for a table, so rows from nested tables became additional rows in the outer table. Nested table content could also be dropped from a cell when the cell already had another paragraph.

Fix: HTML table import now reads only direct table rows from the table or its direct `thead`/`tbody`/`tfoot` children, and flattens nested table text into the containing cell.

### P2 - Avalonia copy-sheet destinations after the source landed too early

The Avalonia Move or Copy Sheet copy path duplicated the active sheet, then reused move-specific target index math. Copying a sheet before a later sheet or to the end could land the copy before the requested destination.

Fix: `MoveCopySheetPlanner` now has copy-specific target resolution for the post-duplicate sheet order, and the Avalonia host uses it.

## Focused Verification

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflightTests|FullyQualifiedName~SolutionProjectsPreflightTests|FullyQualifiedName~RepositoryPreflightTests" -v:minimal` - passed, 57 tests.
- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~HtmlMhtmlRoundTripTests" -v:minimal` - passed, 9 tests.
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~XlsxAdapter_LoadedWorkbookSave_PreservesWindowProtectionWithoutStructureProtection|FullyQualifiedName~XlsxAdapter_LoadedWorkbookSave_PreservesRevisionWorkbookProtectionPassword|FullyQualifiedName~XlsxAdapter_RoundTrip_WorkbookStructureProtection" -v:minimal` - passed, 3 tests.
- `dotnet test tests\FreeX.App.Presentation.Tests\FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~MoveCopySheetPlannerTests" -v:minimal` - passed, 15 tests.

## Full Verification

After syncing with `origin/main` at `c07ef5276`:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors. An earlier build attempt failed because stale `testhost` PID 1488 from an interrupted Avalonia test run locked output files; that stale process was identified, stopped, and the rerun passed.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,932 passed, 131 not executed/skipped, and 0 failed across 12 TRX files.
