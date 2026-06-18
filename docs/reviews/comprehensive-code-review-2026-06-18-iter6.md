# FreeX Comprehensive Code Review - 2026-06-18 (Iteration 6)

## Scope And Method

Static repo review performed on branch `codex/repo-review-findings` at HEAD `06d173eac16a165063647fcb494afca939110220` ("Merge branch 'main' of https://github.com/tony-xmelon/FreeX").

This pass focused on correctness and data-preservation risks in areas that changed often in prior review cycles:

| Pass | Scope |
|---|---|
| 1 | Formula recalculation, dynamic arrays, spill storage |
| 2 | XLSX save warning behavior and lossy save surfaces |
| 3 | Shared app-services path-provider wiring |
| 4 | XLSX package XML validation and hardened XML parsing |

No code was changed during the review. Every finding below was verified against source in this branch. This is a static review report; default build/test verification could not run because the machine currently has .NET runtimes installed but no .NET SDK.

## Resolution Update

Fixed on branch `codex/repo-review-findings` after installing .NET SDK `10.0.100` under `C:\Users\ali\.dotnet`:

- **P1 dynamic-array spill cleanup:** evaluator-error catch paths now clear any previous spill owned by the anchor and mark spill-target dependents stale.
- **P2 XLSX save warnings:** comment and hyperlink serialization failures now add `SaveWithWarnings` entries instead of silently returning clean.
- **P2 autosave path provider:** `AutosaveSnapshotStore.CreateDefault` now uses the injected `IApplicationDataPathProvider`.
- **P3 package XML validation:** `XlsxPackageHealthValidator` now loads XML through the hardened `XlsxPackageXmlEditor.LoadXml` path.

Focused verification passed:

- `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --configuration Release --filter "FullyQualifiedName~SpillEngineTests"`: 19 passed.
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~XlsxSaveWarningsTests|FullyQualifiedName~XlsxPackageHealthValidatorTests"`: 88 passed.
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --filter "FullyQualifiedName~AutosaveSnapshotStoreTests"`: 19 passed.

Full-lane verification is no longer blocked by a missing SDK, but still has unrelated repository blockers:

- `tools\Test-RepositoryPreflight.ps1` fails in `Test-MacOsAppReadiness.ps1` because `src\FreeX.App.Avalonia\MainWindow.cs` is missing the expected source snippet `PortablePdfDocumentExporter.Save(_session.Workbook, exportPlan, path)`.
- `dotnet build FreeX.slnx --configuration Release` fails in `freew\FreeW.App.Host\Editing\DocumentView.cs` with missing `System.Private.Windows.GdiPlus` reference errors for `IImage`, `IGraphics`, and `IGraphicsContextInfo`.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` fails one unrelated guard: `FreeX.App.Presentation.Tests.PresentationPortabilityGuardTests.PresentationLayer_StaysPortable`, which flags an "Avalonia dependency" comment in `SlicerLayoutModel.cs:116`.

Severity legend:

- **P1**: likely user-visible data loss, stale result, wrong result, or crash in normal workflows.
- **P2**: real defect with narrower trigger or partial mitigation.
- **P3**: hardening, consistency, or maintainability issue with lower immediate user impact.

## Findings

### P1 - Evaluator exceptions leave stale dynamic-array spill values visible

`src/FreeX.Core.Calc/RecalcEngine.cs:190`

When a dynamic-array formula previously produced a spill range and a later recalculation fails with `FormulaEvalException`, the catch block sets only the anchor cell to the error value. It does not clear the old spill range. The release-only unexpected-exception path has the same problem at `src/FreeX.Core.Calc/RecalcEngine.cs:195`.

The normal result paths clear stale spill state before replacing the anchor (`src/FreeX.Core.Calc/RecalcEngine.cs:151`, `:158`, `:175`), and parse errors also clear it (`src/FreeX.Core.Calc/RecalcEngine.cs:184`). But evaluator errors skip that cleanup:

- `src/FreeX.Core.Model/Sheet.cs:684` removes spill values only when `ClearSpillRange` is called.
- `src/FreeX.Core.Model/Sheet.cs:735` still serves `_spillValues` from `GetValue` when no real cell exists at a spilled address.
- `tests/FreeX.Core.Calc.Tests/SpillEngineTests.cs:235` covers the valid-spill-to-scalar cleanup path, but not valid-spill-to-evaluator-error.

Impact: cells below or beside a failed dynamic-array formula can continue showing stale values from the previous successful spill while the anchor shows an error. Formulas that read the spill targets can then consume stale data until some later path clears the spill.

Suggested fix: call `sheet.ClearSpillRange(addr)` and set `spillTargetsMayHaveChanged` when `hadSpill` is true in both evaluator-error catch blocks before assigning the error. Add a regression test that starts with a successful dynamic array, mutates a precedent so the same formula throws a `FormulaEvalException`, and asserts all previous spill target cells are blank or no longer returned by `GetValue`.

### P2 - XLSX SaveWithWarnings can report a clean save after dropping comments or hyperlinks

`src/FreeX.Core.IO/XlsxFileAdapter.Save.cs:211`

`SaveWithWarnings` returns `XlsxSaveResult.Clean` whenever the warnings list is empty (`src/FreeX.Core.IO/XlsxFileAdapter.Save.cs:15`). However, the comment and hyperlink serialization loops catch all exceptions and silently continue:

- Comments: `src/FreeX.Core.IO/XlsxFileAdapter.Save.cs:211`
- Hyperlinks: `src/FreeX.Core.IO/XlsxFileAdapter.Save.cs:225`

The same save method already has the desired pattern for merged regions: it catches the serialization failure, writes debug output, and adds a warning (`src/FreeX.Core.IO/XlsxFileAdapter.Save.cs:366`). Comments and hyperlinks are user-authored workbook data, so silently dropping them while returning a clean result is a data-loss reporting bug.

Impact: an invalid or ClosedXML-rejected comment/hyperlink can be lost during save without surfacing in the UI or in caller diagnostics, even when the caller deliberately uses `SaveWithWarnings`.

Suggested fix: change both catch blocks to `catch (Exception ex)`, include sheet name and address in a warning, and keep the existing best-effort behavior for `Save`. Add tests that inject a comment/hyperlink target ClosedXML rejects and assert `SaveWithWarnings` returns a warning rather than `Clean`.

### P2 - AutosaveSnapshotStore.CreateDefault ignores the injected application-data provider

`shared/Free.Shared.AppServices/AutosaveSnapshotStore.cs:75`

`CreateDefault(IApplicationDataPathProvider pathProvider)` validates the supplied provider, then ignores it and calls `PlatformApplicationDataPathProvider.LocalInstance.GetApplicationDataDirectory()` directly (`shared/Free.Shared.AppServices/AutosaveSnapshotStore.cs:78`).

The WPF host passes the DI-registered provider into this API (`src/FreeX.App.Host/App.xaml.cs:80`), so the method signature promises environment/test/host override support that it does not actually honor. Nearby shared stores do use the injected provider, for example `RecentFilesStore` and the `AppStoragePathPlanner` helpers.

Impact: portable, test, or future host-specific app-data directories will be bypassed only for autosave/recovery snapshots. That can put crash recovery files in a different location from the rest of the app's per-user state.

Suggested fix: replace the direct singleton call with `pathProvider.GetApplicationDataDirectory()`. Add a unit test mirroring the existing app-storage tests with a fake `IApplicationDataPathProvider` and assert the recovery path is rooted there.

### P3 - XLSX package health validation bypasses the hardened XML reader

`src/FreeX.Core.IO/XlsxPackageHealthValidator.cs:2618`

`XlsxPackageHealthValidator.LoadPackageXml` opens package entries and calls `XDocument.Load(stream)` directly (`src/FreeX.Core.IO/XlsxPackageHealthValidator.cs:2621`). The repo already has a hardened helper, `XlsxPackageXmlEditor.LoadXml`, which creates an `XmlReader` with `SecureXmlReaderSettings.Create()` (`src/FreeX.Core.IO/XlsxPackageXmlEditor.cs:29`). Those settings prohibit DTDs, cap document size, and set `XmlResolver = null` (`shared/Free.Shared.Opc/SecureXmlReaderSettings.cs:13`).

Impact: this validator is primarily used by tooling, including the Excel-open smoke tool (`tools/FreeX.ExcelOpenSmoke/Program.cs:869`), rather than the main workbook open path. Still, untrusted workbook validation should apply the same XML safety policy as the rest of the package code. A crafted package part can consume more parser resources in the health validator than in hardened paths.

Suggested fix: route `LoadPackageXml` through `XlsxPackageXmlEditor.LoadXml(entry)` or equivalent `XmlReader.Create(stream, SecureXmlReaderSettings.Create())`. Add a small validator test with a DTD-bearing package part and assert it is rejected as unparseable instead of being parsed by the default XML loader.

## Reviewed And Dismissed

- **Update-service exception propagation.** A candidate concern was that update checks could crash startup, but `IUpdateService.CheckAndDownloadAsync` documents that implementations should not throw, and `VelopackUpdateService` catches exceptions and returns `UpdateCheckResult.Failed`. No finding.
- **Valid-spill-to-scalar cleanup.** This path is already covered by `SpillEngineTests.Recalc_FormulaChangedFromSpillToScalar_ClearsOldSpillValues`; the uncovered bug is specifically the evaluator-error path.
- **Merged-region save warnings.** This is already using the warning pattern that comments and hyperlinks lack, so the issue is not systemic across all lossy XLSX save loops.

## Verification

Attempted from `C:\Users\ali\Documents\GitHub\FreeX\.worktrees\codex-repo-review-findings`:

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`: failed during .NET SDK readiness after JSON, XML, PowerShell, and workflow checks passed. Error: `dotnet --list-sdks returned no installed SDK versions.`
- `dotnet build FreeX.slnx --configuration Release`: failed before compilation because `global.json` requests SDK `10.0.100` and no .NET SDKs are installed.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"`: failed before test discovery for the same missing SDK `10.0.100`.

`dotnet --list-sdks` produced no output in this environment.
