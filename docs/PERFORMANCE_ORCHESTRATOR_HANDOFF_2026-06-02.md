# FreeX Performance Orchestrator Handoff - 2026-06-02

## Active Goal

Keep improving performance across the FreeX app end to end: use subagents to review bottlenecks, measure targeted baselines, implement prioritized optimizations, verify with tests and benchmarks, integrate cleanly, and continue until the practical improvement backlog is exhausted.

This goal is not complete. This handoff records a clean sync point for a new thread.

## Operating Rules

- Repository: `E:\Users\anton\Documents\Claude\FreeX`.
- Current synced head after this lane: `f97da8a055cdca583bc8fc4dc6cae54527cecb76`.
- Follow `AGENTS.md`: isolated worktrees/branches for implementation, `main` as integration only, sync before work, verify before merge, push verified integrations frequently.
- User explicitly requested no permission prompts and no escalation requests.
- Treat unrelated dirty or untracked files as owned by other sessions unless explicitly proven otherwise.

## Integrated Performance Work

All items below were merged into `main` and pushed to `origin/main`.

### Core.Calc Conditional Formatting

- Branch: `codex/core-calc-cf-style-cache-perf-20260602-r1`.
- Main merge: `6aac2e55a`.
- Change: cached color-scale fill-only `CellStyle` instances in the viewport conditional-format evaluation context.
- Metric: `CF_FORMULA_THRESHOLDS` allocation improved from about `16,396,784` bytes to `7,029,240` bytes.
- Verification: conditional-format focused tests and full `FreeX.Core.Calc.Tests` passed on branch; post-merge focused run passed.

### App.UI Split-Pane Layout

- Branch: `codex/app-ui-split-pane-layout-perf-20260602-c`.
- Commit: `cb24bf195`.
- Change: replaced tuple `HashSet` overflow occupancy with per-row occupied column spans.
- Metrics:
  - Visitor path allocation improved from about `21,680,040` bytes to `4,505,640` bytes.
  - Materialized path allocation improved from about `87,026,416` bytes to about `69,882,184` bytes.
- Verification: split-pane/render focused App.UI tests passed.

### App.UI Grid Text/Render

- Branch: `codex/app-ui-grid-text-render-hotpaths-worker-b-20260602`.
- Main merge: `13e3933af`.
- Change: per-render default text-layout style eligibility cache and wrapped-text clip avoidance when laid-out bounds fit.
- Branch metrics:
  - Wrapped text mean about `155.10 ms -> 147.93 ms`.
  - Default styled text mean about `100.71 ms -> 85.32 ms`.
  - Quick-analysis data bars mean about `129.02 ms -> 81.92 ms`.
- Verification: App.UI render/perf focused tests passed.

### Core.Commands Pivot Refresh

- Branch: `codex/core-commands-service-allocation-perf-worker-d-20260602`.
- Main merge: `3492307aa`.
- Change: array-backed source rows, selected item lookup avoidance, label filter lookup improvements, single-column pivot key bucketing.
- Metric: `PIVOT_REFRESH_COLUMN_VALUE_FILTER_SORT` allocation improved from about `26,221,144` bytes to `12,859,096` bytes; mean around `52.16 ms` post-merge sample.
- Verification: `PivotTableRefreshServiceTests` passed.

### Core.Formula Lexer Allocation

- Branch: `codex/core-formula-function-cache-perf-20260602-r1`.
- Main merge: `0a1a7057b`.
- Change: span-based identifier classification and structured-reference selector fast path to avoid duplicate identifier string allocation.
- Metric: parser repeated identifier allocation improved from about `95,040,064` bytes to `91,520,064` bytes.
- Verification: `FormulaEvaluatorPerformanceTests|LexerTests` passed `90/90` on merged `main`.

### Core.IO XLSX Style-Only Save

- Branch: `codex/xlsx-style-postprocessing-perf-20260602-a`.
- Commit: `81e2a2f6c`.
- Change: seed one real style-only cell per style through ClosedXML, then expand all style-only cells in worksheet XML post-processing.
- Metrics from Worker A:
  - `XLSX_SAVE_STYLE_ONLY` baseline mean `924.41 ms`, p95 `1018.56 ms`, allocated `231,657,400` bytes.
  - Final branch repeat mean `680.49 ms`, p95 `868.27 ms`, allocated `149,719,448` bytes.
  - About `26%` faster mean and `35%` lower allocation on the final repeat; one merged-main sample was noisier at `930.19 ms` but allocation remained lower at `162,721,424` bytes.
- Verification:
  - Worker full `FreeX.Core.IO.Tests` passed `1742/1742` after one test-host crash rerun.
  - Merged-main focused `XlsxFileAdapterFormatTests|XlsxFileAdapterPerformanceTests` passed `43/43`.

### App.Host Ribbon Footprint

- Branch: `codex/app-host-worker-e-perf-20260602`.
- Main merge: `f97da8a05`.
- Change: cached collapsed-group footprint plans and boxed dependency-property values; idempotent comment tooltip writes for selection/hover refresh.
- Metrics:
  - `RIBBON_COLLAPSED_BUTTON_FOOTPRINT` allocation improved from `18,181,288` bytes to `6,144,040` bytes.
  - `NON_DRAG_SELECTION_TOOLBAR` allocation stayed about `15.3 MB`.
  - `SELECTION_DRAG_STATUS` allocation slightly improved in worker, but merged sample was noisy around `21.13 MB`.
  - `RIBBON_FORCE_COMPACT_SKIP` stayed at `384,040` bytes.
- Verification:
  - Focused Host tests passed `12/12`.
  - `PerformanceReviewMeasurementTests` passed `17/17` on merged `main`.

## Additional Verified Main Queue During Handoff

Other non-performance slices landed while this thread was coordinating integration. They were verified before push but are not the core performance goal:

- Backstage PDF/XPS readiness, accessibility object checks, selection pane keyboard reorder shortcuts.
- Chart/dialog and sheet-tab coverage commits.
- SpreadsheetML invalid named-range coverage.

Focused verifications completed during this handoff included:

- `FreeX.App.Host.Tests`: Backstage/export/local account/selection pane focused set `50/50`.
- `FreeX.Core.Model.Tests`: `AccessibilityCheckerServiceTests` `75/75`.
- `FreeX.App.UI.Tests`: render/drawing focused set `101/101`.
- `FreeX.Core.IO.Tests`: `SpreadsheetXmlFileAdapterTests` `140/140`.
- `FreeX.App.Host.Tests`: chart/pivot/sheet-tab focused set `191/191`.

## Remaining Backlog

The obvious high-impact backlog is reduced but not exhausted.

Priority areas for the next thread:

1. XLSX IO follow-up:
   - `XLSX_SAVE_LOADED_DENSE_MUTATED` still allocates around `226 MB` in a merged-main sample.
   - `XLSX_LOAD_IGNORED_ERROR_STYLE_ONLY_METADATA` still allocates around `165 MB`.
   - Recheck after Worker A because style-only save improved, but dense loaded mutate/load metadata still look hot.
2. App.Host toolbar/ribbon:
   - `NON_DRAG_SELECTION_TOOLBAR` still around `15.3 MB`.
   - `RIBBON_RESIZE` merged sample around `23.8 MB`.
   - Worker E fixed collapsed-button footprint; next focus should be toolbar state and resize churn.
3. Core.Commands dense table/filter/insert cells:
   - Prior backlog included structured table dense filter, insert cells shift-right dense, and average/filter dense operations.
4. Formula parser/evaluator:
   - Lexer allocation is improved, but repeated formula parsing still allocates around `91.5 MB`; look for AST/function-token reuse beyond identifier scanning.
5. App.UI render:
   - Grid text/render and split-pane are improved, but quick-analysis/wrapped text benchmarks remain noisy; rerun a stable measurement set before declaring exhausted.

## Subagent Status

Completed performance agents from this wave:

- `019e877e-6ecb-7830-94c6-807d81323955`: Worker A, XLSX style-only save, merged/pushed.
- `019e877e-a510-7680-9719-c685477106b5`: Worker B, App.UI grid text/render, merged/pushed.
- `019e877e-cee1-7773-b919-811fbb5692f8`: Worker C, App.UI split-pane, merged/pushed.
- `019e877f-076f-76c1-9864-b87f0cb2eb2f`: Worker D, pivot refresh, merged/pushed.
- `019e877f-2e5e-71a2-8089-48d1480640ea`: Worker E, Host ribbon footprint, merged/pushed.
- `019e877f-5429-7ba2-af58-64e191af5377`: Worker F, backlog explorer, report consumed.

Close these agents when this thread finishes.

## Next Thread Checklist

1. Run:
   - `git fetch origin`
   - `git status --short --branch`
   - `git rev-list --left-right --count main...origin/main`
2. Confirm `main` and `origin/main` are aligned at or after `f97da8a055cdca583bc8fc4dc6cae54527cecb76`.
3. Close any still-open performance subagents listed above.
4. Start the next performance wave with isolated worktrees and disjoint scopes:
   - XLSX dense loaded mutate/load metadata.
   - Host toolbar state and ribbon resize churn.
   - Core.Commands dense table/filter/insert-cell operations.
   - Formula parser/evaluator allocation tail.
5. Merge verified slices back to `main` promptly and push after each coherent unit.
