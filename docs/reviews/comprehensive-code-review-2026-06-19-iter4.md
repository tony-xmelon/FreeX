# Comprehensive Code Review - 2026-06-19 Iteration 4

Branch: `codex/review-iterate-20260619-4`

Base reviewed: `origin/main` at `e63d90023`; final verification after merging `origin/main` at `3e442d308`.

Scope: fourth review/fix cycle across FreeW DOCX import/export fidelity, FreeW editor/view round-trips, Avalonia file-operation safety, ribbon command routing, native-menu localization, and integration guard coverage.

## Findings

### P1 - Block-level DOCX content controls are skipped on import

`DocxReader` only consumed direct body `w:p` and `w:tbl` elements. Word commonly places structured document tags (`w:sdt`) directly in the body or inside table cells, so paragraphs wrapped by a block-level content control were silently dropped.

Fix: body and table-cell import now recurses through `w:sdtContent`, carries the inherited content-control metadata into child paragraphs/tables, and preserves body paragraph spacing adjustments across recovered paragraphs.

### P1 - Content controls drop nested hyperlinks and tracked revisions

Inline `w:sdt` parsing only walked direct runs. Content controls that contained `w:hyperlink`, `w:ins`, or `w:del` therefore reopened without linked/revised text.

Fix: paragraph inline parsing now uses a shared recursive dispatcher for runs, hyperlinks, revisions, content controls, fields, bookmarks, and equations. Nested controls keep hyperlink, revision, comment, and content-control metadata together.

### P2 - Word-style bibliography person authors parse as concatenated raw text

Word can serialize bibliography authors as `b:NameList/b:Person` entries. The reader fell back to raw `b:Author.Value`, collapsing `First/Middle/Last` fields into unreadable concatenated text.

Fix: bibliography import now prefers corporate authors, then structured `Person` names joined as `First Middle Last`, and only then falls back to raw text.

### P3 - Dormant hyphenation sub-options are stripped on round-trip

When `autoHyphenation` was off, preserved `consecutiveHyphenLimit`, `hyphenationZone`, and `doNotHyphenateCaps` settings were omitted even if they existed in the original DOCX settings part.

Fix: the writer now preserves those sub-options when a source settings part had them, without forcing a fresh settings part for documents authored from scratch.

### P2 - Rich FreeW inline objects lose hyperlinks through the WPF view

Images could retain hyperlink metadata, but shapes, charts, WordArt, equations, SmartArt, and embedded objects lost links when converted through `DocumentView`.

Fix: rich inline model/view conversion now wraps all rich inline object types with hyperlink metadata on the way into WPF and recovers that metadata on the way back to the model.

### P1 - Avalonia Save As can overwrite a normalized `.fxl` target without confirming it

The storage picker can return a user-selected path without the native workbook extension, then `WorkbookSession.EnsureSaveExtension` normalizes it to `.fxl`. If the normalized path already existed, the native picker's overwrite prompt did not cover the final file.

Fix: Save As now records the requested path, normalizes it, and prompts again when the normalized workbook path differs and already exists.

### P1 - Avalonia save/export/print pickers can overlap

Save, export, and print fallback set `_isSaving` only after the picker returned or only around the final write. A second file operation could start while the first picker was still open.

Fix: a shared `TryBeginFileOperation`/`EndFileOperation` gate now wraps Save As, active-sheet PDF export, scoped workbook PDF export, and print-to-PDF fallback from before the picker opens until the operation exits. The gate rejects active opening or saving operations.

### P2 - Accounting submenu items all route to the default currency

The Accounting Number Format dropdown exposed US Dollar, Euro, British Pound, and Japanese Yen labels, but all four shared the same command id. Non-dollar choices therefore routed to the dollar/default accounting format.

Fix: the ribbon menu definitions now assign distinct command ids for US Dollar, Euro, British Pound, and Japanese Yen, and the Avalonia command map routes each one to the matching symbol.

### P2 - Avalonia parity catalog misses new accounting command IDs

After merging the new functional parity matrix, its raw canonical Avalonia command catalog did not include the four newly distinct accounting command IDs. The parity hygiene test caught the drift because `MainWindow` wired those commands but the catalog could not account for them.

Fix: `AvaloniaExtraCommandIds.RawCanonical` now includes the US Dollar, Euro, British Pound, and Japanese Yen accounting command IDs, keeping the parity matrix in lock-step with the shell wiring.

### P2 - Shared PDF refactor outpaces macOS readiness guards

After merging the shared PDF tier, the macOS readiness preflight still scoped portable source hygiene and source-wiring markers around the older app-services PDF exporter shape. The new `Free.Shared.Pdf` and `Free.Shared.Pdf.Skia` projects could therefore drift outside the macOS portability/readiness guard, and the old exporter markers no longer described the current implementation split.

Fix: `Test-MacOsAppReadiness.ps1` now treats the shared PDF projects as portable source roots, allows them in the Avalonia project-reference boundary, and validates the current `PortablePdfDocumentExporter`/`WorkbookPdfContentBuilder` source-wiring markers.

### P3 - High-visibility Avalonia native menu labels bypass localization

The native File/Sheet menu setup used raw English labels for common commands such as New Workbook, Open, Save, Export to PDF, Share Workbook, Workbook Statistics, Close Workbook, and New Sheet.

Fix: those native menu labels now use `UiText` resource keys, with neutral and French resource entries plus source guards.

## Focused Verification

- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~DocxRoundTripTests|FullyQualifiedName~BibliographyRoundTripTests" --logger "trx;LogFileName=freew-io-cycle4.trx" -v:minimal` - passed, 170 tests.
- `dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~DocumentViewRoundTripTests" --logger "trx;LogFileName=freew-host-cycle4.trx" -v:minimal` - passed, 18 tests.
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaShellSourceTests" --logger "trx;LogFileName=avalonia-source-cycle4.trx" -v:minimal` - passed, 69 tests.
- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaExtraCommandIdsHygieneTests|FullyQualifiedName~FunctionalParityMatrixTests" --logger "trx;LogFileName=avalonia-parity-cycle4.trx" -v:minimal` - passed, 4 tests.
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaProjectPortabilityGuardTests" --logger "trx;LogFileName=avalonia-portability-cycle4.trx" -v:minimal` - passed, 4 tests.

## Full Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,866 passed, 129 not executed/skipped, and 0 failed.
