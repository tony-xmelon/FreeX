# FreeX Performance Orchestrator Handoff - 2026-06-02

## Active Goal

Keep improving performance across the FreeX app end to end: use subagents to review bottlenecks, measure targeted baselines, implement prioritized optimizations, verify with tests and benchmarks, integrate cleanly, and continue until the practical improvement backlog is exhausted.

This goal is not complete. This file records the current clean checkpoint.

## Operating Rules

- Repository: `E:\Users\anton\Documents\Claude\Freexcel`.
- Latest upstream checkpoint before this handoff update: `0382937a1`.
- `codex/performance-orchestrator-resume-20260602` was rebased onto `origin/main` at `0382937a1` before this handoff update.
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

## Other Main Integrations During This Wave

Other sessions also advanced `main` with verified non-performance/refactor/parity work while this orchestrator was active, including sheet-tab chrome, App.UI rect hit testing, model command test-context cleanup, drawing arrange parity, IO native attribute helper reuse, advanced filter copy planning, command-bus undo entry refactor, FormulaEvaluator partial extraction, NativeJson cell DTO partial extraction, Host dispatcher test-pump sharing, disabled nonpersisted Options toggles, QAT validation, Flash Fill parity coverage clarification, and parity handoff updates.

## Remaining Backlog

The obvious high-impact backlog is reduced but not exhausted.

1. XLSX IO:
   - `XLSX_SAVE_LOADED_DENSE_MUTATED` was re-stabilized from about `244.9 MB` to `150.1-157.5 MB` by skipping irrelevant worksheet compatibility scans; further wins likely require deeper package normalization redesign.
   - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` improved again and now allocates around `131.5 MB` in full Core.IO samples; it is still one of the largest open allocation pools.
   - `XLSX_SAVE_STYLE_ONLY` improved to about `143.1 MB` but remains a high-allocation save path because ClosedXML/style seeding and package XML rewriting still dominate.
   - `XLSX_SAVE_IGNORED_ERRORS` improved to about `81.46 MB`; `XLSX_SAVE_DATA_VALIDATION_NATIVE_METADATA` improved from about `80.5 MB` to about `18.6 MB`.
   - `XLSX_LOAD_DRAWING_PICTURES` now has a current baseline and a small copy/traversal win (`23.6 MB` to about `22.8 MB`); further cuts likely require a larger picture-storage or image-retention redesign.
   - Unchanged loaded workbook fast-copy remains healthy: `XLSX_SAVE_LOADED_DENSE` around `554,248` bytes in the full IO run.
   - Further IO cuts likely require deeper metadata load/save redesign or more streaming XML writers.
2. App.Host toolbar/ribbon:
   - `NON_DRAG_SELECTION_TOOLBAR` is down to about `12.2 MB`; current guardrails show zero QAT probes and zero toolbar writes.
   - `RIBBON_FORCE_COMPACT` is about `13.4 MB` in the latest focused run and remains a visible tail.
   - `SELECTION_DRAG_STATUS` and `ADDITIONAL_SELECTION_DRAG_TOOLBAR` are about `4.6 MB` and `5.7 MB` respectively in the latest focused run; treat them as lower priority unless a new benchmark regresses.
   - The restarted Host worker branch is integrated; future Host work should start from current `origin/main` and avoid overlapping stale worktrees.
3. Core.Commands:
   - Dense insert undo and dense row/column shift allocations are improved; dense row/column shift now allocates about `12.4-12.6 MB`, so further improvement probably needs model-level cell move primitives or a deeper snapshot/restore redesign.
   - Dense filter/table operations now report low allocations but still have time-cost tails worth rechecking if command work continues.
   - Advanced Filter copy-unique dense rows is improved to about `8.27 MB`; remaining cost is lower priority than the open Host/UI/Formula/XLSX tails.
   - Data-validation range list items are now low allocation; Go To Special data-validation lookup was checked and left unchanged because it is already low.
4. Formula/Core.Calc:
   - Repeated identical formula dependency rebuild improved again; latest isolated worker sample was `15.48 MB`, while warm focused runs can be much lower because dependency-plan caches are hot.
   - Formula parser/evaluator tail remains a candidate only if a semantics-safe path can be proven.
5. App.UI render:
   - Text-heavy and wrapped render allocations are now down to tens of KB in recent samples.
   - Selection-only repaint improved from about `1.04 MB` to about `0.40-0.43 MB`; render timings remain noisy.
   - Formula-trace visible arrow drawing improved from about `36.9 MB` to `5.3 MB`.
   - Formula-trace layout visitor improved from about `1.19 MB` to about `5 KB`; timing remains noisy and should be watched if more render work touches that planner.
   - Chart dimension resize repaint improved from about `14.3 MB` to about `46-52 KB` by reusing the light pre-selection render layer cache.
   - Drawing-object render allocation improved from about `5.2 MB` to `46-53 KB`; offscreen drawing-object repaint is now around `26 KB` on the latest sample, and anchor lookup remains allocation-flat at about `3 KB`.

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

## Resume Checklist

1. Run:
   - `git fetch origin`
   - `git status --short --branch`
   - `git rev-list --left-right --count main...origin/main`
2. Confirm `origin/main` is at or after `0382937a1`. The primary local `main` may still contain unrelated local refactor commits; do not push or overwrite them as part of the performance thread unless their owning session has verified them.
3. Start the next wave with disjoint scopes:
   - XLSX IO style-only/ignored-error load-save tail if a semantics-safe streaming or bounded-strip path is found.
   - Recheck XLSX drawing-picture load only if a larger picture-storage redesign is acceptable; the narrow copy/traversal tail is already integrated.
   - Core.Commands dense row/column tails now need deeper model-level redesign; prefer other high-impact areas unless a narrow safe path is proven.
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
