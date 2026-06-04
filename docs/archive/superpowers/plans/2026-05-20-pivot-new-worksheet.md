# PivotTable New Worksheet Plan

- [x] Identify the command gap in Insert PivotTable new worksheet placement.
- [x] Add failing core command and host source-hygiene tests.
- [x] Implement undoable new-worksheet PivotTable command.
- [x] Wire the host Insert PivotTable workflow to the new command.
- [x] Update parity docs and architecture decision notes.
- [x] Run focused tests and review.
- [ ] Merge to main and sync remotes.

## Review Notes

- Spec compliance review: no findings.
- Local code-quality pass: fixed target-range clamping for large source ranges and added protected-workbook coverage.

## Verification

- `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter FullyQualifiedName~PivotTableCommandTests` - 29 passed.
- `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~PivotWorkflowDialogTests|FullyQualifiedName~MainWindowSourceHygieneTests.InsertPivotTable_NewWorksheetDestination_UsesUndoableCommand|FullyQualifiedName~CommandParityStatusTests"` - 18 passed.
- `git diff --check` - passed; Git reported only line-ending conversion warnings.
