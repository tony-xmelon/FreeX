# FreeX Comprehensive Code Review - 2026-06-19

## Scope And Method

Review and fix cycle performed on branch `codex/review-cycle-20260619` from `main` HEAD `546f687e98976d39a154a1c9e38dca56736d723f`, then integrated into `main` and synced with `origin/main` HEAD `ece81198d928d2e16b5803ac9acdd4ccfab1553b` before final verification.

This pass focused on code paths with high data-fidelity or release-risk surface:

| Pass | Scope |
|---|---|
| 1 | Formula dependency tracking, named formulas, and dynamic-array used ranges |
| 2 | XLSX load/save warning fidelity, package relationship validation, and smoke tooling XML parsing |
| 3 | App update metadata, WPF shutdown resilience, solution membership preflight, and build readiness |

All findings below were fixed in the same branch. Several candidate issues were reviewed and dismissed after source inspection; those are recorded at the end so future cycles do not rediscover them cold.

Severity legend:

- **P1**: likely stale or wrong workbook data in normal workflows.
- **P2**: real defect with narrower trigger or partial mitigation.
- **P3**: hardening, consistency, or maintainability issue with lower immediate user impact.

## Findings And Resolution

| Priority | Area | Finding | Resolution |
|---|---|---|---|
| P1 | Calc / named formulas | Cells depending on workbook named formulas did not register dependencies on the cells referenced inside those named formulas. Editing `A1` could leave a cell containing `=DoubleInput` stale when `DoubleInput` was defined as `A1*2`; volatile named formulas also were not tracked as volatile dependents. | `RecalcEngine.CollectReferences` now recursively parses named formulas, cycle-guards them, and contributes their references/volatile state to the dependency graph. Added named-formula dependency and volatile regressions. |
| P1 | Calc / dynamic arrays | Used-range discovery ignored `_spillValues`, so full-column aggregates such as `SUM(A:A)` could miss values spilled into `A2:A3` when those addresses had no real cells. | Spill target writes now update used-range tracking, spill clears retract it, and `Sheet.GetUsedRange()` considers non-blank spill targets. Added a full-column aggregate spill regression. |
| P2 | XLSX load warnings | `LoadWithWarnings` could still silently skip individual data-validation or named-range mapping failures because the per-item mapper catches did not receive the warnings collection. | Data-validation and named-range mappers now accept `warnings` and report skipped individual items while preserving best-effort load. Added source guards that require warning propagation. |
| P2 | XLSX package health | Relationship target validation unescaped the whole target before path normalization, turning `%2F` and `%5C` into separators. This could mis-resolve a valid encoded package part path. | Relationship validation now checks literal dot-segment escapes before resolving through `XlsxPackagePath`, preserving encoded path separators. Added an encoded-separator package-health regression. |
| P2 | XLSX smoke tooling | `tools/FreeX.ExcelOpenSmoke` still used raw `XDocument.Load(stream)` after package health checks, bypassing the shared hardened XML reader settings. | Smoke package XML loads now use `XmlReader.Create(stream, SecureXmlReaderSettings.Create())`; the tool references `Free.Shared.Opc` directly. |
| P2 | Avalonia update metadata | Avalonia hard-coded `UpdateFeed.AllowPrereleases("test")` and a separate release URL while WPF used shared app metadata, risking channel drift. | Added `AppHelpInfo.ReleaseChannel` and wired Avalonia to `AppHelpInfo.ReleaseChannel` and `AppHelpInfo.LatestReleaseUrl`, with source guards. |
| P2 | Solution preflight | `tools/Test-SolutionProjects.ps1` only discovered `src/`, `tests/`, and `tools/` projects, so projects under `shared/` could fall out of `FreeX.slnx` without failing preflight. | Preflight now includes `shared/`; tests cover missing shared projects. |
| P3 | WPF shutdown | `App.OnExit` assumed the static DI provider had been initialized. Early startup failure could make shutdown throw while logging/disposing services. | The static provider is nullable behind a throwing accessor for normal callers; `OnExit` uses null-safe diagnostics/disposal and resets the field. |
| P3 | Full XLSX save streams | Full-package save fallback copied to caller-provided write-only seekable streams but did not truncate the stale tail if the new package was smaller. | The fallback now truncates from the current stream position after copy. Added a write-only seekable stream regression that reopens the saved XLSX. |
| P3 | Build readiness | Repository preflight and full Release build were blocked by stale preflight/build assumptions: macOS readiness expected an old Avalonia PDF-export marker, `Free.Shared.Ribbon.Wpf` was omitted from `FreeX.slnx`, and FreeW's WPF host used Windows Forms/GDI+ contracts without a stable GDI+ reference path. | Updated the macOS readiness marker, added the missing shared WPF project to `FreeX.slnx`, and enabled Windows Forms for `FreeW.App.Host` while removing the generated `System.Drawing`/`System.Windows.Forms` global usings that conflicted with WPF types. |

## Reviewed And Dismissed

- Recent-files and atomic-file write candidates were already guarded by existing source paths.
- Avalonia activation and WPF update-service failure candidates were already best-effort/non-fatal.
- Named-range spill semantics and delete-sheet named formula cleanup did not present a confirmed stale-data path in the reviewed code.
- CSV/native JSON/source-copy/patch save stale-tail concerns were not reproduced; the confirmed stale-tail issue was limited to caller-provided write-only seekable full-save streams.

## Verification

Focused verification passed during the cycle:

- `dotnet build tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~Validate_PreservesEncodedPathSeparatorsWhenResolvingRelationshipTargets|FullyQualifiedName~XlsxFileAdapterSource_PassesWarningsIntoPerItemLoadMappers|FullyQualifiedName~PerItemLoadMappers_ReportSkippedItemsThroughWarnings|FullyQualifiedName~Save_TruncatesWriteOnlySeekableOutputStreamAfterWritingPackage" --logger "console;verbosity=normal"`: 4 passed.
- `dotnet build tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`
- `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~Recalculate_NamedFormulaPrecedentEdit_RecalculatesDependentCell|FullyQualifiedName~Recalculate_NamedFormulaVolatileFunction_RecalculatesWithoutChangedCells|FullyQualifiedName~RecalculateAllFormulas_FullColumnAggregate_IncludesSpillTargetsInUsedRange" --logger "console;verbosity=normal"`: 3 passed.
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~AppHelpInfoTests|FullyQualifiedName~AvaloniaShellSourceTests" --logger "console;verbosity=normal"`: 64 passed.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`
- `dotnet build tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~SolutionProjectsPreflightTests" --logger "console;verbosity=normal"`: 10 passed.
- `dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal`

Full repository verification:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`: passed. Validated 4 JSON files, 103 XML-backed files, 29 PowerShell scripts, 8 GitHub workflows, SDK `10.0.301` readiness across 55 projects, 55 project references, 45 solution entries, macOS readiness across 436 source files, generated docs, and 4422 text files for conflict markers.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and 0 errors after the final `origin/main` sync.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"`: attempted twice after fixes, but the solution-level test runner hung while hosting `FreeX.App.Avalonia.Tests`. The same default test projects were then run directly one by one with `--configuration Release --no-build` and the same TRX logger after syncing with `origin/main`; `FreeX.App.Avalonia.Tests` was rerun serially with xUnit parallelization disabled after the normal no-build run left the host idle. Result: 15,583 passed, 129 skipped, 0 failed; `FreeX.Fixtures` produced no test run output because it is a fixtures project. A later final `origin/main` sync touched only `freew/` files, so repository preflight and full solution build were rerun on the final tree.
