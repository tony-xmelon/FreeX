# Workbook Export Scope Plan

- [x] Identify workbook-wide export as the next PDF/XPS option gap.
- [x] Add failing planner, dialog, renderer, and host-source tests.
- [x] Implement workbook scope in planner/dialog/rendering path.
- [x] Update parity docs and architecture notes.
- [x] Run focused verification and review.
- [ ] Commit, merge, and sync.

## Review Notes

- Initial review finding: workbook XPS export was indirectly creating the PDF bitmap `FixedDocument` path before writing XPS. Fixed by passing `ExportOptions` into each format-specific export method and rendering inside the method `try` block.
- Re-review: no findings.

## Verification

- `dotnet build FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` - failed as expected before implementation because `EntireWorkbook` and `RenderWorkbook` did not exist.
- `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~ExportPlannerTests|FullyQualifiedName~PrintRendererPageSetupTests|FullyQualifiedName~MainWindowSourceHygieneTests|FullyQualifiedName~CommandParityStatusTests"` - 69 passed.
- `git diff --check` - passed; Git reported only line-ending conversion warnings.
