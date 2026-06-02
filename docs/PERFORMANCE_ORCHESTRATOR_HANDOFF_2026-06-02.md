# FreeX Performance Orchestrator Handoff - 2026-06-02

## Active Goal

Keep improving performance across the FreeX app end to end: use subagents to review bottlenecks, measure targeted baselines, implement prioritized optimizations, verify with tests and benchmarks, integrate cleanly, and continue until the practical improvement backlog is exhausted.

This goal is not complete. This file records the current clean checkpoint.

## Operating Rules

- Repository: `E:\Users\anton\Documents\Claude\Freexcel`.
- Current synced head after this wave: `52032b09f`.
- `main` and `origin/main` were aligned after push at `52032b09f`.
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

## Other Main Integrations During This Wave

Other sessions also advanced `main` with verified non-performance/refactor/parity work while this orchestrator was active, including sheet-tab chrome, App.UI rect hit testing, model command test-context cleanup, drawing arrange parity, IO native attribute helper reuse, advanced filter copy planning, command-bus undo entry refactor, FormulaEvaluator partial extraction, NativeJson cell DTO partial extraction, Host dispatcher test-pump sharing, disabled nonpersisted Options toggles, and parity handoff updates.

## Remaining Backlog

The obvious high-impact backlog is reduced but not exhausted.

1. XLSX IO:
   - `XLSX_SAVE_LOADED_DENSE_MUTATED` is improved but still allocates around `194.9 MB`.
   - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` is improved but still allocates around `156.7 MB`.
   - Unchanged loaded workbook fast-copy remains healthy: `XLSX_SAVE_LOADED_DENSE` around `554,248` bytes in the full IO run.
2. App.Host toolbar/ribbon:
   - `NON_DRAG_SELECTION_TOOLBAR` remains around `13.1 MB`; current guardrails show zero QAT probes and zero toolbar writes.
   - `RIBBON_FORCE_COMPACT` remains around `14.6-14.7 MB`.
   - `SELECTION_DRAG_STATUS` and `ADDITIONAL_SELECTION_DRAG_TOOLBAR` remain around `22-23 MB` in recent samples.
3. Core.Commands:
   - Dense insert undo allocation is improved; dense filter/table operations now report low allocations but still have time-cost tails worth rechecking if command work continues.
   - Advanced Filter copy-unique dense rows is improved to about `8.27 MB`; remaining cost is lower priority than the open Host/UI/Formula/XLSX tails.
4. Formula/Core.Calc:
   - Repeated identical formula dependency rebuild improved again but still allocates about `22.4 MB`.
   - Formula parser/evaluator tail remains a candidate if further dependency-plan or graph-storage reuse can be proven semantics-safe.
5. App.UI render:
   - Quick-analysis no-op data-bar rendering is improved; render benchmarks remain noisy, so rerun a stable measurement set before declaring App.UI exhausted.

## Subagent Status

Completed and integrated performance agents from the resumed wave:

- `019e8a04-9993-7663-930f-ea1426223ebc`: Core.Commands dense cell shift, merged/pushed.
- `019e8a04-dae0-7613-ac67-604083e3be8d`: Formula parse-cache tail, merged/pushed.
- `019e8a04-59aa-7732-9c5d-368ae7fa311f`: App.Host ribbon resize, merged/pushed.
- `019e8a1a-9d81-70f3-933f-38956185f1dc`: XLSX dense loaded mutated save, merged/pushed.

Current 2026-06-03 workers launched with full-access/no-permission instructions:

- `019e8a34-a5dd-7091-91a2-477c1551093f`: App.Host toolbar/status tail, running.
- `019e8a34-ba23-7b12-907a-d170358abd6f`: App.UI render benchmark/hot path, completed and pushed.
- `019e8a34-cf08-72c1-a27b-c921e95e05ed`: Formula/Core.Calc parse/eval tail, completed and pushed.
- `019e8a34-e815-7f12-9bd2-c548baf41c06`: XLSX IO dense-save/load metadata tail, running.

Close completed agents when this thread finishes or when no more result inspection is needed.

## Resume Checklist

1. Run:
   - `git fetch origin`
   - `git status --short --branch`
   - `git rev-list --left-right --count main...origin/main`
2. Confirm `main` and `origin/main` are aligned at or after `52032b09f`.
3. Start the next wave with disjoint scopes:
   - App.Host non-drag toolbar / drag-status allocation tail.
   - App.UI render benchmark stabilization and next hot path.
   - Formula/Core.Calc parse/eval tail beyond shared parse cache.
   - XLSX IO deeper dense-save/load metadata follow-up if a semantics-safe path is found.
4. Merge verified slices back to `main` promptly and push after each coherent unit.
