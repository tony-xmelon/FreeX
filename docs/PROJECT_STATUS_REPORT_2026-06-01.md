# FreeX Project Status Report

Generated: 2026-06-01
Observed at: 2026-06-01T23:52:30+03:00
Report scope: current consolidated documentation/status snapshot after the June 1 evening integrations
Mainline observed: branch-neutral `origin/main` snapshot; worker-specific branch and worktree names are intentionally omitted from this status report

## Executive Summary

FreeX remains in late-stage parity hardening. The broad app surface is functional and documented: formula coverage is **487/487 in-scope functions**, command and menu coverage remain **100% for in-scope rows**, shortcut parity remains **100% (87/87)**, and XLSX work is now focused on fidelity proof, package-preserving save validation, and real-world workbook breadth rather than first-pass support. The XLSX corpus currently has 176 workbook manifest rows, including data-validation semantic XML proof, live web-query warning/retention coverage through connection metadata, and the user-approved Partner Dashboard local-private Excel save/reopen regression row. The June 1 chart interop pass now has a repeatable comparison harness with a complete 28/28 chart openability/export and visual-gate pass, including chartEx coverage for Pareto, waterfall, box-and-whisker, treemap, sunburst, histogram, and funnel; the run reports 0 known-gap chart allowances and 28/28 byte-identical Excel-native/FreeX-round-trip packages.

Overall completion remains **95%** in [release/progress.json](../release/progress.json), which keeps tester builds in the `v0.8.<run>` stream. Overall completion estimate is now **95%**. The main remaining work is package-preserving XLSX validation, broader corpus proof, release signing/trust and human accessibility validation, localization review/pseudo-localization/package metadata, keytip/visual polish, and measured performance hardening.

The project history metrics report now covers Git and provider-log activity from 2026-05-12 through 2026-05-31 inclusive. Through May 31, the daily churn table records **11,780 commits**, **14,464 changed-file/day entries**, **+1,429,132 / -922,973 LoC**, and local provider logs attribute **116,943,364,224 observed raw tokens** across OpenAI/Codex and Anthropic/Claude rows.

## Current Repository Metrics

| Metric | Count |
| --- | ---: |
| Tracked files | 2,507 |
| C# source files under `src/` | 1,105 |
| C# test files under `tests/` | 681 |
| Markdown docs under `docs/` | 249 |
| Current C# source LOC | 181,042 |
| Current C# test LOC | 182,955 |
| Current XAML LOC | 7,888 |
| XLSX corpus manifest rows | 176 |

## Current Repository State

| Item | Status |
| --- | --- |
| Mainline | Local `main` was clean at `063e23ccf` (`Merge ribbon measured correction performance`) |
| Completion tracking | [release/progress.json](../release/progress.json) remains at `overallCompletion: 95` |
| History metrics | [PROJECT_BUILD_HISTORY_METRICS.md](PROJECT_BUILD_HISTORY_METRICS.md) is refreshed through 2026-05-31 inclusive |
| Branch posture | Parallel work is active again: observed 122 registered worktrees, 129 local branches, 13 branches not yet merged to `main`, and 2 dirty worker-owned worktrees. These were left untouched. |
| Release posture | Tester-release automation can publish `.exe` and MSIX assets; signing/trust and public-preview evidence remain release-gate work |
| Documentation posture | The docs index, backlog, next-phase plan, localization plan, fidelity report, and metrics report now point at the current app state |

## Current Parity Snapshot

| Surface | Status |
| --- | --- |
| Formula engine | 487/487 in-scope functions implemented and tested; current work is parity proof and targeted edge-case hardening. |
| Command surface | 100% of in-scope command-surface rows covered; deferred/excluded rows are documented rather than counted as missing. |
| Menu/toolbar parity | 100% of in-scope menu/toolbar rows covered, with deferred/excluded rows tracked separately. |
| Keyboard shortcuts | **100% parity** (87/87), **0% partial** (0/87), **0 missing**. |
| XLSX fidelity | 71 documented in-scope feature categories with at least partial support; corpus remains at 176 workbook manifest rows with generated/public/regression/local-private evidence and known-gap warning coverage. Chart interop now has a 28/28 latest-complete pass for Excel openability/export and visual gates. |
| UI/dialog parity | Dialog message routing, access keys, default/cancel semantics, UIA metadata, keytips, ribbon layout, titlebar/QAT states, and sheet-tab chrome have broad automated coverage and continuing visual polish. |
| Localization | `UiText`, `LocExtension`, neutral resources, 43 satellite resource cultures, startup UI culture, WPF language metadata, localization guard tests, current-culture direct numeric entry, delimited numeric import, and Text to Columns numeric parsing are present. |
| Release readiness | User guide, troubleshooting, legal/privacy notices, release checklist, diagnostics, crash analytics, and tester-release workflow docs are present; public-preview promotion still needs live validation evidence. |

Phase 7D: Deeper color-scale XLSX edge semantics as new gaps are found.

## Recent Highlights Since The May 29 Snapshot

1. **Formula catalog status corrected**
   - Current docs now use the 487/487 in-scope function catalog from `FUNCTION_PARITY.md` and `FormulaParityCatalogTests`.

2. **Localization resource breadth landed**
   - Host UI text now has a resource path through `UiText` and `LocExtension`, with neutral resources plus 43 complete satellite resource cultures. Guard tests cover resource usage, language catalog discovery, key parity, placeholders, access keys, blank values, full satellite assemblies without parent fallback, and automation metadata; Bulgarian keeps an extra high-value terminology smoke suite.

3. **Ribbon, tab, and titlebar polish continued**
   - Recent integrated work includes compact split-button segment fixes, standalone ribbon command promotion at wider widths, sheet add/options icon polish, sheet-tab hover alignment, and improved disabled/hover titlebar icon treatments.

4. **Object/chart/data parity advanced**
   - Object resize/rotation handles, chart data-label content toggles, custom-list primary sort application, and keytip placement improvements are now reflected in the backlog as completed or narrowed work.

5. **XLSX metadata and performance slices continued into June 1**
   - The current mainline includes batch XLSX workbook metadata save work, quick-analysis preview write avoidance, sparkline layout streaming, and selection-refresh/rendering performance updates.

6. **Resize-preview blocker stale-cleared**
   - The previously listed `MainWindowMouseResizeTests` resize-preview blocker is no longer open: targeted Release verification on `main` at `3ddbbebb3` passed 8/8.

7. **History metrics extended through May 31**
   - May 31 added 246 integrated commits, 258 changed files, +30,256 / -2,952 LoC, and 7,845,703,301 observed raw provider tokens.

8. **Second-wave non-chart parity slices landed**
   - Worksheet primary view-mode persistence, live web-query warning detection, data-validation XML semantic proof, AutoFilter color-menu availability, current-culture delimited import/Text to Columns numeric parsing, and grouped-sheet Selection Pane object propagation are integrated locally and reflected in the parity/backlog docs.

9. **Chart interop and chartEx parity moved from blocker to evidence-driven hardening**
   - `tools/FreeX.ChartInteropCompare` now separates openability/export failures from visual mismatches and records chart comparison evidence. The latest complete run passed 28/28 chart cases for FreeX-rendered PNGs, FreeX-authored XLSX opened/exported by Excel, Excel-authored XLSX opened/exported by Excel, and Excel-authored XLSX loaded/saved by FreeX then reopened/exported by Excel.
   - June 1 chart fixes include Excel-openable Pareto chartEx axis metadata, box-and-whisker chartEx metadata, waterfall chartEx XML and Set as Total UI, scatter default connector suppression, classic default layout polish, 3-D depth axis ids, chartEx sidecars using native style `id="201"`/color style `id="10"`, best-effort chart contact-sheet generation, and a byte-identical package guard that removes the former `ThreeDColumn` known-gap allowance while keeping repeated Excel PNG export variance out of package/openability regression reporting.

10. **Workbook culture, non-finite value, and window parity tightened**
   - Current-culture numeric entry/import/Text to Columns paths were hardened, non-finite values are kept as text across delimited, native JSON, SpreadsheetML, XLSX, and sparkline layout paths, and live Arrange All/Side by Side/window layout behavior is now documented as implemented.

11. **Performance slices are landing continuously**
   - Recent mainline work includes dependency graph range compaction, Core.IO style-only stripper optimization, row/column shift capture, CSV save row-bucket sizing, sparse formula-audit scans, structured-table filtering, conditional icon appearance caching, watch-window sorting, scenario summary sharing, subtotal planning, spellcheck no-issue allocation reduction, and drawing/header/selection redraw guards.

## Active Workstream Picture

Parallel implementation remains expected. Mainline is the integration target, while worker-owned branches and worktrees may continue carrying active, dirty, or paused work. Before merging any implementation slice, keep syncing from `main`, verify relevant build/tests in the owning worktree, and leave unrelated worker-owned changes untouched.

Observed worker state at 2026-06-01T20:40+03:00: 122 registered worktrees and 129 local branches. The dirty worktrees belonged to active chart parity lanes; this report does not treat those as mainline dirt.

## Remaining Outstanding Work

See [OUTSTANDING_BUILD.md](OUTSTANDING_BUILD.md) for the source-of-truth backlog. The highest-priority open items are:

1. **XLSX corpus and fidelity proof**
   - Expand the 176-row corpus baseline with broader public/private/regression workbook coverage and per-feature pass/fail publication.
2. **Package-preserving XLSX save path**
   - Desktop Excel open/save/reopen checks remain release-critical validation.
3. **Release documentation and packaging**
   - Signing, installer trust validation, and live accessibility validation remain release-gate work.
4. **Keytip overlay placement**
   - Continue visual-placement polish beyond the current automated key routing and UIA coverage; collapsed ribbon overflow group badges now use centered placement instead of the command bottom-edge anchor.
5. **XLSX warning coverage as new gaps are found**
   - Keep unsupported-feature detection aligned with newly discovered OOXML package parts.

Current planning, parity, and release-readiness sources: [OUTSTANDING_BUILD.md](OUTSTANDING_BUILD.md), [NEXT_PHASES_PLAN.md](NEXT_PHASES_PLAN.md), [COMMAND_SURFACE_PARITY.md](COMMAND_SURFACE_PARITY.md), [MENU_TOOLBAR_PARITY.md](MENU_TOOLBAR_PARITY.md), [SHORTCUT_PARITY_MATRIX.md](SHORTCUT_PARITY_MATRIX.md), [FUNCTION_PARITY.md](FUNCTION_PARITY.md), [FIDELITY_CONTRACT.md](FIDELITY_CONTRACT.md), [XLSX_CORPUS_REPORT.md](XLSX_CORPUS_REPORT.md), [LOCALIZATION_PLAN.md](LOCALIZATION_PLAN.md), [TEST_DISTRIBUTION_PLAN.md](TEST_DISTRIBUTION_PLAN.md), and [PERF_BASELINE.md](PERF_BASELINE.md).
