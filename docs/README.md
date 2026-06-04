# FreeX Documentation

**Last updated:** 2026-06-04

Use this index as the current documentation map. Point-in-time material lives under `history/` and `archive/`; prefer the newest status snapshot plus the current planning docs when making product or release decisions.

**Trademark notice:** FreeX is not affiliated with, endorsed by, or sponsored by Microsoft. Microsoft Excel is a trademark of Microsoft Corporation. See [legal/legal-notices.md](legal/legal-notices.md).

**Legal, privacy, and dependency notices:** See [../LICENSE](../LICENSE), [legal/legal-notices.md](legal/legal-notices.md), [legal/privacy.md](legal/privacy.md), [../THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md), [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md), and [legal/third-party-license-audit-2026-05-30.md](legal/third-party-license-audit-2026-05-30.md). The packaged app exposes the same project license, legal notice, privacy notice, third-party notices, and bundled third-party license texts from Help > Legal Notices.

## Start Here

- [planning/outstanding-build.md](planning/outstanding-build.md) - source-of-truth backlog for outstanding build work.
- [history/status-2026-06-04.md](history/status-2026-06-04.md) - current project status snapshot; current `overallCompletion` remains 95 while parity hardening, release validation, localization review/package metadata, and XLSX fidelity proof continue.
- [planning/next-phases.md](planning/next-phases.md) - next development phases and priority sequencing.
- [performance/backlog-2026-06-04.md](performance/backlog-2026-06-04.md) - current performance backlog and active XLSX open/save IO priority.

## User

- [user/guide.md](user/guide.md) - comprehensive end-user guide covering supported features, navigation, formulas, charts, PivotTables, printing, and keyboard shortcuts.
- [user/troubleshooting.md](user/troubleshooting.md) - common issues, error messages, known limitations, and how to report bugs.

## Legal

- [legal/legal-notices.md](legal/legal-notices.md) - trademark, attribution, and compatibility-reference notices.
- [legal/privacy.md](legal/privacy.md) - local diagnostics, optional crash-reporting, and tester privacy behavior.
- [legal/third-party-license-audit-2026-05-30.md](legal/third-party-license-audit-2026-05-30.md) - NuGet package notice coverage and remaining commercial-use watch item.

## Planning And Release

- [planning/localization.md](planning/localization.md) - localization foundation, current resource status, rollout plan, and remaining culture/localization work.
- [release/test-distribution.md](release/test-distribution.md) - test-suite distribution, default agent verification path, separate UI lane, diagnostics plan, and tester-release workflow.
- [release/tester-release-checklist.md](release/tester-release-checklist.md) - release-gate and public-preview accessibility checklist for tester builds.

## Parity And Testing

- [parity/command-surface.md](parity/command-surface.md) - command and ribbon parity scope.
- [parity/menu-toolbar.md](parity/menu-toolbar.md) - menu/toolbar parity scope generated from the shared command inventory.
- [parity/shortcuts.md](parity/shortcuts.md) - keyboard shortcut and keytip parity tracking.
- [parity/functions.md](parity/functions.md) - formula function coverage and hardening notes.
- [parity/command-inventory.json](parity/command-inventory.json) - generated command inventory source.
- [testing/ui-test-catalog.md](testing/ui-test-catalog.md) - append-only UI command/interaction catalog, coverage log, findings log, and smoke evidence index.

## Formats And Fidelity

- [formats/fidelity-contract.md](formats/fidelity-contract.md) - supported, partial, and excluded XLSX round-trip behavior.
- [formats/xlsx-corpus-report.md](formats/xlsx-corpus-report.md) - current executable XLSX corpus status.
- [formats/xlsx-test-corpus-plan.md](formats/xlsx-test-corpus-plan.md) - planned corpus shape and reporting rules.
- [formats/excel-open-smoke.md](formats/excel-open-smoke.md) - real desktop Excel XLSX open/save/reopen smoke-tool instructions.
- [formats/charts-excel-freex-comparison-2026-06-01.md](formats/charts-excel-freex-comparison-2026-06-01.md) - current chart interop evidence.
- [formats/native-json-schema.md](formats/native-json-schema.md) - FreeX native JSON format.
- [formats/ods-open-support-research.md](formats/ods-open-support-research.md) - parked ODS research; not active implementation scope.

## Architecture And Performance

- [architecture/architecture.md](architecture/architecture.md) - current layer boundaries and architectural decisions.
- [architecture/decisions/](architecture/decisions/) - ADRs for durable technical decisions.
- [architecture/decisions/008-code-review-hardening-2026-05-28.md](architecture/decisions/008-code-review-hardening-2026-05-28.md) - ADR for the May 28 code-review hardening batch.
- [performance/baseline.md](performance/baseline.md) - performance baseline notes.
- [performance/backlog-2026-06-04.md](performance/backlog-2026-06-04.md) - current performance backlog and XLSX IO focus.

## Reviews

- [reviews/code-review-log.md](reviews/code-review-log.md) - cumulative review findings and fixed-item verification history.
- [reviews/comprehensive-code-review-2026-05-28.md](reviews/comprehensive-code-review-2026-05-28.md) - comprehensive review batch behind the May 28 hardening work.
- [reviews/comprehensive-code-review-2026-05-30.md](reviews/comprehensive-code-review-2026-05-30.md) - May 30 full-source review.
- [reviews/comprehensive-code-review-2026-06-01.md](reviews/comprehensive-code-review-2026-06-01.md) - June 1 full-source review snapshot.
- [reviews/comprehensive-code-review-2026-06-03.md](reviews/comprehensive-code-review-2026-06-03.md) - June 3 full-codebase review and resolved follow-up.
- [reviews/command-icon-audit-2026-05-30.md](reviews/command-icon-audit-2026-05-30.md) - proposal-only command icon audit.
- [reviews/command-icon-review-2026-05-29.md](reviews/command-icon-review-2026-05-29.md) - prior SVG command-icon audit.
- [reviews/command-icon-visual-consistency-2026-05-30.md](reviews/command-icon-visual-consistency-2026-05-30.md) - visual-consistency review for command artwork.
- [reviews/performance-review-2026-05-28.md](reviews/performance-review-2026-05-28.md) - May 28 UI performance review, measurements, and remaining bottlenecks.

## History

- [history/status-2026-06-03.md](history/status-2026-06-03.md) - backfilled status snapshot covering the June 3 review, test split, XLSX smoke, PDF overlay, and performance integrations.
- [history/status-2026-06-02.md](history/status-2026-06-02.md) - backfilled status snapshot covering the June 2 performance, parity, file-format, and release-gate integrations.
- [history/status-2026-06-01.md](history/status-2026-06-01.md) - prior status snapshot covering the June 1 localization, chart interop, metrics, and corpus state.
- [history/status-2026-05-29.md](history/status-2026-05-29.md) - prior status snapshot covering the May 29 production-readiness pass.
- [history/status-2026-05-28.md](history/status-2026-05-28.md) - prior status snapshot covering the production-readiness transition.
- [history/status-2026-05-27.md](history/status-2026-05-27.md) - prior maintenance/status snapshot.
- [history/status-2026-05-26.md](history/status-2026-05-26.md) - prior status snapshot with the May 26 consolidation view.
- [history/status-2026-05-25.md](history/status-2026-05-25.md) - prior status snapshot with source metrics and active workstream listing.
- [history/status-2026-05-24.md](history/status-2026-05-24.md) - prior status snapshot.
- [history/status-2026-05-21.md](history/status-2026-05-21.md) - prior status snapshot.
- [history/status-2026-05-19.md](history/status-2026-05-19.md) - prior status snapshot.
- [history/build-history-metrics.md](history/build-history-metrics.md) - generated build-history and provider-log metrics through 2026-06-03.
- [history/implementation-plan.md](history/implementation-plan.md) - historical formula/XLSX implementation plan retained for context.
- [archive/superpowers/](archive/superpowers/) - historical implementation plans and specs; not current build-status documentation.

## Visual Assets

- Current runtime command artwork lives in `src/FreeX.App.Host/Resources/CommandIconsSvg/`.
- Historical UI screenshot evidence is no longer checked in under `docs/ui-test-artifacts`; keep new screenshots there only when they are current review evidence and referenced by [testing/ui-test-catalog.md](testing/ui-test-catalog.md).
- The obsolete generated PNG icon review set was removed. Use the SVG command-icon reviews and source assets above for future icon work.
