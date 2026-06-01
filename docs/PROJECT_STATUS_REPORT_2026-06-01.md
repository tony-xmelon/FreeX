# FreeX Project Status Report

Generated: 2026-06-01
Observed at: 2026-06-01T05:17:57+03:00
Report scope: current consolidated documentation/status snapshot after June 1 integrations
Mainline observed: branch-neutral `origin/main` snapshot; local integration main observed at `357ef17799`

## Executive Summary

FreeX remains in late-stage parity hardening. The broad app surface is functional and documented: formula coverage is **487/487 in-scope functions**, command and menu coverage remain **100% for in-scope rows**, shortcut parity remains **100% (87/87)**, and XLSX work is now focused on fidelity proof, package-preserving save validation, and real-world workbook breadth rather than first-pass support. The XLSX corpus currently has 175 workbook manifest rows.

Overall completion remains **95%** in [release/progress.json](../release/progress.json), which keeps tester builds in the `v0.8.<run>` stream. Overall completion estimate is now **95%**. The main remaining work is package-preserving XLSX validation, broader corpus proof, release signing/trust and human accessibility validation, localization breadth, keytip/visual polish, and measured performance hardening.

The project history metrics report now covers Git and provider-log activity from 2026-05-12 through 2026-05-31 inclusive. Through May 31, the daily churn table records **11,780 commits**, **14,464 changed-file/day entries**, **+1,429,132 / -922,973 LoC**, and local provider logs attribute **116,943,364,224 observed raw tokens** across OpenAI/Codex and Anthropic/Claude rows.

## Current Repository Metrics

| Metric | Count |
| --- | ---: |
| Tracked files | 2,189 |
| C# source files under `src/` | 1,015 |
| C# test files under `tests/` | 516 |
| Markdown docs under `docs/` | 243 |
| Current C# source LOC | 196,147 |
| Current C# test LOC | 199,785 |
| Current XAML LOC | 8,256 |
| XLSX corpus manifest rows | 175 |

## Current Repository State

| Item | Status |
| --- | --- |
| Mainline | Branch-neutral `origin/main` snapshot remains the canonical comparison point; local integration main was observed at `357ef17799` for this refresh |
| Completion tracking | [release/progress.json](../release/progress.json) remains at `overallCompletion: 95` |
| History metrics | [PROJECT_BUILD_HISTORY_METRICS.md](PROJECT_BUILD_HISTORY_METRICS.md) is refreshed through 2026-05-31 inclusive |
| Branch posture | Multiple worker branches/worktrees are still registered for active or paused parallel implementation; this report does not treat worker-owned checkouts as mainline status |
| Release posture | Tester-release automation can publish `.exe` and MSIX assets; signing/trust and public-preview evidence remain release-gate work |
| Documentation posture | The docs index, backlog, next-phase plan, localization plan, fidelity report, and metrics report now point at the current app state |

## Current Parity Snapshot

| Surface | Status |
| --- | --- |
| Formula engine | 487/487 in-scope functions implemented and tested; current work is parity proof and targeted edge-case hardening. |
| Command surface | 100% of in-scope command-surface rows covered; deferred/excluded rows are documented rather than counted as missing. |
| Menu/toolbar parity | 100% of in-scope menu/toolbar rows covered, with deferred/excluded rows tracked separately. |
| Keyboard shortcuts | **100% parity** (87/87), **0% partial** (0/87), **0 missing**. |
| XLSX fidelity | 71 documented in-scope feature categories with at least partial support; corpus remains at 175 workbook manifest rows with generated/public/regression evidence and known-gap warning coverage. |
| UI/dialog parity | Dialog message routing, access keys, default/cancel semantics, UIA metadata, keytips, ribbon layout, titlebar/QAT states, and sheet-tab chrome have broad automated coverage and continuing visual polish. |
| Localization | `UiText`, `LocExtension`, neutral resources, Bulgarian satellite resources, startup UI culture, WPF language metadata, and localization guard tests are present. |
| Release readiness | User guide, troubleshooting, legal/privacy notices, release checklist, diagnostics, crash analytics, and tester-release workflow docs are present; public-preview promotion still needs live validation evidence. |

Phase 7D: Deeper color-scale XLSX edge semantics as new gaps are found.

## Recent Highlights Since The May 29 Snapshot

1. **Formula catalog status corrected**
   - Current docs now use the 487/487 in-scope function catalog from `FUNCTION_PARITY.md` and `FormulaParityCatalogTests`.

2. **Localization foundation landed**
   - Host UI text now has a resource path through `UiText` and `LocExtension`, with neutral and Bulgarian resource files plus guard tests for resource usage, key parity, placeholders, access keys, and automation metadata.

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

## Active Workstream Picture

Parallel implementation remains expected. Mainline is the integration target, while worker-owned branches and worktrees may continue carrying active, dirty, or paused work. Before merging any implementation slice, keep syncing from `main`, verify relevant build/tests in the owning worktree, and leave unrelated worker-owned changes untouched.

## Remaining Outstanding Work

See [OUTSTANDING_BUILD.md](OUTSTANDING_BUILD.md) for the source-of-truth backlog. The highest-priority open items are:

1. **XLSX corpus and fidelity proof**
   - Expand the 175-row corpus baseline with broader public/private/regression workbook coverage and per-feature pass/fail publication.
2. **Package-preserving XLSX save path**
   - Desktop Excel open/save/reopen checks remain release-critical validation.
3. **Release documentation and packaging**
   - Signing, installer trust validation, and live accessibility validation remain release-gate work.
4. **Keytip overlay placement**
   - Continue visual-placement polish beyond the current automated key routing and UIA coverage.
5. **XLSX warning coverage as new gaps are found**
   - Keep unsupported-feature detection aligned with newly discovered OOXML package parts.

Current planning, parity, and release-readiness sources: [OUTSTANDING_BUILD.md](OUTSTANDING_BUILD.md), [NEXT_PHASES_PLAN.md](NEXT_PHASES_PLAN.md), [COMMAND_SURFACE_PARITY.md](COMMAND_SURFACE_PARITY.md), [MENU_TOOLBAR_PARITY.md](MENU_TOOLBAR_PARITY.md), [SHORTCUT_PARITY_MATRIX.md](SHORTCUT_PARITY_MATRIX.md), [FUNCTION_PARITY.md](FUNCTION_PARITY.md), [FIDELITY_CONTRACT.md](FIDELITY_CONTRACT.md), [XLSX_CORPUS_REPORT.md](XLSX_CORPUS_REPORT.md), [LOCALIZATION_PLAN.md](LOCALIZATION_PLAN.md), [TEST_DISTRIBUTION_PLAN.md](TEST_DISTRIBUTION_PLAN.md), and [PERF_BASELINE.md](PERF_BASELINE.md).
