# Protected Sheet Command Matrix Slice

Date: 2026-06-08

Branch/worktree: `codex/protected-sheet-command-matrix-20260608` at `.worktrees/protected-sheet-command-matrix-20260608`

## Scope

Reviewed the protected-sheet command target residual against the cross-target matrix priority for commands whose availability is controlled by Excel's Protect Sheet permissions. The slice stayed in model/command-source coverage and avoided AutoFilter flyout UI, Page Layout print/export, status/footer, Insert table/pivot UI, Formula, Draw UI, titlebar/QAT, chart contextual UI, and data import files.

## Existing coverage inspected

- `SheetProtectionCommandTests` already covered protect/unprotect, locked/unlocked edits, allow-edit ranges, format cells, merge rejection without permissions, insert rows, insert columns, delete rows, delete columns, row/column sizing, and hide/unhide allow paths.
- `FilterProtectionCommandTests` already covered basic value filters rejecting without `UseAutoFilter` and value/condition/color/summary/table filters allowing with `UseAutoFilter`.
- `WorkbookProtectionCommandTests` already covered workbook structure protection for sheet add/rename/remove/move.
- Sort, chart/object, comment/object, drawing/text-box/object, scenario, and PivotTable command tests already include permission-guard coverage in their focused command suites.
- Review command-source/keytip coverage already proves `Allow Users to Edit Ranges` is disabled and not keytip-routable while the active sheet is protected.

## Changes

- Added reject-side row/column matrix coverage for commands that previously had allow-side tests but no direct no-permission test in the protection suite:
  - Insert columns requires `InsertColumns`.
  - Delete rows requires `DeleteRows`.
  - Delete columns requires `DeleteColumns`.
  - Set row height requires `FormatRows`.
  - Hide columns requires `FormatColumns`.
  - Hide rows requires `FormatRows`.
- Added reject-side AutoFilter matrix coverage for non-basic filter variants without `UseAutoFilter`:
  - Criteria, above-average, top-items, cell fill color, no fill color, font color, and structured-table filter application.

## Findings

No functional guard discrepancy was found in the focused model/command-source scope. The commands reviewed route through `CommandGuards.RejectIfProtectedWithoutPermission` or an object/pivot-specific wrapper with the expected permission flag.

## Remaining gaps

- Live ribbon/context-menu disabled-state evidence across every target class in `UI-CMD-TARGET-001` remains open.
- Persistence round trips for saved protection permissions and protected command states remain open in `UI-CMD-REVIEW-006`.
- This slice did not attempt the AutoFilter dropdown/flyout UI matrix or PivotTable insertion UI, per scope.

## Verification

- `dotnet test tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~SheetProtectionCommandTests|FullyQualifiedName~FilterProtectionCommandTests|FullyQualifiedName~SortCommandTests|FullyQualifiedName~PivotTableCommandTests|FullyQualifiedName~ChartCommandTests" --logger "trx;LogFileName=protected-sheet-command-matrix.trx"`: Passed, 264 tests, 0 failures.
- `git diff --check`: Passed. Git reported CRLF normalization warnings for the two edited test files only.
