# FreeX Comprehensive Code Review - 2026-06-03

## 0. Method And Coverage

Fresh full-codebase review on isolated branch `codex/code-review-docs-20260603`, created after `git fetch origin` and `git pull --ff-only origin main` reported `Already up to date.` Baseline HEAD: `241684d65bac7c55ca19ccaec4f6f11635992763`.

Scope covered:

- `src/`: 1,126 C# files, 197,579 source lines.
- `tests/`: 720 C# files, 206,013 source lines.
- Tooling, workflows, release scripts, docs index, and XLSX interop tools.

Review method:

- Read-only parallel slices for formula/calc, IO/package handling, WPF host/UI, and build/release infrastructure.
- Local verification of every reported high-priority finding against source line references.
- Repository-wide pattern sweeps for broad catches, shell launches, sync-over-async, `async void`, `Thread.Sleep`, debt markers, unsupported stubs, culture-sensitive parsing, and XML/package loading.
- Build, test, preflight, dependency vulnerability, and tool-project build verification.

This is a comprehensive risk pass, not a literal line-by-line proof of every statement in 400 KLOC of source and tests. The findings below are the actionable issues that survived source verification.

## 1. Executive Summary

No P0 release blockers were found. The solution build, full test suite, repository preflight, dependency vulnerability checks, and direct interop-tool builds are green.

The highest-priority risks are two Core.IO resource-exhaustion hardening gaps around XLSX input handling: unbounded stream copy before the workbook size guard, and package XML DOM loads that bypass the existing secure XML character cap.

The rest of the review is mostly P2 product/release correctness: out-of-grid named ranges can be shadowed by formula tokenization, literal `INDIRECT` aggregates miss the full-row/full-column clamp, the custom grid UIA peer still exposes no cell/value patterns, export can overwrite a normalized path without a second prompt, Get Data imports run synchronously on the WPF thread, release metadata can report stale version `0.5`, and the interop verification tool projects are not part of the solution/CI build boundary.

## 2. Findings By Priority

### P1 - Core.IO copies arbitrary stream input before enforcing workbook size limits

Evidence: [`XlsxFileAdapter.LoadCore`](../src/FreeX.Core.IO/XlsxFileAdapter.cs#L48) calls [`CreateLoadPackageStream`](../src/FreeX.Core.IO/XlsxFileAdapter.cs#L623), which copies the caller-provided stream into a `MemoryStream` at [`stream.CopyTo(packageStream)`](../src/FreeX.Core.IO/XlsxFileAdapter.cs#L650). The zip/file guard runs later at [`WorkbookOpenSizeGuard.EnsureArchiveWithinLimits(packageArchive)`](../src/FreeX.Core.IO/XlsxFileAdapter.cs#L65). The guard itself has file/archive limits in [`WorkbookOpenSizeGuard`](../src/FreeX.Core.IO/WorkbookOpenSizeGuard.cs#L23), but direct `IFileAdapter.Load(Stream)` callers can still force a large allocation before those checks.

Impact: a huge seekable or non-seekable stream handed directly to Core.IO can allocate until OOM before the intended 2 GiB file cap or archive-bomb limits apply. The host open path is safer because it checks file length before loading, but the adapter remains an exposed library boundary.

Recommended fix: check seekable `Length - Position` before allocation, throw `WorkbookTooLargeException` when it exceeds `DefaultMaxFileBytes`, and use a capped counting copy for non-seekable streams. Add tests with fake oversized seekable and non-seekable streams that prove the exception occurs before full read/allocation.

### P1 - XLSX package XML readers bypass the secure XML character cap

Evidence: the repo defines [`SecureXmlReaderSettings.DefaultMaxCharactersInDocument`](../src/FreeX.Core.IO/SecureXmlReaderSettings.cs#L7), but many package helpers call raw `XDocument.Load(stream)`, including [`XlsxPackageXmlEditor.LoadXml`](../src/FreeX.Core.IO/XlsxPackageXmlEditor.cs#L16), [`XlsxRelationshipReader.LoadXml`](../src/FreeX.Core.IO/XlsxRelationshipReader.cs#L62), and [`XlsxFileAdapter.SheetXmlLayout.LoadXml`](../src/FreeX.Core.IO/XlsxFileAdapter.SheetXmlLayout.cs#L148). The sweep also found direct loads in metadata/preservation readers such as `XlsxFeatureInspector`, `XlsxPivotCacheReader`, `XlsxStructuredTableMetadataReader`, `XlsxSlicerTimelineMetadataReader`, `XlsxWorkbookMetadataReader`, `XlsxWorkbookThemeReader`, `XlsxWorksheetCommentReader`, and `XlsxWorksheetViewWriter`.

Impact: a crafted `.xlsx` can include very large XML parts that remain under the archive-size guard but consume high memory/CPU during DOM load/save inspection. The project already has the right secure reader primitive; it is not applied uniformly.

Recommended fix: route all package XML DOM loads through `XmlReader.Create(stream, SecureXmlReaderSettings.Create())`, with rare explicit exceptions documented per reader. Add oversized workbook/rels/worksheet XML fixtures that fail before DOM materialization.

### P2 - A1-shaped out-of-grid named ranges become unreachable from formulas

Evidence: [`Lexer.IsCellReference`](../src/FreeX.Core.Formula/Lexer.cs#L416) recognizes tokens with up to three column letters and row digits, but does not validate maximum row/column bounds. [`Parser.ParseCellRef`](../src/FreeX.Core.Formula/Parser.cs#L649) later converts out-of-grid references to `#REF!`. Meanwhile [`Workbook.ValidateNamedRangeName`](../src/FreeX.Core.Model/Workbook.cs#L318) rejects only names that `CellAddress.TryParse` accepts as real in-grid addresses.

Impact: workbook names such as `XFE1`, `ZZZ1`, or `A1048577` are valid named ranges because they are outside the grid, but formulas tokenize them as cell references and evaluate as `#REF!` instead of resolving the name.

Recommended fix: make `Lexer.IsCellReference` validate Excel max row and column bounds before returning true; otherwise emit a named-range token. Add lexer/evaluator tests for `=XFE1` and `=A1048577` as named ranges, plus unbound cases returning `#NAME?`.

### P2 - Literal `INDIRECT` aggregate ranges miss the full-row/full-column clamp

Evidence: direct aggregate ranges are clamped in [`FormulaEvaluator.FastAggregates`](../src/FreeX.Core.Formula/FormulaEvaluator.FastAggregates.cs#L500), but the literal `INDIRECT` fast path starting at [`argument is FunctionCallNode { FunctionName: "INDIRECT" }`](../src/FreeX.Core.Formula/FormulaEvaluator.FastAggregates.cs#L526) builds a `FastAggregateRange` at [`line 541`](../src/FreeX.Core.Formula/FormulaEvaluator.FastAggregates.cs#L541) without applying that clamp. `INDIRECT("A:C")` is resolved to a full-grid column range by [`TryResolveIndirectRangeReference`](../src/FreeX.Core.Formula/BuiltInFunctions.Lookup.Indirect.cs#L75).

Impact: `SUM(A:C)` can be fast and bounded, while `SUM(INDIRECT("A:C"))` can trip range-size limits or spend unnecessary work despite being semantically equivalent for populated cells.

Recommended fix: carry enough metadata from `INDIRECT` parsing to detect full-row/full-column literals, then apply the same `TryClampFullRangeToUsed` logic before `TryAcceptFastAggregateRange`. Add tests for `SUM(INDIRECT("A:C"))`, `SUM(INDIRECT("F:G"))`, `SUM(INDIRECT("1:10"))`, and sheet-qualified variants.

### P2 - The worksheet grid UIA peer names the control but exposes no cells or grid/value patterns

Evidence: [`GridView.OnCreateAutomationPeer`](../src/FreeX.App.UI/GridView.cs#L61) returns a custom peer that reports `AutomationControlType.DataGrid`, class name, and control/content flags only. The XAML sets `SheetGrid` name/help text at [`MainWindow.xaml`](../src/FreeX.App.Host/MainWindow.xaml#L3341), but no `IGridProvider`, `ISelectionProvider`, cell peers, `IGridItemProvider`, `IValueProvider`, or selection/focus events are exposed.

Impact: assistive technology can find "Worksheet" but cannot inspect cell values, navigate visible cells through UIA, or observe selected cell changes. This is a real accessibility parity gap even though the basic control name is now fixed.

Recommended fix: implement grid and selection providers on the grid peer, create virtualized peers for visible cells with address/value/name, and raise selection/focus events. Add UIA tests proving `SheetGrid` exposes `GridPattern` and a visible cell such as A1 exposes address, value, row/column, and selected state.

### P2 - PDF/XPS export can overwrite a normalized path without an overwrite prompt

Evidence: the save dialog prompts for [`saveDlg.FileName`](../src/FreeX.App.Host/MainWindow.PrintExport.cs#L46), but [`ExportPlanner.PlanExport`](../src/FreeX.App.Host/ExportPlanner.cs#L120) always normalizes the extension. XPS export then opens the normalized path with [`FileMode.Create`](../src/FreeX.App.Host/MainWindow.PrintExport.cs#L166).

Impact: selecting XPS while entering `report.pdf` can pass the dialog overwrite prompt for `report.pdf`, then write `report.xps` and overwrite an existing `report.xps` without a native prompt.

Recommended fix: normalize extension before accepting the save dialog result, or explicitly prompt if `request.Path != saveDlg.FileName && File.Exists(request.Path)`. Add mismatched-extension and extensionless PDF/XPS export tests.

### P2 - Get Data import runs synchronously on the WPF click handler

Evidence: [`GetDataBtn_Click`](../src/FreeX.App.Host/MainWindow.DataCommands.cs#L36) opens the chosen file and calls [`adapter.Load(stream)`](../src/FreeX.App.Host/MainWindow.DataCommands.cs#L55) before returning to the dispatcher.

Impact: large CSV/TXT/XML imports can block rendering and input on the UI thread. This is inconsistent with the main workbook open path, which uses async loading around `OpenWorkbookLoader`.

Recommended fix: move import parsing to an async loader with progress/cancellation behavior, then marshal only the command execution and UI refresh back to the dispatcher. Verify with a slow fake adapter that the dispatcher remains responsive.

### P2 - Release builds can report stale version `0.5`

Evidence: [`AppInfo.VersionText`](../src/FreeX.App.Host/AppInfo.cs#L5) is hard-coded to `Version 0.5 (Tester Release)`. The tester release workflow computes `0.8.<run>` from `release/progress.json` at [`.github/workflows/tester-release.yml`](../.github/workflows/tester-release.yml#L135), and [`Publish-UserTestBuild.ps1`](../tools/Publish-UserTestBuild.ps1#L220) publishes without passing that computed version into assembly/app metadata.

Impact: About, Backstage, diagnostics, crash analytics, and tester issue reports can identify current releases as `0.5`, making field reports hard to correlate with release artifacts.

Recommended fix: pass the computed release version through MSBuild properties such as `Version`, `FileVersion`, and `AssemblyInformationalVersion`, or generate a `FreeXDisplayVersion` source file. Have `AppInfo` and diagnostics read the built value. Verify file metadata and diagnostics from a published tester build.

### P2 - XLSX interop verification tool projects are outside the solution/CI build boundary

Evidence: [`FreeX.slnx`](../FreeX.slnx#L1) includes only `src/` and `tests/` projects. [`Test-SolutionProjects.ps1`](../tools/Test-SolutionProjects.ps1#L104) discovers projects but intentionally filters to paths starting with `src/` or `tests/` at [`line 112`](../tools/Test-SolutionProjects.ps1#L112). The review confirmed that `dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --no-restore` and `dotnet build tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj --no-restore` fail after solution restore because the tool assets are absent. Direct restore/build of both tool projects succeeds.

Impact: the tools used as release/openability evidence can stop compiling while solution CI and repository preflight still pass.

Recommended fix: either add the tool projects to the solution or add explicit restore/build gates for `tools\FreeX.ExcelOpenSmoke` and `tools\FreeX.ChartInteropCompare` in CI/preflight. Keep direct tool vulnerability checks alongside the solution vulnerability scan.

### P2 - Latest tester release can publish unsigned MSIX assets and has brittle publisher metadata

Evidence: the tester release workflow always runs `Publish MSIX package` at [`.github/workflows/tester-release.yml`](../.github/workflows/tester-release.yml#L206). The publish script allows unsigned output at [`Publish-UserTestBuild.ps1`](../tools/Publish-UserTestBuild.ps1#L379), and the MSIX manifest hard-codes [`Publisher="CN=FreeXLocal"`](../tools/Publish-UserTestBuild.ps1#L297). `docs/TEST_DISTRIBUTION_PLAN.md` advertises latest MSIX downloads for testers.

Impact: public latest MSIX assets can be non-installable or trust-failing when signing secrets are absent. When secrets are present, a certificate with a different subject can still fail because the manifest publisher is not derived from or validated against the cert.

Recommended fix: require a valid signing certificate for stable/latest MSIX assets, or publish unsigned MSIX only as internal artifacts. Parameterize and validate `Publisher` against the signing certificate. Verify with `signtool verify` and a clean-machine install.

### P2 - Tester release jobs can race and move `latest` backward

Evidence: [`.github/workflows/tester-release.yml`](../.github/workflows/tester-release.yml#L1) has no workflow-level `concurrency` group. Non-prerelease runs add [`--latest`](../.github/workflows/tester-release.yml#L382) unconditionally.

Impact: two manual tester-release dispatches can finish out of order, allowing an older commit/run to become the GitHub `latest` release and serve stale `FreeX-latest-*` downloads.

Recommended fix: add a workflow-level concurrency group for tester releases, or compare release version/run before applying `--latest`. Validate with two dry-run/prerelease dispatches and confirm only the newest can publish latest.

### P3 - Content type merge can preserve overrides for skipped or invalid package parts

Evidence: [`XlsxPackageMetadataMerger.MergeContentTypes`](../src/FreeX.Core.IO/XlsxPackageMetadataMerger.cs#L91) copies source overrides after only normalizing the string at [`line 103`](../src/FreeX.Core.IO/XlsxPackageMetadataMerger.cs#L103). The unknown-package copy path validates hostile entry names in [`TryNormalizeCopyableEntryName`](../src/FreeX.Core.IO/XlsxPackageMetadataMerger.cs#L299), and tests cover skipped hostile entries in [`XlsxPackageMetadataMergerTests`](../tests/FreeX.Core.IO.Tests/XlsxPackageMetadataMergerTests.cs#L155), but matching `[Content_Types].xml` overrides are not required to correspond to an actual target entry.

Impact: a crafted source can leave dangling or invalid overrides in the saved package, causing Open XML validation failures or Excel repair prompts.

Recommended fix: validate `PartName` with the same OPC/path rules and merge overrides only when the normalized part exists in the target archive or is generated by FreeX. Add hostile/skipped-entry fixtures plus package validation/open-smoke checks.

### P3 - Non-aggregate functions expand arguments before max-arity validation

Evidence: [`FormulaEvaluator.Functions`](../src/FreeX.Core.Formula/FormulaEvaluator.Functions.cs#L70) expands range arguments before enforcing max arity at [`line 207`](../src/FreeX.Core.Formula/FormulaEvaluator.Functions.cs#L207).

Impact: malformed formulas such as an oversized extra range passed to a scalar function can perform avoidable CPU/memory work before returning `#VALUE!`.

Recommended fix: enforce min/max counts before expansion for ordinary non-aggregate functions, preserving special forms and aggregate behavior. Add a regression test that an oversized invalid extra range returns arity failure without materialization.

### P3 - Get Data status-bar refresh is missing and the source test is too broad

Evidence: after import, [`GetDataBtn_Click`](../src/FreeX.App.Host/MainWindow.DataCommands.cs#L69) recalculates, selects, scrolls, and calls `UpdateViewport()`, but does not call `RefreshStatusBar()`. The test at [`MainWindowSourceHygieneTests.Backstage.cs`](../tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.Backstage.cs#L257) asserts the whole file contains `RefreshStatusBar();`, so unrelated methods can satisfy it.

Impact: users can see stale status-bar state after importing data, and the test does not protect the actual handler contract.

Recommended fix: call `RefreshStatusBar()` after `UpdateViewport()` and narrow the test to the `GetDataBtn_Click` method body.

### P3 - A few command-surface prompts bypass localization resources

Evidence: [`DeleteSheetMenuItem_Click`](../src/FreeX.App.Host/MainWindow.CellsCommands.cs#L109) passes raw English strings to `_messageService`, and [`FillSeriesMenuItem_Click`](../src/FreeX.App.Host/MainWindow.HomeEditing.cs#L101) does the same. The localization guard in [`LocalizationUsageTests`](../tests/FreeX.App.Host.Tests/LocalizationUsageTests.cs#L19) scans `ShowOwnedMessage`/progress calls but not `_messageService.Show*` or `_messageService.AskYesNo`.

Impact: non-English UI users can still see English prompts in command paths that otherwise participate in the localization system.

Recommended fix: move these strings/titles into `UiText` resources and extend the localization guard regex to cover `_messageService.Show*` and `_messageService.AskYesNo`.

## 3. Documentation Updated During This Review

- The root README development block now points contributors at the same preflight and Release build/test command shape used by the tester-release docs.
- This comprehensive review report was added and linked from the documentation index.
- The rolling `docs/CODE_REVIEW.md` tracker now points to this review and summarizes the open priority list.

## 4. Clean Signals Worth Recording

- Full solution build passed with 0 warnings and 0 errors.
- Full solution tests passed: 13,504 passed, 1 skipped, 0 failed.
- Repository preflight passed, including JSON/XML validation, tool scripts, workflows, SDK readiness, project references, solution membership, generated docs, and conflict-marker scanning.
- `dotnet list ... package --vulnerable --include-transitive` found no vulnerable NuGet packages for the solution or the two interop tool projects.
- Direct restore/build of `tools\FreeX.ExcelOpenSmoke` and `tools\FreeX.ChartInteropCompare` passed.
- No product `NotImplementedException` was found; the only product `NotSupportedException` is the deliberate legacy `.xls` save rejection in `LegacyXlsFileAdapter`.
- No source TODO/FIXME/HACK/XXX markers were found outside historical docs/tests that intentionally mention the policy.

## 5. Verification Commands

```powershell
git status --short --branch
git worktree list --porcelain
git fetch origin
git pull --ff-only origin main
git worktree add -b codex/code-review-docs-20260603 .worktrees/code-review-docs-20260603 main
dotnet restore FreeX.slnx --disable-parallel
dotnet build FreeX.slnx --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet test FreeX.slnx --no-restore --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1
dotnet list FreeX.slnx package --vulnerable --include-transitive
dotnet build tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet build tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet list tools\FreeX.ExcelOpenSmoke\FreeX.ExcelOpenSmoke.csproj package --vulnerable --include-transitive
dotnet list tools\FreeX.ChartInteropCompare\FreeX.ChartInteropCompare.csproj package --vulnerable --include-transitive
```
