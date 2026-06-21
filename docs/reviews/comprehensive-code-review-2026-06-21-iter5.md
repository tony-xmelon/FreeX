# Comprehensive Code Review - 2026-06-21 Iteration 5

Branch: `codex/review-iterate-20260621-5`

Base reviewed: `origin/main` at `9fb95193c`.

Scope: follow-up review/fix cycle after iteration 4, focused on the newly hardened workflow/documentation guards, FreeW HTML/MHTML/DOCX preservation paths, and WPF sheet-tab command execution/undo behavior.

## Findings

### P2 - pull_request_target guard missed quoted nested workflow trigger keys

The workflow preflight caught quoted `on` keys and inline trigger values, but the nested block check still only matched unquoted `pull_request_target:`. A workflow such as `"on":` followed by `"pull_request_target":` could still pass preflight.

Fix: the block trigger guard now matches quoted and unquoted nested `pull_request_target` keys, with Host workflow preflight tests for single- and double-quoted variants.

### P2 - Review reports could drift out of the docs index again

Iteration 4 restored the current June 21 review links, but the documentation guard only checked one old review file and the review log. New `docs/reviews/comprehensive-code-review-*.md` files could again be added without a `docs/README.md` link.

Fix: documentation tests now dynamically require every comprehensive review report to appear in `docs/README.md`, and the markdown link resolver also covers `docs/reviews/code-review-log.md`. The existing June 19 iteration links that were missing from the index were added.

### P2 - Mixed inline content inside HTML table cells split into multiple paragraphs

FreeW table-cell import fed raw `<td>` children through the top-level block reader. Inline markup such as `<td>A <strong>B</strong></td>` became separate paragraphs instead of one paragraph with formatted runs.

Fix: table-cell parsing now batches inline children into one paragraph and only starts new paragraphs for true block children. Nested tables still flatten into cell text rather than promoting their rows to the outer table.

### P2 - New DOCX chart/media parts could collide with preserved package parts

FreeW preserved unmodelled chart/media parts verbatim, but the writer still allocated new modelled charts and media from fixed `chart1.xml` / `image1.*` sequences. Editing a document that preserved `/word/charts/chart1.xml` or `/word/media/image1.png` and then adding a FreeW chart/image could emit duplicate OPC entries.

Fix: the DOCX writer reserves preserved part names before allocating modelled chart, media, chart-relationship, embedding, header/footer image, comment image, and OLE payload names. Regression coverage asserts both preserved and modelled parts are emitted once with distinct package names.

### P2 - WPF sheet-tab mutations bypassed host dirty/cache/window notifications

Some sheet-tab handlers called `_commandBus` directly for insert, rename, delete, and move operations. Successful workbook mutations could therefore skip `MarkWorkbookDirty()`, navigation-cache invalidation, and sibling-window notifications.

Fix: those handlers now route through host command execution helpers. A repeatable helper was added for Insert Sheet so F4 semantics remain while dirty/cache/window notifications are still applied.

### P2 - WPF Move or Copy create-copy used two undo entries

The WPF Move or Copy create-copy path executed `DuplicateSheetCommand` and then `MoveSheetCommand` as separate commands. One user action therefore required two undo operations, and the first undo could leave an unexpected copied sheet.

Fix: create-copy-with-move now executes a single `CompositeWorkbookCommand`. Core tests verify one undo removes the copied sheet entirely, and source guards keep the host path routed through the composite command.

## Focused Verification

- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~HtmlMhtmlRoundTripTests|FullyQualifiedName~CommentAndChartMediaRoundTripTests" -v:minimal` - passed, 16 tests.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflight_FailsWhenWorkflowUsesQuotedBlockPullRequestTarget|FullyQualifiedName~DocsReadme_LinksEveryComprehensiveReviewReport|FullyQualifiedName~CurrentPlanningDocs_LocalMarkdownLinksResolve|FullyQualifiedName~SheetTabMutations_RouteThroughHostCommandExecutionHelpers|FullyQualifiedName~MoveOrCopyCreateCopy_UsesSingleCompositeCommandWhenCopyMustMove" -v:minimal` - passed, 6 tests.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~SheetTabMutations_RouteThroughHostCommandExecutionHelpers|FullyQualifiedName~MoveOrCopyCreateCopy_UsesSingleCompositeCommandWhenCopyMustMove|FullyQualifiedName~SheetTabWorkflowsScreenshotTourTests" -v:minimal` - passed, 3 tests.
- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~SheetTabCommandTests" -v:minimal` - passed, 10 tests.

## Full Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,940 passed, 131 skipped, and 0 failed across 13 TRX files.

