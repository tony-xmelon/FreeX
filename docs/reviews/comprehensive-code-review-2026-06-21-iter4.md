# Comprehensive Code Review - 2026-06-21 Iteration 4

Branch: `codex/review-iterate-20260621-4`

Base reviewed: `origin/main` at `99b9be54b`.

Scope: follow-up review/fix cycle after iteration 3, focused on workflow guard edge cases, default test lane coverage, review documentation indexing, FreeW MHTML image reuse, and workbook command no-op behavior.

## Findings

### P2 - pull_request_target guard missed quoted YAML `on` keys

The workflow preflight guarded unquoted `on:` keys and inline trigger values, but YAML permits quoted keys such as `"on": "pull_request_target"` and `'on': ['push', 'pull_request_target']`. Those forms could still introduce a privileged `pull_request_target` workflow while preflight passed.

Fix: the inline workflow-trigger parser now matches quoted and unquoted `on` keys before checking for scalar, list, or inline-map `pull_request_target` values. Host workflow tests cover double-quoted and single-quoted key variants.

### P2 - Free.Shared.Pdf.Tests was not in the default test lane

`Free.Shared.Pdf.Tests` existed and built with the full solution, but `FreeX.DefaultTests.slnx` did not include it. The default agent/CI lane could therefore pass while shared PDF regressions were only caught by direct project runs or broad ad hoc testing.

Fix: `Free.Shared.Pdf.Tests` is now part of `FreeX.DefaultTests.slnx`. Repository preflight also validates the default test solution against non-UI test projects so future in-scope test projects cannot silently drift out of the default lane. The existing lane-membership guard was updated to include the PDF test project.

### P2 - docs/README review index omitted the current June 21 reports

The cumulative review log linked the newest June 21 reports, but the top-level docs index still stopped at the prior clean pass. Review artifacts were therefore harder to discover from the main documentation map.

Fix: `docs/README.md` now links the June 21 iteration reports, including this iteration.

### P2 - Reused MHTML image parts shared per-use metadata

FreeW MHTML import reused the same `InlineImage` instance when multiple `<img>` tags referenced one content part. Width, height, and alt text are per-use HTML attributes, so the second reference could overwrite the first reference's metadata.

Fix: the HTML/MHTML adapter clones the cached image payload before applying per-use attributes. Regression coverage verifies two references to the same MHTML image part keep distinct dimensions and alt text while sharing the same underlying bytes.

### P2 - No-op sheet moves could dirty workbooks and create undo history

The WPF Move or Copy Sheet path could execute a single-sheet move to the same location. `MoveSheetsCommand` reported success even when the order was unchanged, so command execution could mark the workbook dirty and create an undo entry for a no-op action.

Fix: command outcomes now carry an `IsNoOp` flag. The command bus, host execution path, `MoveSheetCommand`, and `MoveSheetsCommand` treat unchanged moves as successful no-ops that do not push undo entries, repeatable commands, notifications, dirty state, or recalculation invalidation.

## Focused Verification

- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~SheetTabCommandTests" -v:minimal` - passed, 9 tests.
- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~HtmlMhtmlRoundTripTests" -v:minimal` - passed, 10 tests.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflightTests|FullyQualifiedName~SolutionProjectsPreflightTests|FullyQualifiedName~RepositoryPreflightTests" -v:minimal` - passed, 64 tests.
- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~TestLaneSolutionTests" -v:minimal` - passed, 3 tests after the full default lane exposed the stale expected project list.

## Full Verification

Before the lane-membership test expectation was updated:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - failed one guard test, `DefaultTestLane_ExcludesUiTestProjects`, because it still expected the pre-fix default lane project list.

After updating the lane-membership guard:

- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,939 passed, 131 skipped, and 0 failed across 13 TRX files.

