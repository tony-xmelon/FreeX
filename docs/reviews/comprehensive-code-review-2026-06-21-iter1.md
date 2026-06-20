# Comprehensive Code Review - 2026-06-21 Iteration 1

Branch: `codex/review-iterate-20260621-1`

Base reviewed: `origin/main` at `537ac1e3c`.

Scope: restarted review/fix cycle after the 2026-06-19 clean pass, focused on the high-churn range from `bce588455..537ac1e3c`: legacy XLS import fidelity, FreeW HTML/MHTML and document-format adapters, LibreOffice-backed format cross-checking, GitHub workflow coverage, and recently changed verification/docs hygiene.

## Findings

### P1 - Direct main pushes skipped the primary CI lane

`.github/workflows/ci.yml` only ran on `pull_request`. The repo policy now merges verified agent work directly to `main`, so a pushed `main` commit could bypass hosted preflight/build/default-test validation entirely.

Fix: primary CI now runs on direct pushes to `main` as well as pull requests. `tools/Test-GitHubWorkflows.ps1` and `GitHubWorkflowPreflightTests` now guard this.

### P1 - FormatCrossCheck exited green on hard validation failures

`FreeX.FormatCrossCheck` only counted `OutputDefect` rows as failures. `FreeXError` and `LibreOfficeOpenFailed` rows were printed but still allowed exit code 0, hiding exactly the external-consumer failures the tool exists to catch.

Fix: hard FreeX/LibreOffice validation failures now return exit code 1 and are counted separately in the report.

### P2 - FormatCrossCheck could validate zero formats after a bad filter

An invalid `--format` value filtered every result row out after `RunAll`, leaving no reported rows and no defects, then returning success.

Fix: per-source filtered runs with zero matching formats are reported, and a run with zero checked source x format rows returns exit code 2.

### P2 - HTML export corrupted vertical merges longer than two rows

`HtmlFileAdapter` skipped all `VerticalMergeState.Continue` cells but always emitted `rowspan="2"` for the restart cell. A three-row merge therefore dropped the third-row continuation while telling HTML consumers the cell spanned only two rows.

Fix: HTML export now computes the actual continuation run length before writing `rowspan`.

### P2 - HTML import shifted cells when rowspan and colspan combined

HTML import recorded a pending rowspan only for the first column of a `rowspan`/`colspan` cell. A `rowspan=2 colspan=2` cell reserved one column in the next row instead of two, shifting later cells left.

Fix: pending rowspans now carry their grid span, and continuation cells reserve the full covered width.

### P2 - XLS multi-range selections could be dropped when active cell was A1

The legacy XLS importer stores native selection metadata for multi-range selections, but it does not set modeled `ActiveRow`/`ActiveCol` for the default `A1` active cell. On XLSX save, native selection metadata was only merged into an existing modeled selection; when none existed, the multi-range selection was lost.

Fix: the primary view metadata writer now re-emits a native `<selection>` when no modeled selection exists, while still avoiding stale native selection resurrection after modeled active-cell changes.

### P2 - XLS window protection was promoted to structure protection

The XLS importer set `Workbook.IsStructureProtected` when either `ProtectRecord` or `WindowProtectRecord` was present. Window protection is separate native metadata, so a window-only protected workbook could incorrectly block sheet-structure operations and save as `lockStructure`.

Fix: `IsStructureProtected` now tracks only the structure protection record; `lockWindows` remains preserved as workbook protection metadata.

### P2 - FreeW/FreeP push filters omitted central props

`freew-ci.yml` and `freep-ci.yml` included `Directory.Build.props` and `Directory.Packages.props` for PRs, but not for direct pushes to `main`. Central warning/package changes could therefore bypass the dedicated FreeW/FreeP lanes.

Fix: both push filters now include the central props, and workflow preflight enforces them.

## Focused Verification

- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~HtmlMhtmlRoundTripTests" -v:minimal` - passed, 7 tests.
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~LegacyXlsFileAdapterTests|FullyQualifiedName~XlsxAdapter_Save_WritesNativeSelectionWhenNoModeledActiveCellExists" -v:minimal` - passed, 27 tests.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflightTests|FullyQualifiedName~FormatCrossCheckSourceTests" -v:minimal` - passed, 39 tests.
- `dotnet build tools\FreeX.FormatCrossCheck\FreeX.FormatCrossCheck.csproj --configuration Release -v:minimal` - passed with 0 warnings and 0 errors.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-GitHubWorkflows.ps1` - passed, 9 workflow files validated.

## Full Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,925 passed, 131 not executed/skipped, and 0 failed.
