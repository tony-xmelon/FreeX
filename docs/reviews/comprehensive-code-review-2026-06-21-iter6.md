# Comprehensive Code Review - 2026-06-21 Iteration 6

Branch: `codex/review-iterate-20260621-6`

Base reviewed: `origin/main` at `501b1ffcf`.

Scope: clean-pass review after iteration 5, focused on the just-hardened workflow/documentation guards, FreeW DOCX allocator coverage, and WPF sheet-tab evidence consistency.

## Findings

### P2 - pull_request_target guard missed block-list workflow triggers

The workflow preflight caught inline trigger values and nested mapping keys, but YAML sequence syntax under an `on:` block still passed:

```yaml
on:
  - pull_request_target
```

Fix: the workflow guard now inspects the indented `on:` block for quoted and unquoted sequence items, with Host preflight tests for all three block-list variants.

### P3 - Code review log could still omit review reports

Iteration 5 ensured every comprehensive review report is linked from `docs/README.md`, but `docs/reviews/code-review-log.md` could still drift even though it describes itself as the cumulative cycle log. Four older review snapshots were not linked from the log.

Fix: documentation tests now require every `comprehensive-code-review-*.md` report to be linked from the code-review log, and the missing historical snapshot links were added.

### P3 - DOCX preserved-part collision tests did not cover all allocator paths

The writer fix reserves preserved package names for body media/charts plus chart workbooks, OLE payloads/icons, header/footer images, and comment images. The first regression test only proved body `image1.png` and `chart1.xml` collisions.

Fix: FreeW DOCX tests now assert that preserved chart workbook, OLE payload, OLE icon, header image, and comment image part names force modelled parts onto the next available package names and relationships.

### P3 - Sheet-tab evidence catalog still described the old two-command copy route

The WPF Move or Copy implementation and screenshot tour now use a single `CompositeWorkbookCommand`, but one catalog row still described the result evidence as `DuplicateSheetCommand` plus `MoveSheetCommand`.

Fix: the UI test catalog wording now names the composite route consistently.

## Clean-Pass Results

No additional WPF sheet-tab command-routing or undo defects were found after the iteration 5 fixes. No additional FreeW HTML parser or DOCX writer implementation defects were found; the only FreeW issue was missing guard coverage.

## Focused Verification

- `dotnet test freew\FreeW.Core.IO.Tests\FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~CommentAndChartMediaRoundTripTests" -v:minimal` - passed, 6 tests.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~GitHubWorkflowPreflight_FailsWhenWorkflowUsesBlockListPullRequestTarget|FullyQualifiedName~GitHubWorkflowPreflight_FailsWhenWorkflowUsesQuotedBlockPullRequestTarget|FullyQualifiedName~CodeReviewLog_LinksEveryComprehensiveReviewReport|FullyQualifiedName~DocsReadme_LinksEveryComprehensiveReviewReport" -v:minimal` - passed, 7 tests.

## Full Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` - passed.
- `dotnet build FreeX.slnx --configuration Release` - passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests.trx"` - passed with 15,940 passed, 131 skipped, and 0 failed across 13 TRX files.
