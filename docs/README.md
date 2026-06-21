# FreeX Documentation

**Last updated:** 2026-06-21

Use this index as the current documentation map. Point-in-time material lives under `history/` and `archive/`; prefer the newest status snapshot plus the current planning docs when making product or release decisions.

**Trademark notice:** FreeX is not affiliated with, endorsed by, or sponsored by Microsoft. Microsoft Excel is a trademark of Microsoft Corporation. See [legal/legal-notices.md](legal/legal-notices.md).

**Legal, privacy, and dependency notices:** See [../LICENSE](../LICENSE), [legal/legal-notices.md](legal/legal-notices.md), [legal/privacy.md](legal/privacy.md), [../THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md), [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md), and [legal/third-party-license-audit-2026-05-30.md](legal/third-party-license-audit-2026-05-30.md). The packaged app exposes the same project license, legal notice, privacy notice, third-party notices, and bundled third-party license texts from Help > Legal Notices.

## Start Here

- [history/status-2026-06-21.md](history/status-2026-06-21.md) - current project status snapshot covering the v0.8.127 tester release, current workbook/document file-format surface, release posture, and hygiene rules.
- [planning/outstanding-build.md](planning/outstanding-build.md) - historical backlog plus current 2026-06-21 status note for outstanding build work.
- [planning/next-phases.md](planning/next-phases.md) - next development phases and priority sequencing, retained as a June 3 planning snapshot unless superseded by newer status docs.
- [planning/multiplatform-macos-port.md](planning/multiplatform-macos-port.md) - preparation plan for a future multiplatform port, starting with macOS and a portable GitHub Actions lane.
- [planning/multiplatform-linux-port.md](planning/multiplatform-linux-port.md) - Linux port plan: Avalonia shell reuse, freedesktop/XDG packaging, hosted Ubuntu CI lane, and readiness tooling.
- [planning/macos-port-dependency-backlog.md](planning/macos-port-dependency-backlog.md) - concise inventory of Windows/WPF-only dependencies that block or shape the Avalonia/macOS port.
- [planning/freew-linux-port.md](planning/freew-linux-port.md) - FreeW (word processor) Linux port: Avalonia editing surface, ribbon, catalog-backed document formats, freedesktop packaging (tarball/.deb/AppImage), freew-linux CI lane, and feature coverage.
- [planning/freew-roadmap.md](planning/freew-roadmap.md) - historical FreeW construction log through the current file-format, corpus, icon, and platform slices.
- [planning/freew-command-inventory.md](planning/freew-command-inventory.md) - FreeW command inventory; defer current icon status to the June 19 FreeW icon audit.
- [planning/freew-file-formats.md](planning/freew-file-formats.md) - FreeW document-format adapter status matrix and remaining format gaps.
- [performance/backlog-2026-06-04.md](performance/backlog-2026-06-04.md) - current performance backlog and active XLSX open/save IO priority.

## User

- [user/guide.md](user/guide.md) - comprehensive end-user guide covering supported features, navigation, formulas, charts, PivotTables, printing, and keyboard shortcuts.
- [user/linux-install.md](user/linux-install.md) - installing FreeX on Linux: .deb / AppImage / tarball options, checksum verification, and file associations.
- [user/troubleshooting.md](user/troubleshooting.md) - common issues, error messages, known limitations, and how to report bugs.

## Legal

- [legal/legal-notices.md](legal/legal-notices.md) - trademark, attribution, and compatibility-reference notices.
- [legal/privacy.md](legal/privacy.md) - local diagnostics, optional crash-reporting, and tester privacy behavior.
- [legal/third-party-license-audit-2026-05-30.md](legal/third-party-license-audit-2026-05-30.md) - NuGet package notice coverage and remaining commercial-use watch item.

## Planning And Release

- [planning/localization.md](planning/localization.md) - localization foundation, current resource status, rollout plan, and remaining culture/localization work.
- [planning/multiplatform-macos-port.md](planning/multiplatform-macos-port.md) - macOS-first port preparation, portable CI validation, and future app-shell milestones.
- [planning/multiplatform-linux-port.md](planning/multiplatform-linux-port.md) - Linux port plan, freedesktop/XDG packaging, and the hosted Ubuntu app-preview lane.
- [planning/linux-release-roadmap.md](planning/linux-release-roadmap.md) - roadmap toward a Windows-comparable Linux release (release channel, parity sweep, accessibility, distribution).
- [release/linux-public-preview-checklist.md](release/linux-public-preview-checklist.md) - Linux preview release-gate checklist: hosted CI gates plus human X11/Wayland and accessibility validation.
- [release/linux-human-validation-checklist.md](release/linux-human-validation-checklist.md) - fillable Linux human-validation record (X11/Wayland, keyboard-only, Orca, install/AppImage) validated by Test-LinuxHumanValidationChecklist.ps1.
- [release/linux-release.md](release/linux-release.md) - Linux release channel runbook: versioned tarball/AppImage publish, promotion gate, and dispatch instructions.
- [planning/macos-port-dependency-backlog.md](planning/macos-port-dependency-backlog.md) - macOS port backlog inventory for WPF/Windows-only components and platform-service replacement work.
- [planning/macos-state-management.md](planning/macos-state-management.md) - macOS port state-location guidance for user settings, recent files, diagnostics, caches, and shared abstractions.
- [release/test-distribution.md](release/test-distribution.md) - test-suite distribution, default agent verification path, separate UI lane, diagnostics plan, and tester-release workflow.
- [release/macos-signing-notarization.md](release/macos-signing-notarization.md) - hosted macOS app preview artifact retrieval, Developer ID signing, and notarization runbook.
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
- [formats/ods-open-support-research.md](formats/ods-open-support-research.md) - historical ODS research superseded by the in-house ODS adapter now registered in the workbook adapter catalog.
- [fidelity/README.md](fidelity/README.md) - current fidelity workstream summary, harness list, deferred items, and artifact hygiene rules.
- [fidelity/2026-06-19-file-format-support-audit.md](fidelity/2026-06-19-file-format-support-audit.md) - current spreadsheet file-format adapter support audit and follow-up plan.
- [fidelity/2026-06-19-freew-corpus-feature-growth.md](fidelity/2026-06-19-freew-corpus-feature-growth.md) - current FreeW DOCX corpus expansion note.
- [fidelity/2026-06-18-xlsx-chart-pivot-corpus-growth.md](fidelity/2026-06-18-xlsx-chart-pivot-corpus-growth.md) - XLSX chart/PivotTable corpus expansion note.

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
- [reviews/comprehensive-code-review-2026-06-11.md](reviews/comprehensive-code-review-2026-06-11.md) - June 11 full-workspace review: save-pipeline data-integrity risks, command shift gaps, formula parity, performance, and consolidation backlog.
- [reviews/comprehensive-code-review-2026-06-12.md](reviews/comprehensive-code-review-2026-06-12.md) - June 12 full-workspace review: fix-campaign regression audit (close-flow and multi-window P1s), protection-guard omissions, chart/pivot/fxl round-trip fidelity, recovery-flow holes, Avalonia-port gap, and carry-forward status.
- [reviews/comprehensive-code-review-2026-06-18.md](reviews/comprehensive-code-review-2026-06-18.md) - June 18 full-source static review plus same-day high-severity fix summary and deferred follow-ups.
- [reviews/comprehensive-code-review-2026-06-18-iter6.md](reviews/comprehensive-code-review-2026-06-18-iter6.md) - final June 18 review iteration covering spill cleanup, save warnings, autosave path-provider wiring, and package XML validation.
- [reviews/comprehensive-code-review-2026-06-19-iter5.md](reviews/comprehensive-code-review-2026-06-19-iter5.md) - June 19 review iteration covering document package fidelity, corpus validation, and format cross-check hardening.
- [reviews/comprehensive-code-review-2026-06-19-iter6.md](reviews/comprehensive-code-review-2026-06-19-iter6.md) - final June 19 review iteration; use with the cumulative review log for current review status.
- [reviews/comprehensive-code-review-2026-06-21-iter1.md](reviews/comprehensive-code-review-2026-06-21-iter1.md) - June 21 review iteration covering CI/main push coverage, format cross-check failure behavior, FreeW HTML vertical merges, and XLS metadata preservation.
- [reviews/comprehensive-code-review-2026-06-21-iter2.md](reviews/comprehensive-code-review-2026-06-21-iter2.md) - June 21 review iteration covering XLSX protection metadata, solution/workflow preflight coverage, FreeW MHTML/HTML import fidelity, and copy-sheet positioning.
- [reviews/comprehensive-code-review-2026-06-21-iter3.md](reviews/comprehensive-code-review-2026-06-21-iter3.md) - June 21 review iteration covering quoted workflow-trigger guards, FreeW DOCX package metadata preservation, and copy-sheet no-op follow-up scope.
- [reviews/comprehensive-code-review-2026-06-21-iter4.md](reviews/comprehensive-code-review-2026-06-21-iter4.md) - June 21 review iteration covering quoted YAML trigger-key guards, default test lane coverage, FreeW MHTML image metadata, and sheet-move no-op handling.
- [reviews/command-icon-audit-2026-05-30.md](reviews/command-icon-audit-2026-05-30.md) - proposal-only command icon audit.
- [reviews/command-icon-review-2026-05-29.md](reviews/command-icon-review-2026-05-29.md) - prior SVG command-icon audit.
- [reviews/command-icon-visual-consistency-2026-05-30.md](reviews/command-icon-visual-consistency-2026-05-30.md) - visual-consistency review for command artwork.
- [reviews/performance-review-2026-05-28.md](reviews/performance-review-2026-05-28.md) - May 28 UI performance review, measurements, and remaining bottlenecks.

## History

- [history/status-2026-06-21.md](history/status-2026-06-21.md) - current status snapshot covering the v0.8.127 tester release, current format support, promotion blockers, and hygiene rules.
- [history/status-2026-06-12.md](history/status-2026-06-12.md) - prior status snapshot covering the June 12 stable latest `origin/main` release, v0.8.114, prior failed run 113 hosted UI source-contract gate, and release blockers as of that date.
- [history/status-2026-06-11.md](history/status-2026-06-11.md) - prior status snapshot covering the June 11 stable latest `origin/main` release, v0.8.112, prior failed run 111 hosted UI gate, and current release blockers.
- [history/status-2026-06-10.md](history/status-2026-06-10.md) - prior status snapshot covering the June 10 branch-neutral `origin/main` release, v0.8.110 tester pre-release, prior failed run 109 hosted UI gate, and current release blockers.
- [history/status-2026-06-08.md](history/status-2026-06-08.md) - prior status snapshot covering the June 8 corpus, v0.8.108 tester pre-release, release-readiness, and outstanding-work alignment.
- [history/status-2026-06-07.md](history/status-2026-06-07.md) - prior status snapshot covering the v0.8.90 daily tester release, frozen release commit, and hosted gate evidence.
- [history/status-2026-06-06.md](history/status-2026-06-06.md) - prior status snapshot covering the v0.8.89 daily tester release, frozen release commit, and hosted gate evidence.
- [history/status-2026-06-04.md](history/status-2026-06-04.md) - prior status snapshot covering the June 4 parity hardening and release-validation state.
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
- [history/build-history-metrics.md](history/build-history-metrics.md) - historical generated build-history and provider-log metrics through 2026-06-06.
- [history/thread-commit-timing.md](history/thread-commit-timing.md) - historical generated first-parent thread timing report with commit counts, discovery offsets, implementation spans, and integration lags.
- [history/implementation-plan.md](history/implementation-plan.md) - historical formula/XLSX implementation plan retained for context.
- [archive/superpowers/](archive/superpowers/) - historical implementation plans and specs; not current build-status documentation.

## Visual Assets

- Current runtime command artwork lives in `src/FreeX.App.Host/Resources/CommandIconsSvg/`.
- [icon-audit/freex-icon-audit-2026-06-18.md](icon-audit/freex-icon-audit-2026-06-18.md) is the durable generated icon-audit summary; generated HTML/JSON tables are local artifacts and should be regenerated, not committed.
- [icon-audit/freew-icon-audit-2026-06-19.md](icon-audit/freew-icon-audit-2026-06-19.md) is the durable FreeW generated icon-audit summary; generated HTML/JSON tables are local artifacts and should be regenerated, not committed.
- Historical UI screenshot evidence is no longer checked in under `docs/ui-test-artifacts`; keep new screenshots there only when they are current review evidence and referenced by [testing/ui-test-catalog.md](testing/ui-test-catalog.md).
- The obsolete generated PNG icon review set was removed. Use the SVG command-icon reviews and source assets above for future icon work.
