# Final Readiness Scan - 2026-06-08

Branch/worktree inspected: `codex/autofilter-excel-behavior-20260606` at `.worktrees/autofilter-excel-behavior-20260606`.

This was a sidecar scan only. No product/source files were edited.

## Coverage State

- The aggregate worktree contains broad parity docs for the main ribbon and adjacent chrome: File/Backstage, titlebar/QAT, formula bar/name box, sheet tabs/windowing, status/footer, Home editing, Insert charts/objects/table-pivot residuals, Draw objects, Page Layout, Formulas, Data, Review, View, Help/Legal, grid pointer mechanics, protected/cross-target command matrices, and screenshot/evidence harness work.
- Parent update: the aggregate XAML now declares File, Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, Chart Design, Format, Table Design, PivotTable Analyze, PivotTable Design, and Help tabs. The earlier chart-context blocker in this sidecar scan was resolved when `ChartDesignTab` and `ChartFormatTab` were integrated into the aggregate branch.
- The UI catalog still has `UI-CAT-INSERT-001` marked `Not Started` for end-to-end Tables/Pivot workflows and `UI-CMD-TARGET-001` marked `Not Started` for cross-target command matrix execution, even though several source/model slices have landed around those areas.
- Parent update: the previously missing parity notes for contextual Table/Pivot, Data import refresh, and Home formatting/number cells are present in this aggregate worktree, so the reference gap from the sidecar scan is no longer current.

## Open Risks

- Chart contextual tabs are integrated in the aggregate branch and covered by focused source/adaptive/keytip tests; the remaining chart-context risk is live visual evidence rather than missing XAML.
- Visual evidence remains the main broad gap: popup/dropdown capture, AutoFilter flyout screenshots, native file dialogs, QAT history menus, context menus, chart/object handles, status zoom interactions, PivotTable contextual screenshots, Help/Legal screenshots, and backstage/native dialog flows.
- Feature-depth gaps remain documented rather than closed: Draw ink tools, full Excel shape gallery/marquee object selection, true paginated Page Layout surface/header-footer editing, Forecast/Data Table deep Excel semantics, broader Data import/Get & Transform surfaces, and complete status-bar system/cloud indicators.
- Parent rerun: repository preflight passed after the aggregate continued, so the `.tmp-ribbon-parity` temp-artifact blocker from this sidecar scan is no longer current.

## Verification

- `git status --short --branch` from the primary checkout: primary worktree was not the target branch and had an unrelated dirty `tests/FreeX.Core.IO.Tests/XlsxNonChartSchemaValidationTests.CustomXml.cs`; left untouched.
- `git worktree list --porcelain`: target aggregate worktree found at `.worktrees/autofilter-excel-behavior-20260606`.
- `git status --short --branch` in the target aggregate worktree: dirty integration branch with many modified/untracked parity files, as expected for the active parent aggregate.
- Historical sidecar run, superseded by the parent rerun above: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1` failed during `.NET SDK readiness` because a stale `.tmp-ribbon-parity` artifact disappeared while being enumerated.
- `dotnet test tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~SparklineLoad_UsesExtensionListFastPath" --logger "console;verbosity=minimal"`: passed, 1/1. The prior Core.IO sparkline fast-path failure appears isolated to an older worker/run state.
- UI lane was not run.

## Recommended Next Checks

1. Keep focused chart-context ribbon tests and screenshot-tour planner tests in the final verification set.
2. Keep UI lane for the final WPF-ready pass, especially because this branch changes ribbon/chrome behavior and screenshot tooling.
3. Continue collecting live visual evidence for dropdowns, contextual tabs, object handles, status zoom, Help/Legal, and Backstage/native dialog flows.
