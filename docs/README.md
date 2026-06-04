# FreeX Documentation

**Last updated:** 2026-06-04

Use these files as the current documentation set. Point-in-time reports are snapshots; prefer the newest report plus the source-of-truth backlog for current planning.

**Trademark notice:** FreeX is not affiliated with, endorsed by, or sponsored by Microsoft. Microsoft Excel is a trademark of Microsoft Corporation. See [LEGAL_NOTICES.md](LEGAL_NOTICES.md).

**Legal, privacy, and dependency notices:** See [../LICENSE](../LICENSE), [LEGAL_NOTICES.md](LEGAL_NOTICES.md), [PRIVACY.md](PRIVACY.md), [../THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md), [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md), and [THIRD_PARTY_LICENSE_AUDIT_2026-05-30.md](THIRD_PARTY_LICENSE_AUDIT_2026-05-30.md). The packaged app exposes the same project license, legal notice, privacy notice, third-party notices, and bundled third-party license texts from Help > Legal Notices.

## User-Facing Documentation

- [USER_GUIDE.md](USER_GUIDE.md) - comprehensive end-user guide covering all supported features, navigation, formulas, charts, PivotTables, printing, and keyboard shortcuts.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - common issues, error messages, known limitations, and how to report bugs.
- [../LICENSE](../LICENSE) - project source license and tester-binary evaluation terms.
- [LEGAL_NOTICES.md](LEGAL_NOTICES.md) - trademark, attribution, and compatibility-reference notices.
- [PRIVACY.md](PRIVACY.md) - local diagnostics, optional crash-reporting, and tester privacy behavior.
- [THIRD_PARTY_LICENSE_AUDIT_2026-05-30.md](THIRD_PARTY_LICENSE_AUDIT_2026-05-30.md) - NuGet package notice coverage and remaining commercial-use watch item.

## Start Here

- [OUTSTANDING_BUILD.md](OUTSTANDING_BUILD.md) - source-of-truth backlog for outstanding build work.
- [PROJECT_STATUS_REPORT_2026-06-04.md](PROJECT_STATUS_REPORT_2026-06-04.md) - current project status snapshot; current `overallCompletion` remains 95 while parity hardening, release validation, localization review/package metadata, and XLSX fidelity proof continue.
- [NEXT_PHASES_PLAN.md](NEXT_PHASES_PLAN.md) - next development phases and priority sequencing.
- [PERFORMANCE_BACKLOG_2026-06-04.md](PERFORMANCE_BACKLOG_2026-06-04.md) - current performance backlog and active XLSX open/save IO priority.

## Parity And Fidelity

- [COMMAND_SURFACE_PARITY.md](COMMAND_SURFACE_PARITY.md) - command and ribbon parity scope.
- [MENU_TOOLBAR_PARITY.md](MENU_TOOLBAR_PARITY.md) - menu/toolbar parity scope generated from the shared command inventory.
- [COMMAND_ICON_AUDIT_2026-05-30.md](COMMAND_ICON_AUDIT_2026-05-30.md) - proposal-only command icon audit backing the May 30 visual review.
- [COMMAND_ICON_VISUAL_CONSISTENCY_REVIEW_2026-05-30.md](COMMAND_ICON_VISUAL_CONSISTENCY_REVIEW_2026-05-30.md) - current visual-consistency review for borders, backgrounds, optical sizing, crispness, and style unification.
- [COMMAND_ICON_REVIEW_2026-05-29.md](COMMAND_ICON_REVIEW_2026-05-29.md) - prior SVG command-icon audit and proposed next icon improvements.
- [SHORTCUT_PARITY_MATRIX.md](SHORTCUT_PARITY_MATRIX.md) - keyboard shortcut and keytip parity tracking.
- [FIDELITY_CONTRACT.md](FIDELITY_CONTRACT.md) - supported, partial, and excluded XLSX round-trip behavior.
- [CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md](CHARTS_EXCEL_FREEX_COMPARISON_2026-06-01.md) - current chart interop evidence, including the 28/28 latest-complete Excel openability/export and visual-gate pass, 0 known-gap allowances, and the byte-identical package guard for repeated Excel PNG export variance.
- [EXCEL_OPEN_SMOKE.md](EXCEL_OPEN_SMOKE.md) - real desktop Excel XLSX open/save/reopen smoke-tool instructions.
- [FUNCTION_PARITY.md](FUNCTION_PARITY.md) - formula function coverage and hardening notes.
- [XLSX_CORPUS_REPORT.md](XLSX_CORPUS_REPORT.md) - current executable corpus status.
- [XLSX_TEST_CORPUS_PLAN.md](XLSX_TEST_CORPUS_PLAN.md) - planned corpus shape and reporting rules.
- [OPEN_FORMAT_PHASE3_ODS_RESEARCH.md](OPEN_FORMAT_PHASE3_ODS_RESEARCH.md) - parked ODS research; not active implementation scope.
- [TEST_DISTRIBUTION_PLAN.md](TEST_DISTRIBUTION_PLAN.md) - tester release workflow, latest-download link, and diagnostics/reporting flow.
- [TESTER_RELEASE_CHECKLIST.md](TESTER_RELEASE_CHECKLIST.md) - release-gate and public-preview accessibility checklist for tester builds.

## Testing And User Feedback

- [UI_TEST_CATALOG.md](UI_TEST_CATALOG.md) - append-only UI command/interaction catalog, coverage log, findings log, and smoke evidence index.
- [TEST_DISTRIBUTION_PLAN.md](TEST_DISTRIBUTION_PLAN.md) - test-suite distribution, default agent verification path, separate UI lane, diagnostics plan, and tester-release workflow.
- [USER_TESTING_REPORT_2026-05-24.md](USER_TESTING_REPORT_2026-05-24.md) - original May 24 user-testing issue tracker.
- [USER_FEEDBACK_RETEST_REPORT_2026-05-24.md](USER_FEEDBACK_RETEST_REPORT_2026-05-24.md) - retest evidence for the May 24 feedback batch.

## Architecture And Decisions

- [ARCHITECTURE.md](ARCHITECTURE.md) - current layer boundaries and architectural decisions.
- [LOCALIZATION_PLAN.md](LOCALIZATION_PLAN.md) - localization foundation, current resource status, rollout plan, and remaining culture/localization work.
- [CODE_REVIEW_COMPREHENSIVE_2026-05-28.md](CODE_REVIEW_COMPREHENSIVE_2026-05-28.md) - comprehensive review batch behind the May 28 hardening work (PRs #33–#44).
- [CODE_REVIEW_COMPREHENSIVE_2026-05-30.md](CODE_REVIEW_COMPREHENSIVE_2026-05-30.md) - May 30 full-source review: verifies the May 28 findings are resolved and records the residual hardening backlog.
- [CODE_REVIEW_COMPREHENSIVE_2026-06-01.md](CODE_REVIEW_COMPREHENSIVE_2026-06-01.md) - June 1 full-source review snapshot; superseded by the June 3 review for latest findings.
- [CODE_REVIEW_COMPREHENSIVE_2026-06-03.md](CODE_REVIEW_COMPREHENSIVE_2026-06-03.md) - June 3 full-codebase review and resolved follow-up across XLSX safety, formula parity, UI accessibility, export/import UX, and release automation.
- [CODE_REVIEW.md](CODE_REVIEW.md) - cumulative review findings and fixed-item verification history, including the 2026-05-29 production readiness pass (PRs #45–#49).
- [DECISIONS/](DECISIONS/) - ADRs for durable technical decisions.
- [DECISIONS/008-code-review-hardening-2026-05-28.md](DECISIONS/008-code-review-hardening-2026-05-28.md) - ADR for the May 28 code-review hardening batch.
- [NATIVE_JSON_SCHEMA.md](NATIVE_JSON_SCHEMA.md) - FreeX native JSON format.
- [PERF_BASELINE.md](PERF_BASELINE.md) - performance baseline notes.
- [PERFORMANCE_BACKLOG_2026-06-04.md](PERFORMANCE_BACKLOG_2026-06-04.md) - current performance backlog and XLSX IO focus.
- [PERFORMANCE_REVIEW_2026-05-28.md](PERFORMANCE_REVIEW_2026-05-28.md) - May 28 UI performance review, measurements, and remaining bottlenecks.

## Historical Snapshots

- [PROJECT_STATUS_REPORT_2026-06-03.md](PROJECT_STATUS_REPORT_2026-06-03.md) - backfilled status snapshot covering the June 3 review, test split, XLSX smoke, PDF overlay, and performance integrations.
- [PROJECT_STATUS_REPORT_2026-06-02.md](PROJECT_STATUS_REPORT_2026-06-02.md) - backfilled status snapshot covering the June 2 performance, parity, file-format, and release-gate integrations.
- [PROJECT_STATUS_REPORT_2026-06-01.md](PROJECT_STATUS_REPORT_2026-06-01.md) - prior status snapshot covering the June 1 localization, chart interop, metrics, and corpus state.
- [PROJECT_STATUS_REPORT_2026-05-29.md](PROJECT_STATUS_REPORT_2026-05-29.md) - prior status snapshot covering the May 29 production-readiness pass.
- [PROJECT_STATUS_REPORT_2026-05-28.md](PROJECT_STATUS_REPORT_2026-05-28.md) - prior status snapshot covering the production-readiness transition.
- [PROJECT_STATUS_REPORT_2026-05-27.md](PROJECT_STATUS_REPORT_2026-05-27.md) - prior maintenance/status snapshot.
- [PROJECT_STATUS_REPORT_2026-05-26.md](PROJECT_STATUS_REPORT_2026-05-26.md) - prior status snapshot with the May 26 consolidation view.
- [PROJECT_STATUS_REPORT_2026-05-25.md](PROJECT_STATUS_REPORT_2026-05-25.md) - prior status snapshot with source metrics and active workstream listing.
- [PROJECT_STATUS_REPORT_2026-05-24.md](PROJECT_STATUS_REPORT_2026-05-24.md) - prior status snapshot (May 24).
- [PROJECT_STATUS_REPORT_2026-05-21.md](PROJECT_STATUS_REPORT_2026-05-21.md) - prior status snapshot.
- [PROJECT_STATUS_REPORT_2026-05-19.md](PROJECT_STATUS_REPORT_2026-05-19.md) - prior status snapshot.
- [PROJECT_BUILD_HISTORY_METRICS.md](PROJECT_BUILD_HISTORY_METRICS.md) - generated build-history and provider-log metrics through 2026-06-03.
- [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) - historical formula/XLSX implementation plan retained for context.

Historical status reports and implementation notes under `docs/superpowers/` are not current build-status documents.

## Visual Assets

- Current runtime command artwork lives in `src/FreeX.App.Host/Resources/CommandIconsSvg/`.
- Historical UI screenshot evidence is no longer checked in under `docs/ui-test-artifacts`; keep new screenshots there only when they are current review evidence and referenced by `UI_TEST_CATALOG.md`.
- The obsolete generated PNG icon review set was removed. Use the SVG command-icon audit and source assets above for future icon work.
