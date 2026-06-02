# FreeX Performance Orchestrator Handoff - 2026-06-02

## Active Goal

Keep improving performance across the FreeX app end to end: use subagents to review bottlenecks, measure targeted baselines, implement prioritized optimizations, verify with tests and benchmarks, integrate cleanly, and continue until the practical improvement backlog is exhausted.

This goal is not complete. This file records the current clean checkpoint.

## Operating Rules

- Repository: `E:\Users\anton\Documents\Claude\Freexcel`.
- Latest upstream checkpoint before this handoff update: `1697d0396`.
- `codex/performance-orchestrator-resume-20260602` was rebased onto `origin/main` at `1697d0396` before this handoff update.
- Follow `AGENTS.md`: use isolated worktrees/branches for implementation, do not edit `main` directly, sync before work, verify before merge, push verified integrations frequently.
- User explicitly requested no permission prompts and no escalation requests.
- Treat unrelated dirty or untracked files as owned by other sessions unless explicitly proven otherwise.

## Integrated In This Wave

All items below were merged into `main` and pushed to `origin/main`.

### Core.Commands Dense Cell Shift

- Worker: `019e8a04-9993-7663-930f-ea1426223ebc`.
- Branch: `codex/perf-core-commands-dense-20260602-r5`.
- Commit: `0e22f9fd1`, integrated through `21b9f2a5c`.
- Change: reused cloned snapshot cells during insert/delete cell shift undo restore and replaced the restore address list with a pooled `CellAddress` buffer.
- Metric: `INSERT_CELLS_SHIFT_RIGHT_DENSE` allocation improved from about `14,489,296` bytes to `7,663,528` bytes.
- Verification after sync: `FreeX.Core.Model.Tests` focused filter/table/insert set passed `46/46`.

### Formula Parse Cache Tail

- Worker: `019e8a04-dae0-7613-ac67-604083e3be8d`.
- Branch: `codex/perf-ui-formula-tail-20260602-r5`.
- Commit: `0b2b64727`, integrated through `4e127a89a`.
- Change: exposed shared cached formula parsing and reused it from dependency rebuild and conditional-format formula parsing.
- Metric: repeated identical formula dependency rebuild improved from about `28,368,488` bytes to `26,756,576` bytes; sample time about `413.64 ms -> 381.95 ms`.
- Verification after sync:
  - `FreeX.Core.Formula.Tests` passed `2716/2716`.
  - Calc focused `AstCacheTests|ConditionalFormatTests|Benchmark_RepeatedIdenticalFormulaDependencyRebuild_ReportsParserCacheTail` passed `57/57`.

### XLSX Style-Only Load Metadata

- Local orchestrator branch: `codex/performance-orchestrator-resume-20260602`.
- Commit: `aac8a0399`, integrated through `39a7024de`.
- Change: streamed duplicate style-only cell stripping instead of loading the whole worksheet DOM during the duplicate-strip pass; preserved styled value cells and kept no-op streaming pre-scan behavior.
- Metric: `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` allocation improved from about `165,057,880` bytes to `156,786,944` bytes in focused samples.
- Verification:
  - `XlsxLoadPackageStreamTests|XlsxFileAdapterFormatTests` passed `17/17`.
  - Focused save/load pair passed `2/2`.
  - Later full IO run on the dense-save branch passed with `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA allocated_bytes=156,675,176`.

### App.Host Ribbon Resize

- Worker: `019e8a04-59aa-7732-9c5d-368ae7fa311f`.
- Branch: `codex/perf-host-toolbar-ribbon-resize-20260602-r5`.
- Commit: `178f2e854`, integrated through `57a1bccab`.
- Change: delayed cloning planned ribbon adaptive states until measured correction actually needs a mutable array.
- Metrics:
  - `RIBBON_RESIZE` allocation improved from the prior merged sample around `23.8 MB` to final merged-main smoke `13,508,352` bytes.
  - `NON_DRAG_SELECTION_TOOLBAR` stayed around `13.1 MB` with `can_undo_probes=0`, `can_redo_probes=0`, `toolbar_writes=0`.
- Verification:
  - Synced Host focused set passed `64/64`.
  - `PerformanceReviewMeasurementTests` passed `17/17` after an additional sync.
  - Final merged-main smoke `Benchmark_RibbonResizeSequence_ReportsTiming` passed with `RIBBON_RESIZE allocated_bytes=13,508,352`.

### XLSX Dense Loaded Mutated Save

- Worker: `019e8a1a-9d81-70f3-933f-38956185f1dc`.
- Branch: `codex/perf-xlsx-dense-save-mutated-20260602-r1`.
- Commit: `74a1df928`, integrated through `6f8ceeb6e`.
- Change: worksheet preservation preflight no longer treats modeled-only `sheetPr` content (`codeName`, `tabColor`, `outlinePr`, `pageSetUpPr`) as native metadata requiring a target worksheet XML merge.
- Metric: `XLSX_SAVE_LOADED_DENSE_MUTATED` allocation improved from about `226,814,072` bytes to final full-IO sample `194,861,744` bytes.
- Verification after sync:
  - Focused dense-save and sheet-property/print-option retention tests passed `4/4`.
  - Full `FreeX.Core.IO.Tests` passed `1749/1749`.

### Core.Commands Advanced Filter Unique Rows

- Local orchestrator branch: `codex/performance-orchestrator-resume-20260602`.
- Commit: `f4e64f552`, integrated through `68ef39350`.
- Change: replaced per-matching-row concatenated string keys for Advanced Filter unique output with a row-key set that hashes and compares formatted scalar text directly.
- Metric: `ADVANCED_FILTER_COPY_UNIQUE_DENSE` allocation improved from `12,277,664` bytes to `8,272,344` bytes in focused samples.
- Verification after sync:
  - `AdvancedFilterCommandTests` passed `15/15`.
  - Focused `AdvancedFilterCommandTests|FilterCommandPerformanceTests|StructuredTableCommandTests` performance set passed `21/21`.
  - Final post-merge smoke for the unique-row benchmark and formatted-text dedupe test passed `2/2`.

### Formula Dependency Plan Cache

- Worker: `019e8a34-cf08-72c1-a27b-c921e95e05ed`.
- Branch: `codex/core-calc-formula-tail-perf-20260603`.
- Commit: `18e1401e1`, pushed directly on `main`.
- Change: cached reusable formula dependency plans for AST/sheet-local formulas, while keeping workbook-resolved references such as sheet-qualified refs, named ranges, and structured refs uncached for correctness.
- Metric: `Benchmark_RepeatedIdenticalFormulaDependencyRebuild_ReportsParserCacheTail` improved from `308.42 ms` / `26,756,048` bytes / `5,351` bytes per formula to `226.38 ms` / `22,437,632` bytes / `4,487` bytes per formula.
- Verification:
  - `FreeX.Core.Calc.Tests` passed `665/665`.
  - `FreeX.Core.Formula.Tests` passed `2716/2716`.
  - Focused repeated-identical-formula dependency rebuild benchmark passed with the final metric above.

### App.UI Quick Analysis Render Paths

- Worker: `019e8a34-ba23-7b12-907a-d170358abd6f`.
- Branch: `codex/app-ui-render-orchestrator-perf-20260603`.
- Commit: `52032b09f`, pushed on `main`.
- Change: cached no-op Quick Analysis data-bar preview geometry when no positive values can draw bars, and clipped background grid line rendering to the actual visible control bounds.
- Metric: focused `GRID_RENDER_QUICK_ANALYSIS_DATABARS_NONPOSITIVE` improved from `mean_ms=59.56`, `allocated_bytes=10,035,752` to three-run mean `53.82 ms`, average allocation `10,022,272` bytes. Other noisy render samples stayed healthy: text-heavy `166.34 -> 160.75 ms`, wrapped text `367.54 -> 287.89 ms`, positive quick-analysis `162.72 -> 161.43 ms`.
- Verification:
  - Focused App.UI benchmark filter passed `5/5`, plus two no-build repeats passed `5/5` each.
  - `GridViewRenderPerformanceTests|GridViewSelectionLayoutTests` passed `92/92`.
  - Full `FreeX.App.UI.Tests` passed `564/564`.

### XLSX Style-Only Stripping Stream

- Worker: `019e8a34-e815-7f12-9bd2-c548baf41c06`.
- Branch: `codex/perf-xlsx-io-backlog-20260603-r1`.
- Commit: `ad9bedb59`, integrated through `a610dc824`.
- Change: streamed XLSX style-only stripping directly into the replacement package instead of materializing stripped worksheet/package byte arrays.
- Metrics:
  - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` allocation improved from `156,788,696` bytes to `144,172,872` bytes.
  - `XLSX_SAVE_LOADED_DENSE_MUTATED` stayed effectively unchanged at about `194.9 MB`.
- Verification:
  - `XlsxFileAdapterFormatTests.LoadPath_AvoidsFullPackageToArrayCopies` passed `1/1`.
  - Focused dense mutated save and ignored-error/style-only load benchmarks passed `2/2`.
  - Full `FreeX.Core.IO.Tests` passed `1749/1749`.

### App.Host Selection Toolbar Status Tail

- Worker: `019e8a34-a5dd-7091-91a2-477c1551093f`.
- Branch: `codex/app-host-toolbar-status-perf-20260603-r1`.
- Commit: `390f087b7`, integrated through `415e00113`.
- Change: avoided repeated `SelectedRanges` writes when the effective selection did not change, disabled undo history for selection hot-path name-box updates when the box is not focused, and reduced `SpreadsheetDisplayFormatter` A1/R1C1 reference formatting churn with span/string-create helpers.
- Metrics:
  - `NON_DRAG_SELECTION_TOOLBAR` improved from `13,144,584` bytes / `20.16 ms` to focused verification `13,013,680` bytes / `15.30 ms`; post-sync no-build smoke was `13,022,176` bytes / `18.44 ms`.
  - `SELECTION_DRAG_STATUS` improved from `22,511,680` bytes to focused verification `22,469,496` bytes; post-sync no-build smoke was `22,014,992` bytes.
  - `ADDITIONAL_SELECTION_DRAG_TOOLBAR` improved from `23,612,832` bytes to focused verification `23,570,656` bytes; post-sync no-build smoke was `22,987,920` bytes.
- Verification:
  - Focused Host selection/formatter/performance set passed `35/35` before commit.
  - Post-sync focused no-build Host smoke passed `34/34`.
  - Full `FreeX.App.Host.Tests` still has a pre-existing unrelated failure: `MainWindowSourceHygieneTests.DrawingCommands_UseOwnedNoTargetMessages` expects `MainWindowMessage_NoDrawingShapesOnSheet`, while `MainWindow.Drawing.cs` contains `MainWindowMessage_NoDrawingShapeOnSheet`. The same single test was confirmed failing on primary `main`.

## Integrated Since Restart

All items below were verified, pushed to their `codex/` branches, and fast-forwarded into `origin/main`.

### Watch Window Entry Lookup Tail

- Branch: `codex/perf-core-model-watchwindow-tail-20260603-r1`.
- Commit: `b4ab25d72`.
- Change: skipped small-workbook sheet-index dictionary allocation and built exact watch-entry arrays after filtering.
- Metric: `WATCHWINDOW_GET_ENTRIES_MANY` allocation improved from `6,052,840` bytes to `6,050,240` bytes; no-build repeat mean was about `16.48 ms`.
- Verification: `WatchWindowServiceTests` passed `12/12`; focused benchmark passed `1/1`; full `FreeX.Core.Model.Tests` passed `1863/1863` before the next scenario slice.

### Scenario Summary Report Cell Pre-sizing

- Branch: `codex/perf-scenario-summary-tail-20260603-r1`.
- Commit: `236cecb67`.
- Change: added `Sheet.EnsureCellCapacity(int)` and pre-sized scenario summary report sheet cell storage from the estimated output cell count.
- Metric: `SCENARIO_SUMMARY_SHARED_CHANGES` improved from `3,062,336` bytes / `61.49 ms` to about `1,691,168` bytes / `49.7 ms`.
- Verification: focused benchmark passed `1/1`; `ScenarioManagerCommandTests` passed `19/19`; full `FreeX.Core.Model.Tests` passed `1865/1865`.

### Row/Column Annotation Shift Helpers

- Branch: `codex/perf-row-metadata-shift-tail-20260603-r1`.
- Commit: `52f43d4a6`.
- Change: replaced LINQ `Where(...).ToList()` in comment row/column up-shift helpers with manual lazy list construction.
- Metric: `INSERT_ROWS_METADATA_SHIFT` allocation improved from `8,776,168` bytes to `8,773,672` bytes.
- Verification: insert/delete row tests passed `33/33`; insert/delete column tests passed `24/24`; full `FreeX.Core.Model.Tests` passed `1865/1865`.

### Formula Dependency Graph Rebuild Allocation Tail

- Branches: `codex/perf-formula-dependency-tail-20260603-r2`, then `codex/perf-formula-tail-20260603-r3`.
- Commits: `e4bc02017`, `913abd825`.
- Changes: cached dependency-plan templates now store frozen precedent sets and reusable range arrays; dependency graph stores template sets/lists directly; later formula rebuilds pre-size the graph precedent dictionary from workbook formula count.
- Metrics:
  - Repeated identical formula dependency rebuild improved from `22,437,640` bytes to `17,835,488` bytes, then to `17,353,952` bytes / `3,470` bytes per formula.
  - Exact formula chain stayed stable at `199,912` bytes per iteration.
- Verification:
  - Focused Calc benchmarks passed `4/4`.
  - `FreeX.Core.Calc.Tests` passed `665/665`.
  - `FreeX.Core.Formula.Tests` passed `2716/2716`.

### FileSavePlanner Malformed Path Guard

- Branch: `codex/io-filesaveplanner-malformed-path-20260603-r1`.
- Commit: `b00e5197f`.
- Change: rejected current paths containing invalid path characters before extension resolution.
- Reason: unblocked the XLSX full IO gate by fixing `FileSavePlannerTests.TryResolveExistingPath_ReturnsFalseForMalformedCurrentPath` on current runtime behavior.
- Verification: `FileSavePlannerTests|FileAdapterSmokeTests.FileSavePlanner_TryResolveExistingPath` passed `14/14`.

### XLSX Plain Worksheet Metadata Preflight

- Branch: `codex/perf-xlsx-io-tail-20260603-r2`.
- Commit: `a7610a527`.
- Change: added streaming worksheet metadata preflight for plain loaded-package saves so sheets without native-only metadata skip expensive worksheet DOM materialization.
- Metrics:
  - `XLSX_SAVE_LOADED_DENSE_MUTATED` improved from `194,911,888` bytes / `960.93 ms` to about `158,412,872` bytes / `575.21 ms`.
  - `XLSX_SAVE_LOADED_DENSE_POSTPROCESSING` improved from `63,905,584` bytes to about `41,983,656` bytes.
  - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` stayed flat around `144.2 MB`.
- Verification: focused save/load benchmarks passed; full `FreeX.Core.IO.Tests` passed `1750/1750`; post-rebase smoke passed `2/2`.

### App.UI Stable Render Cache Reuse And Single-Cell Selection Tail

- Branches: `codex/perf-app-ui-render-tail-20260603-r2`, `codex/perf-app-ui-render-tail-20260603-r3`.
- Commits: `714033cfe`, `55710539a`.
- Changes: reused pre-selection drawing layers after stable render keys, added stable selected-header cache, then fast-pathed single-cell selection/header repaint through cached render metric lookups.
- Metrics:
  - `GRID_RENDER_TEXT_HEAVY` allocation dropped from `46,120,912` bytes to tens of KB; rebased latest sample was `62.87 ms` / `74,400` bytes.
  - `GRID_RENDER_WRAPPED_TEXT_HEAVY` allocation dropped from `66,601,296` bytes to tens of KB; latest sample was `89.14 ms` / `44,280` bytes.
  - `GRID_RENDER_SELECTION_ONLY` latest sample was `36.67 ms` / `1,052,552` bytes.
- Verification:
  - Focused render benchmark set passed.
  - Fast-path/source guards passed.
  - Full `FreeX.App.UI.Tests` passed `566/566`.

### Data Validation Range List Items

- Branch: `codex/perf-datavalidation-list-tail-20260603-r1`.
- Commit: `1d89f78a5`.
- Change: range-backed `IReadOnlyList<string>` for simple data-validation range dropdown items avoids rematerializing the full item list on each request.
- Metrics:
  - `DATAVALIDATION_GET_LIST_ITEMS_RANGE` improved from `2,005,264` bytes to `4,464` bytes over 50 calls.
  - `DATAVALIDATION_RANGE_LIST_MATCH` was already low and stayed at `47,664` bytes.
- Verification:
  - `DataValidationServiceTests` passed `11/11`.
  - Full `FreeX.Core.Model.Tests` passed `1867/1867`.
  - `FreeX.Core.Calc.Tests` data-validation filter passed `44/44`.

### Low-Priority Tail Checked But Not Changed

- Branch checked: `codex/perf-gotospecial-datavalidation-tail-20260603-r1`.
- Result: no code change; `GOTO_SPECIAL_DATA_VALIDATION_RANGE_LOOKUP` is already low at `64,880` bytes over five runs, matching the conditional-format path. Remaining allocation is primarily required result materialization.
- Verification: focused Go To Special data-validation and conditional-format benchmarks passed `2/2`.

### Advanced Filter Copy Undo State

- Branch: `codex/perf-advanced-filter-tail-20260603-r1`.
- Commit: `08ab0f9d7`.
- Change: copy-to Advanced Filter no longer snapshots/restores `FilterHiddenRows`; only in-place filtering owns that undo state.
- Metric: `ADVANCED_FILTER_COPY_UNIQUE_DENSE` allocation improved slightly from `8,272,344` bytes to `8,272,024` bytes over five runs; the main value is narrower undo state and less unrelated mutation.
- Verification:
  - `AdvancedFilterCommandTests` passed `16/16`.
  - Focused post-rebase smoke passed `2/2`.
  - Full `FreeX.Core.Model.Tests` passed `1869/1869`.

### XLSX Source Metadata Preflight Cache

- Branch: `codex/perf-xlsx-io-tail-20260603-r3`.
- Commit: `1697d0396`.
- Change: cached source-package snapshot/preflight metadata for worksheet/style paths so dense loaded saves can avoid repeated XML/package inspection work while preserving native metadata fidelity.
- Metrics:
  - `XLSX_SAVE_LOADED_DENSE_MUTATED` improved from about `158,411,848` bytes to `156,311,824` bytes on the rebased run.
  - `XLSX_SAVE_LOADED_DENSE_POSTPROCESSING` improved from about `41,987,528` bytes to `40,723,392` bytes.
  - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` stayed effectively flat around `144.17 MB`.
  - `XLSX_SAVE_LOADED_DENSE` fast-copy stayed unchanged at `556,600` bytes.
- Verification:
  - Focused source/preflight guard tests passed `3/3`.
  - Focused performance benchmarks passed `4/4`.
  - Full `FreeX.Core.IO.Tests` passed `1752/1752`.

## Other Main Integrations During This Wave

Other sessions also advanced `main` with verified non-performance/refactor/parity work while this orchestrator was active, including sheet-tab chrome, App.UI rect hit testing, model command test-context cleanup, drawing arrange parity, IO native attribute helper reuse, advanced filter copy planning, command-bus undo entry refactor, FormulaEvaluator partial extraction, NativeJson cell DTO partial extraction, Host dispatcher test-pump sharing, disabled nonpersisted Options toggles, QAT validation, Flash Fill parity coverage clarification, and parity handoff updates.

## Remaining Backlog

The obvious high-impact backlog is reduced but not exhausted.

1. XLSX IO:
   - `XLSX_SAVE_LOADED_DENSE_MUTATED` is improved but still allocates around `156.3 MB`.
   - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` is improved again but still allocates around `144.2 MB`.
   - Unchanged loaded workbook fast-copy remains healthy: `XLSX_SAVE_LOADED_DENSE` around `554,248` bytes in the full IO run.
   - Latest IO worker has completed and integrated; further IO cuts likely require a deeper metadata load/save redesign.
2. App.Host toolbar/ribbon:
   - `NON_DRAG_SELECTION_TOOLBAR` remains around `13.0 MB`; current guardrails show zero QAT probes and zero toolbar writes.
   - `RIBBON_FORCE_COMPACT` remains around `14.6-14.7 MB`.
   - `SELECTION_DRAG_STATUS` and `ADDITIONAL_SELECTION_DRAG_TOOLBAR` remain around `22-23 MB` in recent samples after modest improvements.
   - Worker `019e8a99-d0bd-71a3-97d4-c7db4b824245` is currently investigating the next Host tail.
3. Core.Commands:
   - Dense insert undo allocation is improved; dense filter/table operations now report low allocations but still have time-cost tails worth rechecking if command work continues.
   - Advanced Filter copy-unique dense rows is improved to about `8.27 MB`; remaining cost is lower priority than the open Host/UI/Formula/XLSX tails.
   - Data-validation range list items are now low allocation; Go To Special data-validation lookup was checked and left unchanged because it is already low.
4. Formula/Core.Calc:
   - Repeated identical formula dependency rebuild improved again but still allocates about `17.35 MB`.
   - Formula parser/evaluator tail remains a candidate only if a semantics-safe path can be proven; the current graph pre-sizing tail is a small remaining win.
5. App.UI render:
   - Text-heavy and wrapped render allocations are now down to tens of KB in recent samples.
   - Selection-only repaint still allocates about `1.05 MB`; render timings remain noisy, so rerun a stable measurement set before declaring App.UI exhausted.

## Subagent Status

Completed and integrated performance agents from the resumed wave:

- `019e8a04-9993-7663-930f-ea1426223ebc`: Core.Commands dense cell shift, merged/pushed.
- `019e8a04-dae0-7613-ac67-604083e3be8d`: Formula parse-cache tail, merged/pushed.
- `019e8a04-59aa-7732-9c5d-368ae7fa311f`: App.Host ribbon resize, merged/pushed.
- `019e8a1a-9d81-70f3-933f-38956185f1dc`: XLSX dense loaded mutated save, merged/pushed.

Current 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8a34-a5dd-7091-91a2-477c1551093f`: App.Host toolbar/status tail, completed and pushed.
- `019e8a34-ba23-7b12-907a-d170358abd6f`: App.UI render benchmark/hot path, completed and pushed.
- `019e8a34-cf08-72c1-a27b-c921e95e05ed`: Formula/Core.Calc parse/eval tail, completed and pushed.
- `019e8a34-e815-7f12-9bd2-c548baf41c06`: XLSX IO dense-save/load metadata tail, completed and pushed.

Post-restart 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8a99-d0bd-71a3-97d4-c7db4b824245`: App.Host toolbar/status tail, still running at this checkpoint.
- `019e8a99-ff5d-7961-b27f-6a180f6427fb`: XLSX IO dense-save/load metadata tail, completed; rebased commit `1697d0396` integrated to `origin/main`.
- `019e8a9a-2f48-75a0-a430-0ba877c90268`: App.UI render tail, completed; rebased commit `55710539a` integrated to `origin/main`.

## Resume Checklist

1. Run:
   - `git fetch origin`
   - `git status --short --branch`
   - `git rev-list --left-right --count main...origin/main`
2. Confirm `main` and `origin/main` are aligned at or after `073a67c81`.
3. Start the next wave with disjoint scopes:
   - App.Host non-drag toolbar / drag-status allocation tail.
   - App.UI render benchmark stabilization and next hot path.
   - Formula/Core.Calc parse/eval tail beyond shared parse cache.
   - XLSX IO deeper dense-save/load metadata follow-up if a semantics-safe path is found.
4. Merge verified slices back to `main` promptly and push after each coherent unit.
