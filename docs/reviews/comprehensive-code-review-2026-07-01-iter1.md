# Comprehensive Code Review - 2026-07-01 Iteration 1

Branch: `codex/review-orchestration-20260701`

Base reviewed: `origin/main` at `25c98c56e`.

Scope: comprehensive subagent-assisted review of spreadsheet core/model/IO/formula behavior, desktop host/ribbon/window workflows, FreeW/shared document workflows, and build/CI/preflight hygiene. The coordinator kept this branch for orchestration and report consolidation; the review slices ran in isolated linked worktrees.

## Findings

Resolution update: all findings in this iteration are fixed in `codex/review-orchestration-20260701`. The fixes were implemented through scoped Core, WPF workbook-window, FreeW/shared document, and repository preflight worker branches, then merged back into the orchestration branch for combined verification.

| Priority | Area | Finding |
|---|---|---|
| P2 | Core XLSX IO | Fixed: model-created named formulas and sheet-scoped defined names are emitted during XLSX save. |
| P2 | Core formulas | Fixed: formula date conversion now honors `Workbook.Uses1904DateSystem`. |
| P2 | Core ODS IO | Fixed: ODS cross-sheet range conversion preserves the right endpoint sheet when endpoints differ. |
| P2 | WPF workbook windows | Fixed: Switch Windows cycles only visible windows and cannot re-show hidden windows outside Unhide. |
| P2 | WPF workbook windows | Fixed: hiding a side-by-side partner clears side-by-side and synchronous scrolling state. |
| P2 | FreeW Save As | Fixed: Save-As format identity is carried through duplicate-extension choices to the selected adapter. |
| P2 | Repository preflight | Fixed: XML/JSON preflight defaults enumerate tracked repo files with build/worktree exclusions. |
| P3 | Repository preflight | Fixed: PowerShell tool-script preflight recurses into nested tools. |
| P3 | FreeW corpus | Fixed: committed local DOCX corpus fixtures are manifest-covered with provenance guards. |
| P3 | Documentation | Fixed: FreeW/Linux live-test upload-artifact guidance now uses v7. |

## Details

### P2 - Core XLSX IO: named formulas and scoped names are dropped on save

Files: `src/FreeX.Core.IO/XlsxNamedRangeMapper.cs:19`, `src/FreeX.Core.IO/XlsxNamedRangeMapper.cs:62`, `src/FreeX.Core.IO/XlsxNamedRangeMapper.cs:67`, `src/FreeX.Core.IO/XlsxNamedRangeMapper.cs:70`, `src/FreeX.Core.IO/XlsxNamedRangeMapper.cs:160`.

Evidence: `LoadDefinedNames` imports workbook-scoped and worksheet-scoped defined names. Formula names are stored through `workbook.NamedFormulas` or `workbook.DefineNamedFormula(...)`, and `Workbook` also has scoped name storage plus sheet-first resolution. The save path only iterates `workbook.NamedRanges` and emits workbook-level range names through `xlWorkbook.DefinedNames.Add(...)`; it does not write `NamedFormulas`, `ScopedNamedRanges`, or `ScopedNamedFormulas`.

Impact: generated or model-modified workbooks can silently lose formula defined names and sheet-local names during XLSX save. That is data loss for a feature the load path and formula engine already model.

Suggested fix/test: extend `XlsxNamedRangeMapper.Save` to emit workbook-scoped formulas, sheet-scoped formulas, and sheet-scoped ranges. Add round-trip tests that create a workbook-level named formula and a sheet-scoped name, save to XLSX, reload, and assert both the model and formulas using those names still work.

### P2 - Core formulas: 1904 date-system metadata is ignored by formula conversion

Files: `src/FreeX.Core.Model/Workbook.cs:179`, `src/FreeX.Core.IO/XlsxFileAdapter.cs:227`, `src/FreeX.Core.IO/XlsxWorkbookMetadataWriter.cs:110`, `src/FreeX.Core.Formula/ExcelDateSystem.cs:5`, `src/FreeX.Core.Formula/BuiltInFunctions.DateTime.cs:27`.

Evidence: `Workbook.Uses1904DateSystem` is loaded from XLSX and saved back as `date1904`, but `ExcelDateSystem` is hard-coded to the 1900/OA serial system. Date functions call `DateToSerial` and `SerialToDate` without consulting `ctx.CurrentWorkbook`, even though the evaluation context exposes the current workbook.

Impact: recalculating a 1904-date workbook can shift date results while preserving the metadata flag, corrupting formula outputs for functions such as `DATE`, `YEAR`, `MONTH`, `EDATE`, and related date-formatting paths.

Suggested fix/test: thread the workbook date system into serial/date conversion call sites through `ctx.CurrentWorkbook?.Uses1904DateSystem`. Add formula tests for `Uses1904DateSystem = true`, including `DATE(1904,1,1)` and serial-to-date cases such as `YEAR(0)`.

### P2 - Core ODS IO: cross-sheet range conversion loses the right endpoint sheet

Files: `src/FreeX.Core.IO/OdsFormulaConverter.cs:261`, `src/FreeX.Core.IO/OdsFormulaConverter.cs:268`, `src/FreeX.Core.IO/OdsFormulaConverter.cs:270`, `src/FreeX.Core.IO/OdsFormulaConverter.cs:361`; test gap: `tests/FreeX.Core.IO.Tests/OdsFormulaConverterTests.cs:39`.

Evidence: `ConvertBracketRefToA1` converts both range endpoints, then always returns `left + ":" + StripSheet(right)`. The nearby comment says to drop the right sheet only when endpoints share a sheet, but `StripSheet` removes everything before `!` unconditionally. `[$Sheet1.A1:$Sheet2.B2]` therefore becomes `Sheet1!A1:B2`, not a range that preserves `Sheet2`.

Impact: ODS import can silently rewrite formulas so the right endpoint points at the wrong sheet.

Suggested fix/test: compare endpoint sheet names before stripping. Preserve the right endpoint when sheets differ, or reject unsupported 3-D/cross-sheet ranges with a clear warning instead of silently rewriting. Add a test for `SUM([$Sheet1.A1:$Sheet2.B2])`.

### P2 - WPF workbook windows: Switch Windows includes hidden windows

Files: `src/FreeX.App.Host/WorkbookWindowRegistry.cs:158`, `src/FreeX.App.Host/WorkbookWindowRegistry.cs:177`, `src/FreeX.App.Host/MainWindow.ViewCommands.cs:208`.

Evidence: `NextWindowTarget` and `PreviousWindowTarget` compute over `_windows.Count` and return `_windows[nextIndex]` without checking `_hidden`. The ribbon command is enabled from the registry count, while the context menu path correctly uses `VisibleWindows`.

Impact: after View > Hide leaves one visible and one hidden workbook window, View > Switch Windows can target the hidden window and call `ActivateWindow()`, which shows it again outside the explicit Unhide workflow.

Suggested fix/test: base switch targets and command enablement on visible windows. Add registry tests for next/previous behavior with hidden windows and a UI-state test for one visible plus one hidden window.

### P2 - WPF workbook windows: hiding side-by-side partners leaves active sync state

File: `src/FreeX.App.Host/WorkbookWindowRegistry.cs:102`.

Evidence: `Hide` only adds the window to `_hidden` and calls `SetWindowVisible(false)`. `Unregister` explicitly disables side-by-side when a paired window is removed, and `DisableSideBySide` is the only path that clears `_sideBySidePrimary`, `_sideBySidePartner`, and `_synchronousScroll`.

Impact: a user can enable View Side by Side and Synchronous Scrolling, hide one of the paired windows, and leave the registry reporting sync state against a hidden workbook.

Suggested fix/test: make `Hide` call `DisableSideBySide()` when the hidden window is either side-by-side endpoint. Add a test that hiding a paired window clears side-by-side and synchronous scrolling state.

### P2 - FreeW Save As: duplicate-extension formats collapse to the first adapter

Files: `freew/FreeW.App.Presentation/Backstage/BackstageSaveAsFileTypePlanner.cs:17`, `shared/Free.Shared.Shell/BackstageFileTypeActionPlanner.cs:67`, `freew/FreeW.App.Avalonia/MainWindow.cs:1194`, `freew/FreeW.App.Presentation/Shell/DocumentPersistenceWorkflow.cs:93`.

Evidence: the catalog intentionally registers multiple writable formats with the same extension, including `.docx`, `.xml`, `.htm`, and `.html`. Those adapters are not equivalent; for example, full HTML preserves Office/style scaffolding while filtered HTML omits it. Backstage rows and callbacks carry only `PrimaryExtension`, not the selected descriptor or adapter. Avalonia then resolves the save with `filterIndex: 0`, falling back to the first adapter by extension.

Impact: selected variants such as Strict Open XML, Word 2003 XML, or full Web Page can be hidden or saved as the first same-extension format instead of the user-selected format.

Suggested fix/test: carry a `FileFormatDescriptor` identity or save-format index through backstage choices and picker requests, then resolve by that selected row when the chosen filename extension still matches. Add tests for Strict `.docx`, Word 2003 `.xml`, and full Web Page `.html`/`.htm` output markers.

### P2 - Repository preflight: XML/JSON validation covers too few tracked artifacts

Files: `tools/Test-XmlFiles.ps1:2`, `tools/Test-JsonFiles.ps1:2`.

Evidence: XML validation defaults to `Directory.Build.props`, `Directory.Packages.props`, three FreeX solution files, `src`, and `tests`. JSON validation defaults to `global.json`, `docs`, and `release`. In the reviewed tree, preflight validated 101 XML-backed files and 8 JSON files, while `git ls-files` showed 193 tracked XML-backed files and 147 tracked JSON files. Missed files include `Directory.Build.targets`, `FreeW.slnx`, `FreeP.slnx`, `FreeX.RibbonTests.slnx`, FreeW/FreeP projects and resources, Linux metainfo XML, `.vscode` JSON, and screenshot/foreground-capture manifests.

Impact: malformed build, package, release, and generated-evidence artifacts can pass the default `tools/Test-RepositoryPreflight.ps1` lane.

Suggested fix/test: make the XML/JSON validators enumerate tracked files repo-wide through `git ls-files`, or expand roots to cover all solution/project/tool/shared/app roots with `bin`, `obj`, and worktree exclusions.

### P3 - Repository preflight: nested PowerShell tools are skipped

File: `tools/Test-ToolScripts.ps1:24`.

Evidence: the script uses `Get-ChildItem ... -File` without `-Recurse`, so repository preflight reported 30 PowerShell tool scripts while the tracked `tools` tree has 34. Skipped scripts include `tools/FreeW.RenderCompare/Export-WordPdfs.ps1`, `tools/FreeX.LinuxLiveTest/Run-LinuxLiveTest.ps1`, `tools/transfer-session/install.ps1`, and `tools/transfer-session/transfer-session.ps1`.

Impact: syntax errors in nested checked-in tools are not caught by the default preflight.

Suggested fix/test: recurse under `tools`, exclude `bin`/`obj`, and preserve the existing fail-fast rule for nested `Test-*.ps1` scripts.

### P3 - FreeW corpus: tracked DOCX files bypass manifest/provenance checks

Files: `freew-fidelity-corpus/README.md:29`, `docs/fidelity/README.md:21`, `freew/FreeW.Core.IO.Tests/FreeWFidelityCorpusManifestTests.cs:20`, `freew/FreeW.Core.IO.Tests/FreeWFidelityCorpusRoundTripTests.cs:5`.

Evidence: the corpus docs say only `manifest.csv` and the fetch script are committed and that downloaded binaries stay ignored. However, `git ls-files freew-fidelity-corpus/files` reports 23 tracked `.docx` files, and those names are not represented in `manifest.csv` as local/provenance rows. The manifest test validates only manifest rows.

Impact: tracked fixtures sit outside the source/license/URL guard while docs describe a different storage model.

Suggested fix/test: either untrack or move those fixtures, or add explicit manifest rows with source/license/provenance and update the docs. Add a manifest guard that every tracked `freew-fidelity-corpus/files/**/*.docx` has a manifest row.

### P3 - Documentation: upload-artifact version guidance is stale

Files: `freew/build/README.md:47`, `tools/FreeX.LinuxLiveTest/README.md:126`, `.github/workflows/freew-release.yml:49`, `tools/Test-GitHubWorkflows.ps1:33`.

Evidence: docs still recommend `actions/upload-artifact@v4`, while the actual FreeW release workflow uses v7 and workflow validation enforces `actions/upload-artifact` major v7.

Impact: copied documentation snippets can fail the repository workflow guard or drift from supported CI policy.

Suggested fix/test: update both docs/snippets to v7 and include the current artifact hygiene fields such as `if-no-files-found` and retention settings where applicable.

## Subagent Review Evidence

- Core/model/IO/formula slice: synced `codex/review-core-20260701` to `25c98c56e`; ran read-only `rg` and targeted line inspections; no build or test suite executed.
- UI/host/ribbon slice: synced `codex/review-ui-20260701` to current `origin/main`; ran read-only `rg` and targeted line inspections; no UI tests executed.
- FreeW/shared/docs slice: synced `codex/review-freew-20260701`; focused index checks found no missing comprehensive review links. Initial parallel focused tests hit build-output locks; stale `VBCSCompiler` was stopped. The rerun passed:
  - `dotnet test freew\FreeW.App.Presentation.Tests\FreeW.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~DocumentPersistenceWorkflowTests|FullyQualifiedName~BackstageSaveAsFileTypePlannerTests" --logger "trx;LogFileName=review-freew-presentation.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 8/8.
  - `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~FreeWFidelityCorpusManifestTests|FullyQualifiedName~DocumentFileAdapterRegistrationTests|FullyQualifiedName~DocumentFileDialogFilterBuilderTests" --logger "trx;LogFileName=review-freew-coreio.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 43/43.
- Build/CI/preflight slice: synced `codex/review-build-20260701`; the following passed:
  - `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-GitHubWorkflows.ps1` - passed, 9 workflow files validated.
  - `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-SolutionProjects.ps1` - passed, 81 solution entries validated.
  - `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-DotNetProjectReferences.ps1` - passed, 107 project files validated.
  - `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed end-to-end.

## Fix Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed after all fixes and the latest `origin/main` were integrated, validating 153 JSON files, 194 XML-backed files, 38 PowerShell tool scripts, 9 workflow files, 108 .NET project files, 82 solution entries, and generated documentation.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- Initial `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` timed out after one hour with a stale `FreeP.App.Rendering.Avalonia.Tests` testhost. The stale test processes were stopped and generated parity-doc line-ending noise was restored.
- Fallback `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed with 22,360 passed, 132 skipped, and 0 failed across 19 TRX files after merging the latest `origin/main` into `main`.

## Follow-Up

Start a follow-up no-findings review over the touched Core, WPF window, FreeW Save As/corpus, and preflight surfaces.
