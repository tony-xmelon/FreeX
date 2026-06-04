# PDF Export Options Plan

- [x] Identify the next export-fidelity gap after real PDF output.
- [x] Add failing planner, dialog, renderer, and host-source tests.
- [x] Implement selection-scoped rendering and export option dialog.
- [x] Wire PDF/XPS export to use selected-range options and open-after-publish.
- [x] Update parity docs and architecture notes.
- [x] Run focused verification and review.
- [ ] Commit, merge, and sync.

## Review Notes

- Review finding: stale `MainWindowSourceHygieneTests.ExportWorkflow_SurfacesPlannedPdfAndXpsPaths` still expected the old export call shape. Fixed to assert range override and open-after-publish wiring.

## Verification

- `dotnet build FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` - failed as expected before implementation because `Selection`, `ExportOptionsDialog`, and `printRangeOverride` did not exist.
- `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~ExportPlannerTests|FullyQualifiedName~PrintRendererPageSetupTests|FullyQualifiedName~MainWindowSourceHygieneTests"` - 66 passed.
- `git diff --check` - passed; Git reported only line-ending conversion warnings.
