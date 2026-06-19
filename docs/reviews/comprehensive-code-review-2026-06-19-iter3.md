# Comprehensive Code Review - 2026-06-19 Iteration 3

Branch: `codex/review-iterate-20260619-3`

Base reviewed: `origin/main` at `1f9961fb` before sync; refreshed against later `origin/main` before final verification.

Scope: third review/fix cycle across FreeW DOCX/editor outline behavior, Avalonia print fallback and CUPS integration, and the `FreeX.FormatFidelity` harness.

## Findings

### P1 - Tracked content controls disappear on DOCX reopen

`DocxWriter` can emit a `w:sdt` content control inside a tracked `w:ins` or `w:del` wrapper, but `DocxReader` only recovered direct `w:r` and `w:hyperlink` children inside revisions. A revised content-control run therefore saved successfully and then vanished from the model on reopen.

Fix: the revision reader now routes nested `w:sdt` elements through the same content-control recovery path and stamps the revision metadata onto recovered runs.

### P1 - FormatFidelity is absent from solution preflight

`tools/FreeX.FormatFidelity/FreeX.FormatFidelity.csproj` existed in the repo but was missing from `FreeX.slnx`, so repository preflight flagged the tool as a project outside the solution.

Fix: added the tool project to the `/tools/` solution folder and source-guarded the membership.

### P1 - FormatFidelity XLSX rebuilt chain can still take the patch path

The `xlsx -> xlsx (rebuilt)` chain tried to force a full rebuild by mutating a far-off literal cell, but literal inserted cells are patch-save eligible. That let the harness classify a source-package patch save as a rebuilt XLSX hop.

Fix: `XlsxFileAdapter.DetachSourcePackage(workbook)` explicitly removes the source-package snapshot before `xlsx-rebuilt` saves, forcing the full-save path.

### P2 - FormatFidelity VBA and lossy-count dimensions are invisible

`WorkbookSnapshot.HasVba` was never populated, so macro presence compared false-to-false. Lossy count dimensions such as conditional formats, charts, and images treated any drop as `Ok`, hiding complete losses from reports.

Fix: XLSX load records whether `xl/vbaProject.bin` exists, `WorkbookSnapshot` captures that flag, and lossy scalar drops now report `ExpectedLoss` instead of `Ok`.

### P2 - Avalonia print-to-PDF fallback can overwrite a normalized `.pdf` path

The main PDF export path prompts when a user-selected non-PDF path normalizes to an existing `.pdf`, but `SavePrintReadyPdfAsync` wrote the normalized path directly.

Fix: print fallback now uses the same `ExportPathPlanner.ShouldPromptForNormalizedOverwrite` and confirmation dialog before writing.

### P2 - CUPS commands can hang the print workflow indefinitely

`CupsPlatformPrinter` awaited `lpstat` and `lp` with the default caller token. If the CUPS utility hung, print dialog enumeration or job submission could hang indefinitely.

Fix: CUPS commands now run with a bounded timeout, kill the process tree on timeout, return no printers for enumeration timeout, and surface a friendly submission failure for print timeout.

### P2 - FreeW nested outline moves can leave the parent section

`OutlineTools.MoveSubtree` treated the next same-or-higher heading as a following sibling. Moving `Heading2 A.1` down in `Heading1 A / Heading2 A.1 / Heading1 B` therefore moved it past `B`, outside its parent section.

Fix: move-up and move-down now require a same-level sibling within the current parent scope; ancestor boundaries are no-ops.

### P2 - FreeW content-control insert commands append instead of inserting at the caret

The content-control insert commands called `InsertInlineAtCaret`, but that helper found the caret paragraph and always appended the new inline. Mid-paragraph inserts landed at paragraph end.

Fix: the helper now inserts at the actual `TextPointer`, splitting a WPF text run when the caret is in the middle and preserving formatting/markers on the trailing run.

## Focused Verification

- `dotnet test freew\FreeW.Core.Model.Tests\FreeW.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~MoveSubtree" -v:minimal`
- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~RevisedContentControl_RoundTrips_ControlAndRevision" -v:minimal`
- `dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~InsertPlainTextControl_InsertsAtMiddleCaret" -v:minimal`
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindow_PrintFallbackGuardsNormalizedPdfOverwriteAndCupsTimeouts" -v:minimal`
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~FormatFidelityHarnessSourceTests" -v:minimal`

Full repository verification is pending after syncing this branch with the latest `origin/main`.
