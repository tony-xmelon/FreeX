# Comprehensive Code Review - 2026-06-21 Iteration 3

Branch: `codex/review-iterate-20260621-3`

Base reviewed: `origin/main` at `7e54c16e9`, then synced with `origin/main` at `e922b4e9f`.

Scope: follow-up review/fix cycle after iteration 2, focused on workflow guard bypasses, the Avalonia Move or Copy Sheet copy path, and FreeW DOCX package metadata preservation.

## Findings

### P2 - pull_request_target guard missed quoted inline workflow syntax

`Test-GitHubWorkflows.ps1` rejected block-style `pull_request_target:` and unquoted inline `on:` forms, but still missed valid quoted scalar, quoted inline-list, and inline-mapping syntax such as `on: "pull_request_target"` or `on: [push, "pull_request_target"]`.

Fix: workflow preflight now normalizes inline `on:` values and rejects `pull_request_target` in scalar, list, quoted, and inline-map forms. Host workflow tests cover the guarded variants.

### P2 - Copied sheets landed one slot too far right after the source

The Avalonia Move or Copy Sheet copy path duplicated the active sheet immediately after the source, then added one to later insert-before targets. `MoveActiveSheetTo` removes the active duplicate before inserting it, so copying `Jan` before `Mar` in `[Jan, Feb, Mar]` landed at the end instead of before `Mar`.

Fix: copy target resolution now uses the requested insert-before index directly for in-workbook destinations and maps only the terminal "move to end" target to the new last index.

### P2 - FreeW DOCX round-trip dropped package document metadata

FreeW read only modeled core document properties plus FreeW-owned custom properties from `docProps/custom.xml`. It did not preserve `docProps/app.xml` or arbitrary custom document properties, so opening and saving a Word DOCX could silently drop extended properties such as Application, Company, Template, and workflow/custom labels.

Fix: FreeW now preserves `docProps/app.xml` as a package-level preserved part, keeps its content-type override and package relationship, and captures the original `docProps/custom.xml` root as the base for custom properties. The writer overlays FreeW's watermark and mark-as-final properties without dropping existing custom properties.

## Focused Verification

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflightTests" -v:minimal` - passed, 44 tests. An earlier run failed until the inline `on:` guard was switched to line-by-line normalization.
- `dotnet test tests\FreeX.App.Presentation.Tests\FreeX.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~MoveCopySheetPlannerTests" -v:minimal` - passed, 15 tests.
- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" -v:minimal` - passed, 8 tests.

## Full Verification

After the initial fix commit and before syncing the two incoming XLS metadata commits:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - the command wrapper timed out after 20 minutes while a child testhost remained active in `FreeX.App.Avalonia.Tests`; the stale owned run was stopped before resync.

After syncing with `origin/main` at `e922b4e9f`:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,933 passed, 131 skipped, and 0 failed across 12 TRX files.
