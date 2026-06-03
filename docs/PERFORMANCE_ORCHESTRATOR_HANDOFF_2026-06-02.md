# FreeX Performance Orchestrator Handoff - 2026-06-02

## Active Goal

Keep improving performance across the FreeX app end to end: use subagents to review bottlenecks, measure targeted baselines, implement prioritized optimizations, verify with tests and benchmarks, integrate cleanly, and continue until the practical improvement backlog is exhausted.

This goal is not complete. This file records the current clean checkpoint.

## Operating Rules

- Repository: `E:\Users\anton\Documents\Claude\Freexcel`.
- Latest upstream checkpoint before this handoff update: `8f3a72eb3`.
- `codex/performance-orchestrator-resume-20260602` was fast-forwarded onto `origin/main` at `8f3a72eb3` before this handoff update.
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
  - At this checkpoint, full `FreeX.App.Host.Tests` had a pre-existing unrelated source-hygiene failure. The later post-restart Host tail fixed the expected message key and the full Host suite passed.

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

### Core.Commands Dense Row/Column Move Tail

- Branch: `codex/perf-row-column-shift-tail-20260603-r2`.
- Commit: `d3d636257`.
- Change: row/column insert/delete commands now move dense shifted cells through a pooled original-cell buffer instead of retaining an original cell reference in every undo snapshot tuple.
- Metrics:
  - `INSERT_COLUMNS_DENSE_SHIFT` improved from `16,189,792` bytes to `15,229,792` bytes.
  - `DELETE_ROWS_DENSE_SHIFT` improved from `16,335,376` bytes to `15,375,376` bytes.
  - `DELETE_COLUMNS_DENSE_SHIFT` improved from `16,288,072` bytes to `15,328,072` bytes.
  - `INSERT_ROWS_DENSE_SHIFT` improved from `16,310,680` bytes to `15,350,680` bytes.
- Verification:
  - Focused `InsertDeleteRowsTests|InsertDeleteColumnsTests` passed `57/57`.
  - Full `FreeX.Core.Model.Tests` passed `1869/1869`.

### App.Host Toolbar/Status Hot Path Tail

- Branch: `codex/perf-host-toolbar-status-tail-20260603-r3`.
- Commit: `5538bfcf6`.
- Worker: `019e8a99-d0bd-71a3-97d4-c7db4b824245`, then final sync/verification/integration by the orchestrator after restart.
- Change: reused the selection-toolbar skip check for non-drag selection changes, added single-cell status-bar stats, fixed toolbar-state cache recency trimming after refresh, and added cheap malformed-path guards in Host planners. This slice also fixed the previously noted Host source hygiene failure by using the expected `MainWindowMessage_NoDrawingShapesOnSheet` key.
- Metrics from the synced focused run:
  - `NON_DRAG_SELECTION_TOOLBAR`: `12,995,976` bytes with `can_undo_probes=0`, `can_redo_probes=0`, `toolbar_writes=0`.
  - `RIBBON_FORCE_COMPACT`: `14,093,072` bytes.
  - `SELECTION_DRAG_STATUS`: `22,002,904` bytes.
  - `ADDITIONAL_SELECTION_DRAG_TOOLBAR`: `23,136,200` bytes.
- Verification:
  - `PerformanceReviewMeasurementTests` passed `17/17`.
  - Full `FreeX.App.Host.Tests` passed `5771/5772`, with `1` skipped.

### XLSX Style-Only Cell Insertion Tail

- Branch: `codex/perf-xlsx-io-tail-20260603-r4`.
- Commit: `28dc32ea1`.
- Change: `XlsxStyleOnlyCellWriter` now keeps a per-row insertion cursor while processing sorted style-only cells, avoiding a fresh row cell scan for every inserted style-only cell.
- Metrics:
  - Focused pre-change baseline: `XLSX_SAVE_STYLE_ONLY` `165,942,208` bytes, `1427.94 ms` mean.
  - Focused post-change sample after final sync: `143,138,344` bytes, `719.21 ms` mean.
  - Full performance-class post-change sample: `143,198,584` bytes, `584.11 ms` mean.
- Verification:
  - Focused style-only save and roundtrip checks passed `3/3`.
  - Full `XlsxFileAdapterPerformanceTests` passed `36/36`.
  - Full `FreeX.Core.IO.Tests` passed `1758/1758` at the final sync base.

### App.UI Selection-Only Header Render Tail

- Branch: `codex/perf-app-ui-selection-render-tail-20260603-r1`.
- Commit: `bad2009e5`.
- Worker: `019e8ad5-dce5-7f80-b359-967eb329494c`, then orchestrator rebased, reverified, and integrated.
- Change: selected header repaint now reuses cached frozen header text drawings, so single-cell selection-only repaints redraw selection chrome without reissuing header `DrawText` work for stable header labels.
- Metrics:
  - Local worker baseline: `GRID_RENDER_SELECTION_ONLY` `1,039,480` bytes, `53.75 ms` mean.
  - Focused post-rebase sample: `404,480` bytes, `36.99 ms` mean.
  - Full-suite post-rebase sample: `422,936` bytes, `42.84 ms` mean.
- Verification:
  - Focused App.UI render/selection set passed `96/96`.
  - Full `FreeX.App.UI.Tests` passed `567/567`.

### Formula Compact Range Dependency Tail

- Branch: `codex/perf-formula-eval-tail-20260603-r1`.
- Commit: `b0e435f7d`.
- Worker: `019e8ad5-f147-7f52-b755-57165012ca7e`, then orchestrator rebased, reviewed, reverified, and integrated.
- Change: only tiny ranges expand into exact dependency edges; larger ranges use compact range tracking, reducing repeated dependent-list fan-out during dependency rebuild.
- Metrics:
  - Worker isolated baseline: `REPEATED_IDENTICAL_FORMULA_REBUILD` `17,383,592` bytes, `194.33 ms`.
  - Worker final isolated sample: `15,484,568` bytes, `166.92 ms`.
  - Orchestrator focused post-rebase warm sample: `2,703,144` bytes, `239.83 ms`, `540` bytes/formula.
- Verification:
  - Focused dependency/benchmark set passed `27/27`.
  - Full `FreeX.Core.Calc.Tests` passed `666/666`.
  - Full `FreeX.Core.Formula.Tests` passed `2716/2716`.

### XLSX Ignored Errors Worksheet Save Tail

- Branch: `codex/perf-xlsx-metadata-save-tail-20260603-r1`.
- Commit: `ca85fa850`.
- Change: ignored-errors post-processing now reuses the shared worksheet path map/edit session and pre-sizes ignored-cell run capture exactly for the sheet.
- Metrics:
  - Focused baseline: `XLSX_SAVE_IGNORED_ERRORS` `83,004,720` bytes, `520.83 ms` mean.
  - Focused post-rebase sample: `81,463,504` bytes, `339.65 ms` mean.
  - Data-validation native metadata allocation remained essentially flat around `80.4 MB`.
- Verification:
  - Focused ignored-errors correctness and benchmark set passed `8/8`.
  - Full `FreeX.Core.IO.Tests` passed `1775/1775`.

### Core.Commands Cell State Snapshot Tail

- Branch: `codex/perf-core-commands-tail-20260603-r1`.
- Commit: `5de331aac`.
- Worker: `019e8aee-e6ff-79f1-bfec-cf36cb75b866`, then orchestrator rebased, reviewed, reverified, and integrated.
- Change: row/column insert/delete undo snapshots now store captured cell state fields and materialize `Cell` instances only during undo.
- Metrics:
  - `INSERT_ROWS_DENSE_SHIFT`: `15,350,608` bytes -> `12,482,128` bytes.
  - `DELETE_ROWS_DENSE_SHIFT`: `15,375,304` bytes -> `12,524,968` bytes.
  - `INSERT_COLUMNS_DENSE_SHIFT`: `15,229,720` bytes -> `12,421,720` bytes.
  - `DELETE_COLUMNS_DENSE_SHIFT`: `15,328,000` bytes -> `12,593,440` bytes.
- Verification:
  - Rebased dense command/filter benchmark set passed `9/9`.
  - Focused insert/delete row/column tests passed `58/58`.
  - Full `FreeX.Core.Model.Tests` passed `1872/1872`.

### App.UI Formula Trace Arrow Drawing Tail

- Branch: `codex/perf-app-ui-trace-render-tail-20260603-r1`.
- Commit: `b2c4e3bdf`.
- Change: visible formula-trace arrow rendering now reuses cached frozen `DrawingGroup` instances keyed by start/end points, while preserving the existing frozen arrowhead geometry cache and clearing both caches on formula-trace input changes.
- Metrics:
  - Pre-change focused baseline: `FORMULA_TRACE_VISIBLE_ARROW_DRAW` about `36,913,576` bytes, `30.97 ms` mean.
  - Final focused post-rebase sample: `5,306,536` bytes, `2.96 ms` mean.
  - Final full-suite sample: `5,306,536` bytes, `1.49 ms` mean.
- Verification:
  - Focused formula trace benchmark/source-guard set passed `2/2`.
  - Full `FreeX.App.UI.Tests` passed `567/567`.

### App.UI Formula Trace Layout Lookup Tail

- Branch: `codex/perf-app-ui-formula-layout-tail-20260603-r1`.
- Commit: `7613818b3`.
- Change: formula-trace layout now uses a per-visit allocation-free metric lookup with cached row/column bounds and array/list fast paths instead of building row/column dictionaries for each visit.
- Metrics:
  - Same-machine baseline from the prior App.UI trace branch: `FORMULA_TRACE_LAYOUT_VISITOR` visitor `1,186,600` bytes, `87.07 ms` mean sample.
  - Final focused post-rebase sample: visitor `5,160` bytes, `108.38 ms` mean.
  - Final full-suite sample: visitor `5,160` bytes; timing remains noisy (`207.58 ms` in the full run).
- Verification:
  - Focused formula-trace layout benchmark/source-guard set passed `3/3`.
  - Full `FreeX.App.UI.Tests` passed `567/567`.

### XLSX Loaded Dense Mutated Save Normalization Tail

- Branch: `codex/perf-xlsx-dense-mutated-regression-20260603-r1`.
- Commit: `50bac941e`.
- Worker: `019e8b08-c2a0-7992-bd1f-a9fe95c32e3f`, then orchestrator rebased, reviewed, reverified, and integrated.
- Change: source-package Excel compatibility normalization now builds a small plan so worksheet-level compatibility scans run only when relevant, while workbook-level repairs still run unconditionally.
- Metrics:
  - Worker baseline on current `origin/main`: `XLSX_SAVE_LOADED_DENSE_MUTATED` `244,860,704` bytes, `694.16 ms` mean, `793.94 ms` p95.
  - Worker final sample: `157,533,264` bytes, `514.92 ms` mean, `642.55 ms` p95.
  - Orchestrator post-rebase focused sample: `150,107,432` bytes, `227.39 ms` mean, `258.63 ms` p95.
- Verification:
  - Worker baseline and branch benchmark each passed `1/1`.
  - Worker focused Core.IO normalizer/performance set passed `39/39`.
  - Worker full `FreeX.Core.IO.Tests` passed `1777/1777`.
  - Orchestrator post-rebase focused Core.IO normalizer/performance set passed `39/39`.
  - Excel desktop openability smoke was not run; coverage is package-level correctness plus the Core.IO suite.

### XLSX Native Data Validation Save Tail

- Branch: `codex/perf-xlsx-datavalidation-save-tail-20260603-r1`.
- Commit: `2a6c3066d`.
- Local orchestrator slice after restart.
- Change: sheets carrying native data-validation metadata now skip the duplicate ClosedXML data-validation save pass and emit the full `<dataValidations>` element directly during worksheet XML post-processing, while preserving native container/rule metadata and keeping ordinary validation sheets on the existing ClosedXML path.
- Metrics:
  - Pre-change baseline before commit: `XLSX_SAVE_DATA_VALIDATION_NATIVE_METADATA` `80,514,024` bytes, `104.23 ms` mean.
  - Focused post-rebase sample: `18,650,496` bytes, `33.17 ms` mean, `35.55 ms` p95.
  - Data-validation correctness run sample: `18,591,848` bytes, `48.65 ms` mean.
- Verification:
  - Focused benchmark/source-guard set passed `2/2`.
  - Data-validation correctness/schema set passed `20/20`.
  - Full `FreeX.Core.IO.Tests` passed `1777/1777`.

### App.UI Resize Pre-Selection Layer Cache Tail

- Branch: `codex/perf-app-ui-render-tail-20260603-r4`.
- Commit: `f9115462f`.
- Local orchestrator slice after restart.
- Change: the pre-selection render-surface cache now keys full/light layer mode separately and remains enabled when a resize target is active but live resize continuation is not being drawn. This lets column/row resize repaint paths reuse stable grid/cell/header pre-selection drawing instead of rebuilding it every frame.
- Metrics:
  - Baseline before change: `GRID_RENDER_CHART_DIMENSION_RESIZE` `14,302,656` bytes, `83.41 ms` mean.
  - Focused post-change sample: `51,976` bytes, `55.35 ms` mean.
  - Full render-benchmark sample: `46,008` bytes, `39.89 ms` mean.
  - Full App.UI suite sample: `46,008` bytes, `46.42 ms` mean.
- Verification:
  - Focused resize benchmark/source-guard set passed `2/2`.
  - Full `GridViewPerformanceMeasurementTests` passed `16/16`.
  - Full `FreeX.App.UI.Tests` passed `567/567`.

### App.UI Drawing Object Layer Cache Tail

- Branch: `codex/perf-app-ui-drawing-objects-tail-20260603-r1`.
- Commit: `e5699197b`.
- Change: stable floating object bodies now render through a cached frozen drawing layer, separate from selection handles and drag/crop previews. Object source, theme, viewport, and selected-range changes invalidate the cache.
- Metrics:
  - Baseline before change: `GRID_RENDER_DRAWING_OBJECTS` `5,221,792` bytes, `133.07 ms` mean.
  - Focused post-rebase sample: `45,976` bytes, `90.69 ms` mean.
  - Full App.UI sample: `52,664` bytes, `102.98 ms` mean.
- Verification:
  - Focused drawing-object benchmark/source-guard set passed `4/4`.
  - Full render benchmark set passed `16/16`.
  - Full `FreeX.App.UI.Tests` passed `570/570`.

### XLSX Ignored-Error Style-Only Load Bound

- Branch: `codex/perf-xlsx-load-ignored-style-tail-20260603-r1`.
- Commit: `853119318`.
- Worker: `019e8b24-13ea-7bc3-9bac-c7c1357831a2`, then orchestrator rebased, reviewed, reverified, and integrated.
- Change: known worksheet layouts now skip expensive ClosedXML style-only stripping unless aggregate explicit style-only cells exceed `16,384`; warning/unknown-pressure paths stay conservative.
- Metrics:
  - Worker baseline: `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` `144,217,480` bytes, `1427.30 ms` mean, `1614.41 ms` p95.
  - Worker final sample: `129,266,064` bytes, `1090.89 ms` mean, `1290.33 ms` p95.
  - Orchestrator post-rebase focused sample: `131,568,456` bytes, `762.38 ms` mean, `797.47 ms` p95.
  - Full Core.IO sample: `131,518,664` bytes, `1215.52 ms` mean, `1265.03 ms` p95.
- Verification:
  - Focused load/style/correctness set passed `35/35`.
  - Full `FreeX.Core.IO.Tests` passed `1779/1779`.

### App.Host Drag Selection And Ribbon Compact Tail

- Branch: `codex/perf-host-drag-ribbon-tail-20260603-r1`.
- Commit: `66a60b9eb`.
- Worker: `019e8b08-ae70-7c80-b40e-fa0432e027e1`, then orchestrator cleaned stale rebase drift, recommitted a Host-only patch, reverified, and integrated.
- Change: repeated drag selection targets now stay allocation-light and skip redundant refresh work, while ribbon adaptive planning/apply paths avoid avoidable state mutation and allocation on repeated compact/resize states.
- Metrics from the final focused verification:
  - `SELECTION_DRAG_REPEATED_TARGET`: `64` bytes across `2,000` steps.
  - `ADDITIONAL_SELECTION_DRAG_REPEATED_TARGET`: `1,088` bytes across `2,000` steps.
  - `NON_DRAG_SELECTION_TOOLBAR`: `12,203,384` bytes, `14.96 ms` mean, with zero undo/redo probes and zero toolbar writes.
  - `RIBBON_RESIZE`: `12,277,392` bytes, `32.25 ms` mean.
  - `RIBBON_FORCE_COMPACT`: `13,445,872` bytes.
  - `RIBBON_FORCE_COMPACT_SKIP`: `439,344` bytes across `300` steps, with `300` applied-state skips and zero state applies.
  - `SELECTION_DRAG_STATUS`: `4,619,592` bytes.
  - `ADDITIONAL_SELECTION_DRAG_TOOLBAR`: `5,732,888` bytes.
- Verification:
  - Final focused Host performance/test filter passed `159/159`.
  - Broad Host suite excluding only the two known current-main failures passed `5789/5789`, with `1` skipped.
  - Full Host on the branch failed only `ConfigureServices_NativeFreexWorkbookAppearsInSaveFilter` and `RibbonSplitButtonHover_UsesRibbonButtonHoverBrushInsteadOfMenuHoverBrush`; the same two-test filter reproduced both failures on detached `origin/main`.

### XLSX Drawing Picture Load Tail

- Branch: `codex/perf-xlsx-drawing-load-tail-20260603-r1`.
- Commit: `30207e687`.
- Local orchestrator slice.
- Change: worksheet drawing picture load now reads image ZIP entries directly into one owned byte array, transfers that owned buffer into `PictureModel` without a second copy, and uses single-pass picture XML helpers for non-visual properties, embed relationships, and nearest anchors.
- Metrics:
  - Baseline before change: `XLSX_LOAD_DRAWING_PICTURES` `23,614,088` bytes, `254.51 ms` mean.
  - Final focused sample: `22,846,160` bytes, `104.11 ms` mean.
  - Drawing/picture correctness sample: `22,798,376` bytes, `116.02 ms` mean.
- Verification:
  - Focused drawing-picture benchmark/source-guard set passed `2/2`.
  - Drawing/picture Core.IO correctness set passed `67/67`.
  - Full `FreeX.Core.IO.Tests` passed `1780/1780`.

### App.UI Drawing Object Cache Warm-Up Tail

- Branch: `codex/perf-app-ui-drawing-followup-20260603-r1`.
- Commit: `0382937a1`.
- Worker: `019e8b6a-e31e-73f2-a807-ba672fc87d85`, then orchestrator rebased, reviewed, reverified, and integrated.
- Change: drawing-object layer caching now builds the frozen cached layer only after a second identical render key, avoiding cache construction for one-off first renders and transient invalidations while preserving steady-state cached repaint behavior.
- Metrics:
  - Worker baseline `GRID_RENDER_OFFSCREEN_DRAWING_OBJECTS`: `38,592` bytes, `29.45 ms` mean.
  - Worker patched sample: `38,592` bytes, `28.97 ms` mean.
  - Orchestrator post-rebase focused sample: `26,200` bytes, `28.76 ms` mean.
  - `DRAWING_OBJECT_ANCHOR_RECT_LOOKUP` allocation stayed at `3,112` bytes; timing remained noisy.
- Verification:
  - Focused drawing-cache/offscreen/anchor benchmark set passed `3/3`.
  - Broader drawing/render set passed `112/112`.
  - Full `FreeX.App.UI.Tests` passed `570/570`.

### XLSX Style-Only Row Insertion Cursor Tail

- Branch: `codex/perf-xlsx-styleonly-save-tail-20260603-r1`.
- Commit: `d468bb5bd`.
- Worker: `019e8b77-a76a-7d00-b175-90ebb05259ba`, then orchestrator reviewed, re-ran focused verification, committed, and integrated.
- Change: style-only worksheet post-processing now keeps a forward row insertion cursor, avoiding a fresh worksheet-row scan for every newly inserted style-only row.
- Metrics:
  - Worker baseline `XLSX_SAVE_STYLE_ONLY`: `144,065,592` bytes, `650.01 ms` mean.
  - Worker final post-sync sample: `143,924,120` bytes, `606.30 ms` mean.
  - Orchestrator focused repeat: `143,993,336` bytes, `601.21 ms` mean.
  - Targeted mixed style-only/ignored-error run was noisy for timing but passed all facts; `XLSX_SAVE_IGNORED_ERRORS` remained essentially unchanged around `81.45 MB`.
- Verification:
  - Focused style-only/ignored-error benchmark and correctness set passed `29/29`.
  - No-build style-only benchmark repeat passed `1/1`.
  - Worker full `FreeX.Core.IO.Tests` passed `1780/1780`.

### Core.Commands Formula Audit Inconsistency Scan Tail

- Branch: `codex/perf-formula-eval-tail-20260603-r2`.
- Commit: `cf15c0392`.
- Change: inconsistent-formula auditing now scans in-place sorted row/column runs instead of building LINQ `GroupBy`/`OrderBy`/`ToList` scaffolding, and stores formula patterns as value records.
- Metrics:
  - Baseline `FORMULA_AUDIT_SPARSE_FORMULAS`: `5,902,192` bytes, `31.64 ms` mean.
  - Final focused/full-class samples: `1,882,336` bytes, about `25.1-25.9 ms` mean.
- Verification:
  - `FormulaAuditingServiceTests` passed `86/86`.
  - Full `FreeX.Core.Model.Tests` initially had two noisy `CellAddressTests` allocation guard failures; both passed on direct rerun.
  - Broad `FreeX.Core.Model.Tests` excluding only those two noisy guards passed `1886/1886`.
  - `git diff --check` passed.

### App.Host Split-Pane Nullable Flow Hotfix

- Branch: `codex/fix-splitpane-scrollbar-nullability-20260603`.
- Commit: `de506e356`, integrated through merge commit `6384ac574`.
- Change: fixed downstream App.Host nullable flow after the split-pane scrollbar DTOs became value records by capturing nullable scrollbars into non-null locals before passing them to wheel-target calculations.
- Verification evidence:
  - The Host viewport benchmark compiled and passed after the fix.
  - Later targeted Host run on current `origin/main` passed localization plus viewport benchmark filter `132/132`.

### App.Host Satellite Localization Resource Drift

- Worker: `019e8bbe-e1e1-7f51-9316-bc063c95d00f`.
- Branch: `codex/app-host-localization-resources-20260603`.
- Commit: `461a30e5a` after orchestrator rebase.
- Change: synchronized all 43 App.Host satellite resource files with the 12 neutral Quick Access Toolbar keys that current `origin/main` was missing.
- Reason: this unblocked full App.Host verification drift discovered while validating the performance slice.
- Verification:
  - Worker focused localization/AppLanguageCatalog tests passed `131/131`.
  - Orchestrator post-rebase localization/AppLanguageCatalog run passed `131/131`.
  - Targeted integrated-main Host run including localization and viewport benchmark passed `132/132`.
  - `git diff --check` passed.

### App.Host Viewport DisplayCell Allocation Tail

- Local orchestrator branch: `codex/perf-viewport-displaycell-tail-20260603-r1`.
- Commit: `19a4056b5`.
- Change: made `DisplayCell` a `readonly record struct` and changed split-pane materialized layout storage to hold compact source cell indexes plus geometry arrays, avoiding large repeated `DisplayCell` copies inside `SplitPaneCellLayout` backing arrays.
- Metrics:
  - `VIEWPORT_NO_COMMENTS_FAST_PATH` improved from `44,977,320` bytes to `35,761,320` bytes in the focused branch run.
  - Integrated-main targeted Host run reported `35,766,736` bytes.
  - The first naive DTO-only attempt regressed `SPLIT_PANE_CELL_LAYOUT_MATERIALIZATION` to about `115.6 MB`; compact layout storage brought it back under guard at `63,379,240` bytes, with visitor allocation unchanged at `4,563,240` bytes.
- Verification:
  - `dotnet build FreeX.slnx` passed.
  - `FreeX.Core.Model.Tests` passed `1893/1893`.
  - `FreeX.Core.Calc.Tests` passed `673/673`.
  - Full `FreeX.App.UI.Tests` passed `570/570`.
  - Focused Host viewport benchmark passed after integration.
  - `git diff --check` passed.

### Core.Formula Direct XNPV Range Streaming

- Worker: `019e8bbf-0a6b-79b1-9f0f-8754062c2052`.
- Branch: `codex/perf-tail-explore-20260603`.
- Commit: `e00bd5d67` after orchestrator rebase.
- Change: added a direct XNPV financial fast path that streams value/date ranges instead of materializing large date/value lists.
- Metric: `XNPV large cash-flow range` allocation improved from `320,360` bytes to `48` bytes in the worker benchmark.
- Verification:
  - Worker focused XNPV/financial tests passed `3/3`.
  - Worker full `FreeX.Core.Formula.Tests` passed `2716/2716`.
  - Orchestrator post-rebase focused XNPV filter passed `4/4`.
  - Orchestrator full `FreeX.Core.Formula.Tests` passed `2716/2716`.
  - Integrated-main focused XNPV allocation guard passed.
  - `git diff --check` passed.

### Core.IO NativeJson Loaded Cell Pre-sizing

- Local orchestrator branch: `codex/perf-nativejson-tail-20260603-r1`.
- Commit: `f35ffa046`.
- Change: exposed the deserialized `CellDtoSequence.Count` and called the existing `Sheet.EnsureCellCapacity` before loading native JSON cells into a sheet.
- Metrics:
  - `NATIVE_JSON_LOAD_DENSE` improved from `44,182,608` bytes to `37,782,672` bytes in focused samples.
  - `NATIVE_JSON_LOAD_REPEATED_STYLES` improved from `27,672,864` bytes to `21,740,168` bytes in focused samples; integrated-main sample was `21,740,192` bytes.
  - Save benchmarks were unchanged by design (`NATIVE_JSON_SAVE_DENSE` remained about `29,231,000` bytes; workbook references about `8,381,816` bytes).
- Verification:
  - Focused `NativeJsonAdapterPerformanceTests` passed `11/11`.
  - No-build repeat of the two affected load benchmarks passed `2/2`.
  - Full `FreeX.Core.IO.Tests` passed `1781/1781` before and after rebase.
  - Integrated-main focused NativeJson load/source-guard filter passed `3/3`.
  - `git diff --check` passed.

### App.Host Non-local Test Drift Cleanup

- Worker: `019e8bbe-f615-7303-9419-36121e2f20c5`.
- Branch: `codex/app-host-nonlocal-test-drift-20260603`.
- Commits after orchestrator rebase: `38075f26c`, `b7386880d`, `028cd235c`.
- Change: updated the native FreeX save-filter index expectation to match current adapter ordering, removed mojibake from Formula source comments, and refreshed the live repository metrics in `docs/PROJECT_STATUS_REPORT_2026-06-01.md`.
- Verification:
  - Worker focused drift filter passed `3/3`.
  - Orchestrator post-rebase focused drift filter passed `3/3`.
  - Full `FreeX.App.Host.Tests` passed `5794/5796` with `1` skipped and one transient `MainWindowSheetTabKeyboardTests.SheetTabActiveAndAddTab_StayBelowGridRule` focus failure; that exact test passed on direct rerun.
  - Integrated-main focused drift filter passed `3/3`.
  - `git diff --check` passed.

### Core.Formula Direct NPV Range Streaming

- Worker: `019e8bd4-d108-7eb2-a604-16e564c63798`.
- Local clean integration branch: `codex/perf-formula-npv-range-tail-20260603-r1`.
- Commit integrated to `origin/main`: `513eea00c`.
- Change: isolated the worker's `726b83e60` NPV patch onto a fresh branch from current `origin/main`, avoiding unrelated local `main` parity/refactor commits. The NPV fast path streams direct range values instead of materializing large value arrays.
- Metrics:
  - Worker baseline `NPV(0.08,A1:A20000)`: `10.82 ms`, `1,324,912` bytes.
  - Worker final focused sample: `9.82 ms`, `88` bytes.
- Verification:
  - Worker focused NPV tests passed `8/8`.
  - Worker full Formula tests passed `2718/2718`.
  - Orchestrator clean-branch focused NPV/XNPV filter passed `11/11`.
  - Orchestrator clean-branch full `FreeX.Core.Formula.Tests` passed `2718/2718`.
  - Integrated-main focused NPV allocation/source filter passed `2/2`.
  - `git diff --check HEAD~1..HEAD` passed.

### App.Host Native Visual Filter Pivot Lookup Cache

- Local orchestrator branch: `codex/perf-local-census-tail-20260603-r1`.
- Commit integrated to `origin/main`: `20bf862c8`.
- Change: caches active-sheet PivotTable name lookups in `SlicerTimelinePlanner` with a `ConditionalWeakTable<Sheet, ...>` and exact name-sequence validation, and pre-sizes visible slicer/timeline result lists for large workbook refreshes.
- Metrics:
  - `NATIVE_VISUAL_FILTERS_LARGE_PAIRED` improved from `58,544,840` bytes to `9,622,440` bytes over `100` paired calls for `6,000` visible controls.
  - Empty-workbook fast path stayed allocation-flat at `40` bytes.
- Verification:
  - Focused `SlicerTimelinePlannerTests` passed `16/16` after rebase.
  - Full `FreeX.App.Host.Tests` passed `5796/5797`, with `1` skipped.
  - `git diff --check HEAD~1..HEAD` passed.

### Core.Formula Direct IRR Range Streaming

- Worker: `019e8bf2-ff68-7322-8f52-42c5c3ee6c3b`.
- Branch: `codex/core-formula-financial-tail-20260603`.
- Commit integrated to `origin/main`: `8f3a72eb3`.
- Change: added a direct `IRR(A1:A...)` range path that collects numeric cash flows from cells without first materializing a `RangeValue` matrix, reusing the existing IRR solver.
- Metrics:
  - Worker baseline `IRR` over `20,000` cash-flow cells: `8.25 ms`, `160,336` bytes.
  - Final focused sample after rebase: `8.24 ms`, `152` bytes.
- Verification:
  - Focused IRR/financial filter passed `101/101`.
  - Full `FreeX.Core.Formula.Tests` passed `2719/2719`.
  - `git diff --check HEAD~1..HEAD` passed.

### Core.IO XLSX Allocation Tail No-patch Probe

- Worker: `019e8bf2-c3b6-7213-8022-2d1b9c5fcf79`.
- Branch: `codex/xlsx-core-io-allocation-tail-20260603`.
- Result: no patch carried; branch left clean at `bdfdb6c84`.
- Rejected candidates:
  - Skipping the default theme rewrite was semantically unsafe: `XlsxFileAdapter_SaveDefaultTheme_RoundTripsOfficeTheme` showed ClosedXML's default theme round-trips as `"Office Theme"` instead of the modeled `"Office"`.
  - Pre-sizing load-time package-copy `MemoryStream`s in the ClosedXML sanitizer/style-only stripper was semantics-safe but allocation-flat/noisy; `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` moved from `131,569,008` bytes to `131,572,312`, and save tails were flat or worse.
- Current synced focused samples:
  - `XLSX_SAVE_STYLE_ONLY`: `144,747,016` bytes.
  - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA`: `131,569,208` bytes.
  - `XLSX_SAVE_LOADED_DENSE_MUTATED`: `157,801,408` bytes.
  - `XLSX_LOAD_DRAWING_PICTURES`: `22,845,712` bytes.

## Other Main Integrations During This Wave

Other sessions also advanced `main` with verified non-performance/refactor/parity work while this orchestrator was active, including sheet-tab chrome, App.UI rect hit testing, model command test-context cleanup, drawing arrange parity, IO native attribute helper reuse, advanced filter copy planning, command-bus undo entry refactor, FormulaEvaluator partial extraction, NativeJson cell DTO partial extraction, Host dispatcher test-pump sharing, disabled nonpersisted Options toggles, QAT validation, Flash Fill parity coverage clarification, and parity handoff updates.

## Remaining Backlog

The obvious high-impact backlog is reduced but not exhausted.

1. XLSX/Core.IO:
   - `XLSX_SAVE_LOADED_DENSE_MUTATED` was re-stabilized from about `244.9 MB` to `150.1-157.5 MB` by skipping irrelevant worksheet compatibility scans; further wins likely require deeper package normalization redesign.
   - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` improved again and now allocates around `131.5 MB` in full Core.IO samples; a post-resume Core.IO worker found only a ~`211 KB` narrow XML-read delta and reverted it, so further wins likely need package/model construction redesign.
   - `XLSX_SAVE_STYLE_ONLY` improved modestly again to about `143.9-144.0 MB` with the forward row insertion cursor tail, but remains a high-allocation save path because ClosedXML/style seeding and package XML rewriting still dominate.
   - `XLSX_SAVE_IGNORED_ERRORS` improved to about `81.46 MB`; `XLSX_SAVE_DATA_VALIDATION_NATIVE_METADATA` improved from about `80.5 MB` to about `18.6 MB`.
   - `XLSX_LOAD_DRAWING_PICTURES` now has a current baseline and a small copy/traversal win (`23.6 MB` to about `22.8 MB`); further cuts likely require a larger picture-storage or image-retention redesign.
   - A post-`11bcab08a` Core.IO profiling worker found no practical narrow follow-up: `XLSX_SAVE_STYLE_ONLY` was about `143,994,216` bytes, `XLSX_LOAD_DRAWING_PICTURES` about `22,846,608` bytes, and `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` about `131,572,344` bytes. Its style-only save trial was effectively flat (`~184` bytes on a `~144 MB` path) and was reverted.
   - A later Core.IO worker again found no safe practical patch: default-theme rewrite skipping failed semantics, and package-copy `MemoryStream` pre-sizing was allocation-flat/noisy. Current focused samples are `XLSX_SAVE_STYLE_ONLY` `144,747,016` bytes, `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` `131,569,208` bytes, `XLSX_SAVE_LOADED_DENSE_MUTATED` `157,801,408` bytes, and `XLSX_LOAD_DRAWING_PICTURES` `22,845,712` bytes.
   - Unchanged loaded workbook fast-copy remains healthy: `XLSX_SAVE_LOADED_DENSE` around `554,248` bytes in the full IO run.
   - NativeJson dense load now pre-sizes sheet cell storage: `NATIVE_JSON_LOAD_DENSE` improved from `44.18 MB` to `37.78 MB`, and repeated custom styles load improved from `27.67 MB` to about `21.74 MB`.
   - Further IO cuts likely require deeper metadata load/save redesign or more streaming XML writers.
2. App.Host toolbar/ribbon:
   - `NON_DRAG_SELECTION_TOOLBAR` is down to about `12.2 MB`; current guardrails show zero QAT probes and zero toolbar writes.
   - `RIBBON_FORCE_COMPACT`/compact skip paths did not produce a proven allocation win in the post-resume Host worker; the same-base candidate was timing-noisy and allocation-flat, so future Host work should start with allocation profiling.
   - `SELECTION_DRAG_STATUS` and `ADDITIONAL_SELECTION_DRAG_TOOLBAR` are about `4.6 MB` and `5.7 MB` respectively in the latest focused run; treat them as lower priority unless a new benchmark regresses.
   - Native visual filter refresh for large slicer/timeline workbooks improved after the latest wave: `NATIVE_VISUAL_FILTERS_LARGE_PAIRED` dropped from `58,544,840` bytes to `9,622,440` bytes by caching active PivotTable name lookups and pre-sizing visible control lists.
   - App.Host deterministic non-local drift failures are fixed on `origin/main`; a full Host run had one transient keyboard-focus failure that passed on direct rerun.
   - The restarted Host worker branch is integrated; future Host work should start from current `origin/main` and avoid overlapping stale worktrees.
3. Core.Commands:
   - Dense insert undo and dense row/column shift allocations are improved; dense row/column shift now allocates about `12.4-12.6 MB`, so further improvement probably needs model-level cell move primitives or a deeper snapshot/restore redesign.
   - Dense filter/table operations now report low allocations but still have time-cost tails worth rechecking if command work continues.
   - Advanced Filter copy-unique dense rows is improved to about `8.27 MB`; remaining cost is lower priority than the open Host/UI/Formula/XLSX tails.
   - Formula auditing sparse formula scans improved from about `5.9 MB` to `1.88 MB`; remaining issue-scan work is lower priority unless a new benchmark exposes it.
   - Clipboard dense serialize/deserialize was reprobed: serialize is mostly output-string allocation, dense deserialize is mostly returned field strings/row arrays, so no patch was carried.
   - Data-validation range list items are now low allocation; Go To Special data-validation lookup was checked and left unchanged because it is already low.
4. Formula/Core.Calc:
   - Repeated identical formula dependency rebuild improved again; latest isolated worker sample was `15.48 MB`, while warm focused runs can be much lower because dependency-plan caches are hot.
   - Core.Calc conditional-format formula rule stacking improved after the handoff: `CF_FORMULA_RULES` dropped from `12,387,000` bytes to `5,643,480` bytes by caching repeated stacked CF style combinations per viewport.
   - Core.Calc dependency rebuild improved again after the handoff: repeated identical formula dependency rebuild dropped from about `15,454,928` bytes / `3,090` bytes per formula to `1,916,992` bytes / `383` bytes per formula by grouping identical compact range dependencies in the range index.
   - Core.Formula XNPV range evaluation improved after the handoff: the large cash-flow range guard dropped from `320,360` bytes to `48` bytes by streaming direct value/date ranges.
   - Core.Formula NPV range evaluation improved after the handoff: `NPV(0.08,A1:A20000)` allocation dropped from `1,324,912` bytes to `88` bytes by streaming direct range values.
   - Core.Formula IRR range evaluation improved after the handoff: `IRR(A1:A20000)` allocation dropped from `160,336` bytes to `152` bytes by streaming direct range cash-flow collection.
   - Formula built-in focused benchmarks were reprobed after the handoff: `UNIQUE_SINGLE_COLUMN` was about `742,824` bytes and is still mostly required `HashSet` plus returned `RangeValue` storage; `REPT_LARGE_RESULT` was about `65,736` bytes and already bounded by output-string allocation.
   - Formula parser/evaluator tail remains a candidate only if a semantics-safe path can be proven; the latest broad focused Formula test run passed without exposing a narrow patch.
5. App.UI render:
   - Text-heavy and wrapped render allocations are now down to tens of KB in recent samples.
   - Selection-only repaint improved from about `1.04 MB` to about `0.40-0.43 MB`; render timings remain noisy.
   - Formula-trace visible arrow drawing improved from about `36.9 MB` to `5.3 MB`.
   - Formula-trace layout visitor improved from about `1.19 MB` to about `5 KB`; timing remains noisy and should be watched if more render work touches that planner.
   - Chart dimension resize repaint improved from about `14.3 MB` to about `46-52 KB` by reusing the light pre-selection render layer cache.
   - Drawing-object render allocation improved from about `5.2 MB` to `46-53 KB`; offscreen drawing-object repaint is now around `26 KB` on the latest sample, and anchor lookup remains allocation-flat at about `3 KB`.
   - Split-pane scrollbar chrome improved after the handoff by changing the layout DTOs to value records: `SPLIT_PANE_SCROLLBAR_CHROME` dropped from `16,000,048` bytes to `4,000,040` bytes for `50,000` steps.
   - Viewport DisplayCell allocation improved after the handoff: `VIEWPORT_NO_COMMENTS_FAST_PATH` dropped from `44,977,320` bytes to about `35,766,736` bytes after `DisplayCell` became a value DTO and split-pane materialization switched to compact cell-index storage. Watch this public DTO change if future code depends on reference identity or nullable `DisplayCell?` semantics.

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

- `019e8a99-d0bd-71a3-97d4-c7db4b824245`: App.Host toolbar/status tail, completed; orchestrator committed and integrated `5538bfcf6`.
- `019e8a99-ff5d-7961-b27f-6a180f6427fb`: XLSX IO dense-save/load metadata tail, completed; rebased commit `1697d0396` integrated to `origin/main`.
- `019e8a9a-2f48-75a0-a430-0ba877c90268`: App.UI render tail, completed; rebased commit `55710539a` integrated to `origin/main`.

Next-wave 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8ad5-c8c1-7023-8e84-e21232b61bed`: App.Host drag-status/ribbon compact tail, shut down for the Codex restart before reporting completion.
- `019e8ad5-dce5-7f80-b359-967eb329494c`: App.UI selection-render tail, completed; rebased commit `bad2009e5` integrated to `origin/main`.
- `019e8ad5-f147-7f52-b755-57165012ca7e`: Formula/Core.Calc tail, completed; rebased commit `b0e435f7d` integrated to `origin/main`.

Local orchestrator next-wave slice:

- `codex/perf-xlsx-io-tail-20260603-r4`: XLSX style-only cell insertion tail, completed; commit `28dc32ea1` integrated to `origin/main`.

Restarted 2026-06-03 workers after Codex restart:

- `019e8aee-d2ca-73d2-910a-69e2d3451dd1`: App.Host drag-status/ribbon compact tail, superseded by restarted worker `019e8b08-ae70-7c80-b40e-fa0432e027e1` and the integrated Host slice.
- `019e8aee-e6ff-79f1-bfec-cf36cb75b866`: Core.Commands dense-shift tail, completed; rebased commit `5de331aac` integrated to `origin/main`.
- `019e8b08-ae70-7c80-b40e-fa0432e027e1`: App.Host drag-status/ribbon compact tail, restarted after the user-requested Codex restart; completed, cleaned to Host-only commit `66a60b9eb`, and integrated to `origin/main`.
- `019e8b08-c2a0-7992-bd1f-a9fe95c32e3f`: XLSX dense mutated save regression, completed; rebased commit `50bac941e` integrated to `origin/main`.
- `019e8b24-13ea-7bc3-9bac-c7c1357831a2`: XLSX load ignored-error/style-only metadata tail, restarted after the user-requested Codex restart; completed, rebased commit `853119318` integrated to `origin/main`.

Follow-up 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8b6a-e31e-73f2-a807-ba672fc87d85`: App.UI drawing-object cache warm-up follow-up, completed; orchestrator committed, rebased, reverified, and integrated `0382937a1`.
- `019e8b77-a76a-7d00-b175-90ebb05259ba`: XLSX style-only save row insertion cursor tail, completed; orchestrator committed, verified, and integrated `d468bb5bd`.

Post-handoff-resume 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8b86-2829-71b3-ae1a-1e2661323639`: App.Host `RIBBON_FORCE_COMPACT` tail, completed with no patch; same-base candidate improved `RIBBON_DATA_REPEATED_COMPACT` timing (`10.68 ms -> 8.21 ms`) but allocation stayed flat at `150,704` bytes, while `RIBBON_FORCE_COMPACT_SKIP` stayed allocation-flat/noisy around `439.6 KB`; branch left clean with no commit.
- `019e8b86-6a75-7ea3-9b34-a5d9790a0e65`: Core.IO `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` / style-only metadata tail, completed with no patch; only narrow safe trial saved about `211 KB` on a `~131 MB` path, so it was reverted and the branch was left clean with no commit.

Goal-continuation 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8b99-f72a-7d31-81f1-53fadcf81bb4`: App.UI/App.Host benchmark census and narrow patch worker, completed. Rebased commit `b6e08488d` integrated to `origin/main`; split-pane scrollbar chrome allocation improved `16,000,048 -> 4,000,040` bytes.
- `019e8b9a-0be0-70b1-b9c8-60726a3ba50b`: Core.IO XLSX profiling tail worker, completed with no patch. Style-only save trial was negligible/flat and reverted; worktree left clean with no commit.

Post-restart continuation workers launched with full-access/no-permission instructions:

- `019e8bbe-e1e1-7f51-9316-bc063c95d00f`: App.Host satellite localization resource drift, completed; rebased commit `461a30e5a` integrated to `origin/main`.
- `019e8bbe-f615-7303-9419-36121e2f20c5`: App.Host non-local test drift worker, completed; rebased commits `38075f26c`, `b7386880d`, and `028cd235c` integrated to `origin/main`. Full Host tests had one transient keyboard-focus failure that passed on direct rerun.
- `019e8bbf-0a6b-79b1-9f0f-8754062c2052`: Core.Formula XNPV direct range streaming, completed; rebased commit `e00bd5d67` integrated to `origin/main`.
- `019e8bd4-d108-7eb2-a604-16e564c63798`: Core.Formula NPV direct range streaming, completed. The worker had merged into the primary local `main` with unrelated local commits, so the orchestrator isolated only patch commit `726b83e60` onto `codex/perf-formula-npv-range-tail-20260603-r1` and integrated clean commit `513eea00c` to `origin/main`.

Current post-handoff continuation workers launched with full-access/no-permission instructions:

- `019e8bf2-ff68-7322-8f52-42c5c3ee6c3b`: Core.Formula IRR direct range streaming, completed; rebased commit `8f3a72eb3` integrated to `origin/main`.
- `019e8bf2-c3b6-7213-8022-2d1b9c5fcf79`: Core.IO XLSX allocation tail, completed with no patch; branch left clean after one unsafe default-theme candidate and one allocation-flat package-copy pre-sizing candidate were reverted.

Local orchestrator slices after restart:

- `codex/perf-xlsx-metadata-save-tail-20260603-r1`: XLSX ignored-errors worksheet save tail, completed; commit `ca85fa850` integrated to `origin/main`.
- `codex/perf-app-ui-trace-render-tail-20260603-r1`: App.UI formula-trace visible arrow drawing cache, completed; rebased commit `b2c4e3bdf` integrated to `origin/main`.
- `codex/perf-app-ui-formula-layout-tail-20260603-r1`: App.UI formula-trace layout lookup allocation tail, completed; rebased commit `7613818b3` integrated to `origin/main`.
- `codex/perf-xlsx-datavalidation-save-tail-20260603-r1`: XLSX native data-validation save tail, completed; rebased commit `2a6c3066d` integrated to `origin/main`.
- `codex/perf-app-ui-render-tail-20260603-r4`: App.UI resize pre-selection layer cache tail, completed; commit `f9115462f` integrated to `origin/main`.
- `codex/perf-app-ui-drawing-objects-tail-20260603-r1`: App.UI drawing-object stable layer cache, completed; rebased commit `e5699197b` integrated to `origin/main`.
- `codex/perf-host-drag-ribbon-tail-20260603-r1`: App.Host drag/ribbon compact tail, completed; clean Host-only commit `66a60b9eb` integrated to `origin/main`.
- `codex/perf-xlsx-drawing-load-tail-20260603-r1`: XLSX drawing-picture load copy/traversal tail, completed; commit `30207e687` integrated to `origin/main`.
- `codex/perf-app-ui-drawing-followup-20260603-r1`: App.UI drawing-object cache warm-up follow-up, completed; rebased commit `0382937a1` integrated to `origin/main`.
- `codex/perf-xlsx-styleonly-save-tail-20260603-r1`: XLSX style-only save row insertion cursor tail, completed; commit `d468bb5bd` integrated to `origin/main`.
- `codex/perf-formula-eval-tail-20260603-r2`: Core.Commands formula-audit inconsistent-formula scan allocation tail, completed; commit `cf15c0392` integrated to `origin/main`.
- `codex/perf-formula-builtins-tail-20260603-r1`: Core.Calc conditional-format stacked style cache tail, completed; commit `78a40e1bd` integrated to `origin/main`. Baseline `CF_FORMULA_RULES` was `12,387,000` bytes; final focused samples were `5,643,480` bytes with full `FreeX.Core.Calc.Tests` passing `667/667`.
- `codex/perf-calc-dependency-tail-20260603-r1`: Core.Calc compact range dependency grouping tail, completed; commit `13ecd1000` integrated to `origin/main`. Baseline `REPEATED_IDENTICAL_FORMULA_REBUILD` was `15,454,928` bytes / `3,090` bytes per formula; final was `1,916,992` bytes / `383` bytes per formula with full `FreeX.Core.Calc.Tests` passing `667/667`.
- `codex/perf-ui-host-census-20260603-r2`: App.UI split-pane scrollbar chrome tail, completed by worker and rebased by orchestrator; commit `b6e08488d` integrated to `origin/main`. Final focused split-pane tests passed `66/66`, full `FreeX.App.UI.Tests` passed `570/570`, and `git diff --check` passed.
- `codex/perf-viewport-displaycell-tail-20260603-r1`: App.Host viewport DisplayCell allocation tail, completed; commit `19a4056b5` integrated to `origin/main`. Baseline `VIEWPORT_NO_COMMENTS_FAST_PATH` was `44,977,320` bytes; integrated-main sample was `35,766,736` bytes. Full `FreeX.App.UI.Tests` passed `570/570`, full `FreeX.Core.Model.Tests` passed `1893/1893`, full `FreeX.Core.Calc.Tests` passed `673/673`, and focused Host viewport benchmark passed.
- `codex/perf-nativejson-tail-20260603-r1`: Core.IO NativeJson loaded cell pre-sizing tail, completed; commit `f35ffa046` integrated to `origin/main`. `NATIVE_JSON_LOAD_DENSE` improved from `44,182,608` bytes to `37,782,672`, repeated custom styles load improved from `27,672,864` bytes to about `21,740,192`, full `FreeX.Core.IO.Tests` passed `1781/1781`, and the integrated-main focused load/source guard filter passed `3/3`.
- `codex/perf-formula-npv-range-tail-20260603-r1`: Core.Formula direct NPV range streaming clean integration branch, completed; commit `513eea00c` integrated to `origin/main`. `NPV(0.08,A1:A20000)` allocation improved from `1,324,912` bytes to `88` bytes, focused NPV/XNPV tests passed `11/11`, full `FreeX.Core.Formula.Tests` passed `2718/2718`, and the integrated-main focused NPV allocation/source filter passed `2/2`.
- `codex/perf-local-census-tail-20260603-r1`: App.Host native visual filter pivot lookup cache, completed; commit `20bf862c8` integrated to `origin/main`. `NATIVE_VISUAL_FILTERS_LARGE_PAIRED` improved from `58,544,840` bytes to `9,622,440`, focused `SlicerTimelinePlannerTests` passed `16/16`, full `FreeX.App.Host.Tests` passed `5796/5797` with `1` skipped, and `git diff --check` passed.

Local orchestrator exploratory slice after drawing tails:

- `codex/perf-core-commands-model-tail-20260603-r1`: Core.Commands/model probe for pivot/table/watch-window tails, completed locally with no integration; the pivot-refresh pre-sized filter-row candidate only saved about `2 KB`, so the patch was reverted and the worktree was left clean and uncommitted.
- `codex/perf-clipboard-dense-serde-tail-20260603-r1`: Clipboard dense serialize/deserialize probe, completed locally with no integration; benchmark samples were `CLIPBOARD_DESERIALIZE_DENSE` `7,686,400` bytes and `CLIPBOARD_SERIALIZE_DENSE` `2,766,720` bytes, both dominated by required returned strings/arrays, so no patch was carried.
- Additional low-allocation probes stayed clean: data validation list/prompt paths were under `48 KB`, accessibility low-contrast CF text was about `3.4 KB`, dense filters were about `10 KB`, subtotal row finder was about `9.8 KB`, and subtotal page-break planning was about `1.7 MB` but appears plan-output dominated.

## Resume Checklist

1. Run:
   - `git fetch origin`
   - `git status --short --branch`
   - `git rev-list --left-right --count main...origin/main`
2. Confirm `origin/main` is at or after `5778727fe`. The primary local `main` may still contain unrelated local commits; do not push, reset, or overwrite it as part of the performance thread unless its owning session has verified and handed it over.
3. Start the next wave with disjoint scopes:
   - XLSX IO style-only/ignored-error load-save tail only if a larger semantics-safe streaming or package-normalization path is found; narrow cell/row insertion cursor tails are integrated.
   - NativeJson load pre-sizing is integrated; future NativeJson work should start from save paths or deeper load-model redesign rather than repeating the dense-load capacity slice.
   - Recheck XLSX drawing-picture load only if a larger picture-storage redesign is acceptable; the narrow copy/traversal tail is already integrated.
   - Core.Commands dense row/column tails now need deeper model-level redesign; prefer other high-impact areas unless a narrow safe path is proven.
   - Core.Formula direct range streaming is integrated for XNPV, NPV, and IRR; future financial-function work should start with fresh allocation profiles instead of duplicating those paths.
   - App.UI drawing-object first-render/offscreen cache warm-up follow-up is integrated; anchor lookup remains allocation-flat and lower priority.
4. Merge verified slices back to `main` promptly and push after each coherent unit.

## Codex Restart Pause - 2026-06-03

The user asked to pause agents for a Codex restart. All active subagents were closed cleanly; do not wait on the old ids after restart. Spawn fresh workers only after rechecking the worktrees below.

- `019e8aee-d2ca-73d2-910a-69e2d3451dd1`: App.Host drag-status/ribbon compact tail, closed while running.
  - Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\perf-host-drag-ribbon-tail-20260603-r1`.
  - Branch: `codex/perf-host-drag-ribbon-tail-20260603-r1`.
  - Dirty files at pause: `src/FreeX.App.Host/MainWindow.RibbonAdaptive.cs`, `src/FreeX.App.Host/MainWindow.Selection.cs`, `src/FreeX.App.Host/RibbonAdaptiveLayoutEngine.cs`, `src/FreeX.App.Host/RibbonAdaptivePriorityPlanner.cs`, `src/FreeX.App.Host/RibbonAdaptiveStateApplicator.cs`, `tests/FreeX.App.Host.Tests/MainWindowMouseSelectionSourceTests.cs`.
  - Branch state at pause: ahead 1 and behind 20 relative to `origin/main`; review/rebase before using or integrating.
- `019e8afe-6ccd-7d91-a8b0-e0a04e906827`: XLSX dense mutated save regression, closed while running.
  - Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\perf-xlsx-dense-mutated-regression-20260603-r1`.
  - Branch: `codex/perf-xlsx-dense-mutated-regression-20260603-r1`.
  - Dirty files at pause: `src/FreeX.Core.IO/XlsxExcelCompatibilityNormalizer.cs`, `src/FreeX.Core.IO/XlsxFileAdapter.SavePostProcessing.cs`, `tests/FreeX.Core.IO.Tests/XlsxExcelCompatibilityNormalizerTests.cs`, `tests/FreeX.Core.IO.Tests/XlsxFileAdapterPerformanceTests.cs`.
  - Branch state at pause: behind 8 relative to `origin/main`; review/rebase before using or integrating.

Local orchestrator work completed after this restart:

- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\perf-app-ui-trace-render-tail-20260603-r1`.
- Branch: `codex/perf-app-ui-trace-render-tail-20260603-r1`.
- Commit: `b2c4e3bdf`.
- Integrated to `origin/main` by fast-forward push from the App.UI branch because the primary local `main` contained unrelated local refactor commits.
- Verification after rebasing onto current `origin/main`: focused formula trace benchmark/source guard passed `2/2`, full `FreeX.App.UI.Tests` passed `567/567`, and `git diff --check` passed.

Repository checkpoint at pause:

- `main` was clean and pushed to `origin/main` at `1a04e7c9d` before this pause note.
- This handoff branch was fast-forwarded to `origin/main` before writing the pause note.

Repository checkpoint after App.UI integration:

- `origin/main` was advanced to `b2c4e3bdf` with the App.UI performance slice.
- Primary local `main` was left untouched because it contains unrelated local refactor commits (`6fcef8192` side) and is not a reliable integration target for this performance slice until that owner syncs it.

Repository checkpoint after App.UI layout and XLSX integrations:

- `origin/main` was advanced to `7613818b3` with the App.UI layout allocation slice.
- `origin/main` was then advanced to `50bac941e` with the XLSX dense mutated save normalization slice.
- The primary local `main` was still left untouched for the same unrelated-local-refactor reason.

Repository checkpoint after native data-validation save integration:

- `origin/main` was advanced to `2a6c3066d` with the XLSX native data-validation post-processing save slice.
- The primary local `main` was still left untouched because it contains unrelated local refactor commits and staged corpus-runner refactor files owned by another session.

Repository checkpoint after App.UI resize cache integration:

- `origin/main` was advanced to `f9115462f` with the App.UI resize pre-selection render cache slice.
- The primary local `main` was still left untouched for the same unrelated-local-refactor reason.

Repository checkpoint after App.UI drawing-object, XLSX load, and Host tail integrations:

- `origin/main` was advanced to `e5699197b` with the App.UI drawing-object stable render layer cache.
- `origin/main` was advanced to `853119318` with the bounded XLSX ignored-error/style-only load stripping slice.
- `origin/main` was advanced to `66a60b9eb` with the clean Host drag/ribbon compact tail slice.
- The primary local `main` was left untouched; performance integration continued through verified linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after XLSX drawing load and App.UI drawing follow-up:

- `origin/main` was advanced to `30207e687` with the XLSX drawing-picture load copy/traversal slice.
- `origin/main` was advanced to `0382937a1` with the App.UI drawing-object cache warm-up follow-up.
- The primary local `main` was left untouched; it remains outside the performance integration path because unrelated sessions own its local divergence.

Repository checkpoint after XLSX style-only row insertion cursor integration:

- `origin/main` was advanced to `d468bb5bd` with the XLSX style-only save row insertion cursor slice.
- `codex/perf-core-commands-model-tail-20260603-r1` was left clean and uncommitted after a negligible pivot-refresh allocation probe was reverted.
- The primary local `main` was left untouched; performance integration continued through verified linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after Core.Commands formula audit integration:

- `origin/main` was advanced to `cf15c0392` with the formula-audit inconsistent-formula scan allocation slice.
- `codex/perf-host-ribbon-compact-tail-20260603-r1` and `codex/perf-xlsx-metadata-load-tail-20260603-r1` were active worker-owned branches at this checkpoint; review worker output before touching those scopes.
- The primary local `main` was left untouched; it remains outside the performance integration path because unrelated sessions own its local divergence.

Repository checkpoint after no-patch worker/probe results:

- `origin/main` was advanced to `001cd2cd5` with the previous handoff update; no additional performance code commits were integrated after `cf15c0392`.
- `codex/perf-host-ribbon-compact-tail-20260603-r1`, `codex/perf-xlsx-metadata-load-tail-20260603-r1`, and `codex/perf-clipboard-dense-serde-tail-20260603-r1` were left clean with no commits.
- Remaining high-allocation XLSX paths and Host compact tails need profiling or larger redesign before more edits are likely to be practical.

Repository checkpoint after Core.Calc CF stacked-style cache integration:

- `origin/main` was advanced to `78a40e1bd` with the Core.Calc conditional-format stacked style cache slice.
- The primary local `main` remained untouched and locally divergent; performance integration continued through linked worktrees and fast-forward pushes to `origin/main`.
- Fresh App.UI/App.Host and Core.IO agents were running from current `origin/main`; wait on their new IDs, not the old paused IDs, before claiming the next wave is exhausted.

Repository checkpoint after dependency graph and split-pane integrations:

- `origin/main` was advanced to `13ecd1000` with the Core.Calc repeated range dependency grouping slice.
- `origin/main` was then advanced to `b6e08488d` with the App.UI split-pane scrollbar chrome allocation slice.
- Core.IO worker `019e8b9a-0be0-70b1-b9c8-60726a3ba50b` completed with no patch; its clean no-patch result should be treated as current evidence for the XLSX style-only/load metadata tail.
- The primary local `main` remained untouched and locally divergent; continue using linked worktrees from `origin/main` for this performance thread.

Repository checkpoint after DisplayCell, localization, and XNPV integrations:

- `origin/main` was advanced to `19a4056b5` with the App.Host viewport DisplayCell allocation slice.
- `origin/main` was advanced to `461a30e5a` with the App.Host satellite localization resource drift fix.
- `origin/main` was advanced to `e00bd5d67` with the Core.Formula direct XNPV range streaming slice.
- Integrated-main targeted verification passed:
  - `BuiltInFunctionsPerformanceTests.Xnpv_LargeCashFlowRangeAvoidsDateListAllocationChurn` passed.
  - `GridViewSplitPaneLayoutTests.Benchmark_SplitPaneCellLayoutMaterialization_ReportsAllocations` passed with `63,379,240` materialized bytes and `4,563,240` visitor bytes.
  - Host localization/AppLanguageCatalog plus `PerformanceReviewMeasurementTests.Benchmark_ViewportNoCommentsFastPath` passed `132/132`, with viewport allocation `35,766,736` bytes.
- The App.Host non-local drift worker `019e8bbe-f615-7303-9419-36121e2f20c5` was still running at this checkpoint; it completed later and was integrated in the next checkpoint below.
- The primary local `main` remained untouched; performance integration continued through linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after NativeJson, Host drift, and NPV integrations:

- `origin/main` was advanced to `f35ffa046` with the Core.IO NativeJson loaded cell pre-sizing slice.
- `origin/main` was advanced to `028cd235c` with the App.Host non-local test drift cleanup.
- `origin/main` was advanced to `513eea00c` with the Core.Formula direct NPV range streaming slice.
- Integrated-main targeted verification passed:
  - Host non-local drift filter passed `3/3`.
  - NativeJson load/source guard filter passed `3/3`, with `NATIVE_JSON_LOAD_DENSE` at `37,782,672` bytes and repeated custom styles load at `21,740,192` bytes.
  - NPV allocation/source filter passed `2/2`.
- Broader verification before integration included full `FreeX.Core.IO.Tests` passing `1781/1781`, full `FreeX.Core.Formula.Tests` passing `2718/2718`, and full `FreeX.App.Host.Tests` passing `5794/5796` with `1` skipped plus one transient keyboard-focus failure that passed on direct rerun.
- The primary local `main` remained untouched and is currently clean but locally divergent: `main` is at `1efc6f70f` and `origin/main` is at `513eea00c`, with `main...origin/main` showing `16 0`. Continue using linked worktrees from `origin/main` for the performance thread and do not push or reset primary `main` wholesale.

Repository checkpoint after App.Host native visual filter, Core.IO no-patch, and IRR integrations:

- `origin/main` was advanced to `20bf862c8` with the App.Host native visual filter PivotTable lookup cache slice.
- Core.IO worker `019e8bf2-c3b6-7213-8022-2d1b9c5fcf79` completed with no patch; treat its focused benchmark samples and rejected candidates as current evidence for the remaining XLSX IO tail.
- `origin/main` was advanced to `8f3a72eb3` with the Core.Formula direct IRR range streaming slice.
- Verification passed:
  - Focused `SlicerTimelinePlannerTests` passed `16/16`; full `FreeX.App.Host.Tests` passed `5796/5797` with `1` skipped.
  - Focused IRR/financial Formula filter passed `101/101`; full `FreeX.Core.Formula.Tests` passed `2719/2719`.
  - `git diff --check HEAD~1..HEAD` passed for both integrated code slices.
- The primary local `main` remained untouched; continue using linked worktrees from `origin/main` for the performance thread and do not push or reset primary `main` wholesale.

Repository checkpoint after Host selection, App.UI formula-trace, and Pivot refresh integrations:

- `origin/main` was advanced to `8fff95db5` with `codex/perf-host-status-selection-tail-20260603-r1`.
  - Change: selection-driven FormulaBar updates now use the same skip-unchanged and temporary undo-disable pattern as the name box.
  - Metric: focused samples improved `NON_DRAG_SELECTION_TOOLBAR` from `11,842,696` bytes to about `11,680,992` bytes, and `ADDITIONAL_SELECTION_DRAG_TOOLBAR` from `3,861,912` bytes to about `3,822,864` bytes. `SELECTION_DRAG_STATUS` stayed essentially flat at about `2.746 MB`.
  - Verification: focused Host selection/source-guard set passed `30/30` after the final rebase; full `FreeX.App.Host.Tests` passed `5806/5807` with `1` skipped before the last unrelated non-Host rebase; `git diff --check HEAD~1..HEAD` passed.
- `origin/main` was advanced to `829960874` with `codex/app-ui-render-allocation-tail-20260603`.
  - Worker: `019e8c13-fa19-72d0-b251-a6979c5d3bf6`.
  - Change: formula-trace arrows render through a cached frozen layer drawing, invalidated by trace inputs/viewport changes and guarded by snapshot comparison for reused mutable arrow lists.
  - Metric: `GRID_RENDER_FORMULA_TRACE_LAYER_CACHE` was `271,328` bytes over 48 renders for 1,000 arrows on the rebased integration branch; direct visible-arrow draw remains about `5,306,536` bytes in the comparison benchmark.
  - Verification: formula-trace focused benchmarks/source guards passed `9/9`, full `FreeX.App.UI.Tests` passed `571/571`, and `git diff --check HEAD~1..HEAD` passed.
- `origin/main` was advanced to `5778727fe` with `codex/core-model-commands-tail-20260603`.
  - Worker: `019e8c14-5799-74d1-8b68-1d9b35183bba`.
  - Change: Pivot refresh reuses the already-retained row list when visible column keys exactly cover all populated column-key buckets after filters and sorts; filtered/no-data/partial groups stay on the old filtered-list path.
  - Metric: `PIVOT_REFRESH_COLUMN_VALUE_FILTER_SORT` allocation improved from `12,980,200` bytes to `9,171,904` bytes; final focused sample was `mean_ms=32.94`.
  - Verification: pivot refresh/command focused set passed `178/178`, full `FreeX.Core.Model.Tests` passed `1896/1896`, and `git diff --check HEAD~1..HEAD` passed.
- Primary local `main` remained outside the performance integration path; verified performance work continued through linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after Core.Calc viewport terminal metric probe integration:

- `origin/main` was advanced to `bf0d78573` with `codex/perf-core-calc-next-tail-20260603-r1`.
  - Change: default all-visible sheets now skip the discarded backward terminal row/column metric probe when the requested viewport start is clearly before the worksheet-end alignment zone. Custom row heights, custom column widths, hidden/filter/group-hidden rows, hidden/group-hidden columns, and near-terminal requests keep the existing terminal scan path.
  - Metric: `SPARSE_OCCUPIED_VIEWPORT` allocation improved from the earlier baseline `29,161,480` bytes over 60 iterations to the rebased final sample `25,112,952` bytes; final sample time was `83.04 ms`.
  - Verification: focused sparse viewport benchmark passed `1/1`; focused viewport layout/style/benchmark set passed `35/35`; full `FreeX.Core.Calc.Tests` passed `674/674`; full `FreeX.App.UI.Tests` passed `571/571`; `git diff --check HEAD~1..HEAD` passed.
- The temporary `RowMetric`/`ColMetric` value-record experiment was reverted before commit because App.UI relies on the existing nullable class-record semantics in metric lookups.
- Fresh Core.IO worker `019e8c3f-3a5b-7932-a247-79d1d64a9317` and Core.Formula worker `019e8c3f-4e98-7f13-840c-119bdeba7652` were started from the resumed orchestrator context; wait for their results before claiming the current wave is exhausted.

Repository checkpoint after Core.IO no-patch, Host census, Core.Model metadata, and Formula lookup integrations:

- Core.IO worker `019e8c3f-3a5b-7932-a247-79d1d64a9317` completed with no patch on `codex/core-io-xlsx-nativejson-tail-20260603`.
  - Evidence: focused Release Core.IO performance filter passed `50/50`; full Release `FreeX.Core.IO.Tests` passed `1784/1784`.
  - Clean samples included `XLSX_SAVE_LOADED_DENSE_MUTATED` about `157.76 MB`, `XLSX_SAVE_STYLE_ONLY` about `144.68 MB`, `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` about `131.59 MB`, `XLSX_LOAD_DENSE` about `73.85 MB`, and `NATIVE_JSON_LOAD_DENSE` about `37.79 MB`.
  - Rejected candidate: ignored-error save tuple gather saved only about `0.5 MB` and slowed the focused benchmark materially, so it was reverted.
- Local Host census branch `codex/perf-host-next-tail-20260603-r1` completed with no patch.
  - `PerformanceReviewMeasurementTests` passed `17/17`.
  - Current samples: `VIEWPORT_NO_COMMENTS_FAST_PATH` `34,924,200` bytes; `RIBBON_FORCE_COMPACT` `13,108,240` bytes; `RIBBON_RESIZE` `11,940,720` bytes; `RIBBON_COLLAPSED_BUTTON_FOOTPRINT` `6,144,040` bytes; `NON_DRAG_SELECTION_TOOLBAR` `11,673,152` bytes; selection drag toolbar/status remained around `3.82 MB`/`2.75 MB`.
  - Decision: no safe narrow Host patch found. Ribbon collapsed footprint already uses cached boxed dependency-property values and same-mode skip guards; remaining allocation appears tied to real mode-change `SetValue` work plus benchmark instrumentation.
- `origin/main` was advanced to `a72d52cd2` with `codex/perf-core-model-next-tail-20260603-r1`.
  - Change: `DeleteRowsCommand` now captures full row metadata undo state as compact key-value/value lists instead of dictionary/hashset snapshots, preserving full restore semantics while reducing snapshot overhead.
  - Metric: `DELETE_ROWS_METADATA_SHIFT` improved from `10,181,320` bytes to the rebased final sample `7,075,600` bytes; final focused mean was `84.38 ms`.
  - Verification: focused delete-row metadata/shift/guard set passed `12/12`; full `FreeX.Core.Model.Tests` passed `1898/1898`; `git diff --check HEAD~1..HEAD` passed.
- `origin/main` was advanced to `8e8833d56` with clean branch `codex/perf-formula-lookup-streaming-clean-20260603-r1`.
  - Worker source branch was `codex/perf-formula-builtins-fresh-tail-20260603-r1`; integration used a clean cherry-pick of performance commit `4628af8c3` because the worker branch also contained unrelated local merge/refactor history.
  - Change: direct range streaming fast paths for lookup-family formulas avoid flattening large worksheet ranges for `MATCH`, `XMATCH`, `XLOOKUP`, and `LOOKUP`.
  - Metric: baseline `MATCH(100000,A1:A100000,1/0)` was about `800,464` bytes; final focused allocations were `MATCH` `112` bytes, `XMATCH` `136-160` bytes, `XLOOKUP` `112-136` bytes, and `LOOKUP` `64` bytes.
  - Verification: focused Release lookup allocation tests passed `12/12`; full Release `FreeX.Core.Formula.Tests` passed `2726/2726`; `git diff --check HEAD~1..HEAD` passed.
- Hourly thread heartbeat automation `hourly-performance-orchestrator-status` was created so the user receives regular progress updates while the goal remains active.

Repository checkpoint after Core.Commands insert-row metadata snapshot integration:

- `origin/main` was advanced to `aed4e532e` with `codex/perf-core-commands-insert-metadata-tail-20260603-r1`.
  - Change: `InsertRowsCommand` now captures full row metadata undo state as compact key-value lists instead of dictionary snapshots, and uses the shared sorted-set capture helper for row page breaks. This mirrors the delete-row metadata undo optimization while preserving the existing full restore semantics for row heights, comments, threaded comments, hyperlinks, hyperlink metadata, and page breaks.
  - Metric: `INSERT_ROWS_METADATA_SHIFT` improved from the pre-change branch baseline `8,773,744` bytes / `124.23 ms` mean to the focused post-change sample `7,073,272` bytes / `61.13 ms` mean over three iterations.
  - Verification: focused insert-row metadata/guard/nearby insert set passed `22/22`; full `InsertDeleteRowsTests` passed `36/36`; full `FreeX.Core.Model.Tests` passed `1899/1899`; `git diff --check HEAD~1..HEAD` passed.
- The primary local `main` remained untouched and locally divergent; performance integration continued through linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after column metadata, Core.Calc sparse viewport, and App.UI drawing-object cache integrations:

- `origin/main` first moved through an unrelated parity orchestrator merge chain to `f84b21064`; the local performance branches were rebased over that before integration.
- `origin/main` was advanced to `e75d94f28` with `codex/perf-core-commands-column-metadata-tail-20260603-r1`.
  - Change: `InsertColumnsCommand` and `DeleteColumnsCommand` now capture full column metadata undo state as compact key-value/value lists instead of dictionary/hashset snapshots, and use the shared sorted-set capture helper for column page breaks. Dedicated dense column-metadata benchmarks were added to cover this path.
  - Metrics from a temporary benchmark-only baseline worktree versus the rebased patch: `INSERT_COLUMNS_METADATA_SHIFT` improved from `8,629,480` bytes to `6,929,008` bytes; `DELETE_COLUMNS_METADATA_SHIFT` improved from `9,334,000` bytes to `6,930,904` bytes.
  - Verification: focused column metadata benchmark/guard set passed `3/3`; `InsertDeleteColumnsTests|RowColumnShiftAddressStateTests` passed `33/33`; full `FreeX.Core.Model.Tests` passed `1902/1902`; `git diff --check HEAD~1..HEAD` passed.
- `origin/main` was advanced to `2e1379fc7` with `codex/core-calc-tail-worker-20260603`.
  - Worker: `019e8c60-2738-7001-b136-5aa6abc0d401`.
  - Change: sparse occupied viewport scans avoid preallocating a large `DisplayCell` list when the sheet used range cannot overlap the visible row/column metric bounds, and reject occupied cells outside visible metric ranges before binary metric membership lookup.
  - Metrics: worker baseline for `SPARSE_OCCUPIED_VIEWPORT` was `25,088,680` bytes / `671.40 ms` in the full benchmark class; final rebased full-class sample was `5,887,240` bytes / `243.79 ms` over 60 iterations. The worker's sparse-only final sample was `5,887,240` bytes / `70.18 ms`.
  - Verification: rebased Release `PerformanceBenchmarkTests` passed `18/18`; full Release `FreeX.Core.Calc.Tests` passed `674/674`; `git diff --check HEAD~1..HEAD` passed.
- `origin/main` was advanced to `d146a7136` with `codex/app-ui-render-layout-tail-20260603-r1`.
  - Worker: `019e8c60-1278-7771-b3f9-83e7790c99cd`.
  - Change: the drawing-object layer cache now keys selection state by visible selected-picture anchor only, instead of the whole active cell range, so shape/text-box-heavy object layers survive unrelated cell-selection repaints while picture selection adorners remain correct.
  - Metrics: focused worker baseline `GRID_RENDER_DRAWING_OBJECT_SELECTION_REPAINT` was `31,345,144` bytes / `141.23 ms` mean; worker final sample was `268,496` bytes / `69.14 ms` mean. The rebased integration sample was `287,256` bytes / `90.84 ms` mean.
  - Verification: rebased `GridViewPerformanceMeasurementTests` passed `18/18`; full `FreeX.App.UI.Tests` passed `572/572`; `git diff --check HEAD~1..HEAD` passed.
- The primary local `main` remained untouched and locally divergent; performance integration continued through linked worktrees and fast-forward pushes to `origin/main`.

Repository checkpoint after Core.Model census/no-patch probe:

- Local branch `codex/perf-core-model-census-tail-20260603-r1` was synced to `origin/main` at `dc1988e27` and left as a documentation/census branch.
- Full Core.Model benchmark-class census passed `38/38`.
- Current notable samples:
  - `WATCHWINDOW_GET_ENTRIES_MANY`: `6,050,280` bytes.
  - `CLIPBOARD_DESERIALIZE_DENSE`: `7,686,400` bytes.
  - `CLIPBOARD_SERIALIZE_DENSE`: `2,766,720` bytes.
  - `FLASHFILL_COLUMNS_EMAIL`: `9,630,560` bytes.
  - `FLASHFILL_FIRST_TOKENS`: `4,944,120` bytes.
  - `FLASHFILL_FILE_EXTENSIONS`: `900,920` bytes.
  - `SUBTOTAL_PLAN_MANY_GROUPS_PAGEBREAKS`: `1,712,032` bytes.
  - `PIVOT_REFRESH_COLUMN_VALUE_FILTER_SORT`: `9,171,904` bytes.
  - Dense row/column shifts stayed around the current integrated range: `12.42-12.59 MB`; metadata shifts stayed around `6.93-7.08 MB`.
- No source patch was carried from this census:
  - Flash Fill email/first-token/file-extension paths are mostly required output-string allocation; the email path already uses the lower-allocation token-pair helpers.
  - A Subtotal plan streaming trial increased allocation (`1,712,032 -> 1,854,232` bytes) because losing exact group-count/list pre-sizing outweighed the removed span list, so it was reverted.
  - Watch Window entries already use pooled sort buffers, value-type entries, and exact arrays; remaining allocation is dominated by the returned entry array and formatted value strings, so a safe narrow patch would require API or presentation-string caching changes.
- Current active workers launched with full-access/no-permission instructions:
  - `019e8c79-53c6-7511-947b-dddd55ba7839`: Core.Formula evaluator/built-in function tail, scope `src/FreeX.Core.Formula/**` and `tests/FreeX.Core.Formula.Tests/**`.
  - `019e8c79-86bc-7e42-8654-b1f3a0d6eaab`: App.Host performance-review tail, scope `src/FreeX.App.Host/**` and `tests/FreeX.App.Host.Tests/**`.
  - `019e8c7f-ed62-7f70-be6b-fd09149881aa`: Core.IO allocation tail, scope `src/FreeX.Core.IO/**` and `tests/FreeX.Core.IO.Tests/**`.
