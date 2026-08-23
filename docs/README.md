# FreeX Documentation

**Last updated:** 2026-08-08

Use this index as the current documentation map. Point-in-time material lives under `history/` and `archive/`; prefer the newest status snapshot plus the current planning docs when making product or release decisions.

**Trademark notice:** FreeX is not affiliated with, endorsed by, or sponsored by Microsoft. Microsoft Excel is a trademark of Microsoft Corporation. See [legal/legal-notices.md](legal/legal-notices.md).

**Legal, privacy, and dependency notices:** See [../LICENSE](../LICENSE), [legal/legal-notices.md](legal/legal-notices.md), [legal/privacy.md](legal/privacy.md), [../THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md), [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md), and [legal/third-party-license-audit-2026-05-30.md](legal/third-party-license-audit-2026-05-30.md). The packaged app exposes the same project license, legal notice, privacy notice, third-party notices, and bundled third-party license texts from Help > Legal Notices.

## Start Here

- [history/status-2026-08-08.md](history/status-2026-08-08.md) - current status snapshot covering the next tester release candidate off main, FreeP/FreeW/Avalonia maturation since 2026-06-24, and release posture.
- [history/status-2026-06-24.md](history/status-2026-06-24.md) - prior status snapshot covering the next tester release candidate off main, current workbook/document file-format surface, and release posture.
- [history/status-2026-06-21.md](history/status-2026-06-21.md) - prior status snapshot covering the v0.8.127 tester release, current workbook/document file-format surface, release posture, and hygiene rules.
- [planning/outstanding-build.md](planning/outstanding-build.md) - historical backlog plus current 2026-06-21 status note for outstanding build work.
- [planning/next-phases.md](planning/next-phases.md) - next development phases and priority sequencing, retained as a June 3 planning snapshot unless superseded by newer status docs.
- [planning/multiplatform-macos-port.md](planning/multiplatform-macos-port.md) - preparation plan for a future multiplatform port, starting with macOS and a portable GitHub Actions lane.
- [planning/multiplatform-linux-port.md](planning/multiplatform-linux-port.md) - Linux port plan: Avalonia shell reuse, freedesktop/XDG packaging, hosted Ubuntu CI lane, and readiness tooling.
- [planning/macos-port-dependency-backlog.md](planning/macos-port-dependency-backlog.md) - concise inventory of Windows/WPF-only dependencies that block or shape the Avalonia/macOS port.
- [planning/freew-linux-port.md](planning/freew-linux-port.md) - FreeW (word processor) Linux port: Avalonia editing surface, ribbon, catalog-backed document formats, freedesktop packaging (tarball/.deb/AppImage), freew-linux CI lane, and feature coverage.
- [planning/freew-roadmap.md](planning/freew-roadmap.md) - historical FreeW construction log through the current file-format, corpus, icon, and platform slices.
- [planning/freew-command-inventory.md](planning/freew-command-inventory.md) - FreeW command inventory; defer current icon status to the June 19 FreeW icon audit.
- [planning/freew-file-formats.md](planning/freew-file-formats.md) - FreeW document-format adapter status matrix and remaining format gaps.
- [planning/freep-powerpoint-parity-status-2026-06-27.md](planning/freep-powerpoint-parity-status-2026-06-27.md) - current FreeP PowerPoint parity status, remaining gaps, and first-wave worker orchestration map.
- [planning/freep-functional-parity-audit-2026-08-06.md](planning/freep-functional-parity-audit-2026-08-06.md) - current function-first audit separating implemented Windows media/OLE paths from the remaining capture, caption-mux, host, and external-baseline boundaries.
- [performance/backlog-2026-06-04.md](performance/backlog-2026-06-04.md) - current performance backlog and active XLSX open/save IO priority.

## User

- [user/guide.md](user/guide.md) - comprehensive end-user guide covering supported features, navigation, formulas, charts, PivotTables, printing, and keyboard shortcuts.
- [user/linux-install.md](user/linux-install.md) - installing FreeX on Linux: .deb / AppImage / tarball options, checksum verification, and file associations.
- [user/troubleshooting.md](user/troubleshooting.md) - common issues, error messages, known limitations, and how to report bugs.
- [support/feedback.md](support/feedback.md) - suite-wide feedback, diagnostic-attachment safety, and private security-report routing.
- [../SECURITY.md](../SECURITY.md) - supported-preview posture and private vulnerability reporting policy.

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
- [release/app-platform-publish-lanes.md](release/app-platform-publish-lanes.md) - canonical per-app and full-suite portable/installer artifact map for Windows, Linux, and macOS.
- [release/public-preview-readiness.md](release/public-preview-readiness.md) - suite-wide certificate-independent, crash-analytics, feedback, packaging, and deferred-signing release gate.
- [release/macos-signing-notarization.md](release/macos-signing-notarization.md) - hosted macOS app preview artifact retrieval, Developer ID signing, and notarization runbook.
- [release/tester-release-checklist.md](release/tester-release-checklist.md) - release-gate and public-preview accessibility checklist for tester builds.

## Parity And Testing

- [parity/command-surface.md](parity/command-surface.md) - command and ribbon parity scope.
- [parity/menu-toolbar.md](parity/menu-toolbar.md) - menu/toolbar parity scope generated from the shared command inventory.
- [parity/shortcuts.md](parity/shortcuts.md) - keyboard shortcut and keytip parity tracking.
- [parity/2026-07-01-freex-excel-wpf-avalonia-parity-plan.md](parity/2026-07-01-freex-excel-wpf-avalonia-parity-plan.md) - FreeX Excel parity gap plan for WPF and Avalonia after the shared-code dedup wave.
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
- [fidelity/2026-06-22-pivottable-excel-parity.md](fidelity/2026-06-22-pivottable-excel-parity.md) - PivotTable Excel parity checkpoint covering generated, Excel-authored, and real-world PivotTable harness results.
- [fidelity/2026-06-22-pivottable-local-coverage.md](fidelity/2026-06-22-pivottable-local-coverage.md) - PivotTable local coverage expansion covering native Excel-authored corpus generation, visual range comparison, and the unskipped real-world batch.
- [fidelity/2026-06-22-pivottable-complete-local-progress.md](fidelity/2026-06-22-pivottable-complete-local-progress.md) - PivotTable complete-local-fidelity progress note covering Excel-authoritative visual ranges, refreshed native fixtures, and remaining non-external gaps.
- [fidelity/2026-06-22-pivottable-native-corpus-expansion.md](fidelity/2026-06-22-pivottable-native-corpus-expansion.md) - PivotTable native corpus expansion covering Excel-authored filters, value filters, sort materialization, and layout/display metadata.
- [fidelity/2026-06-22-pivottable-style-fidelity.md](fidelity/2026-06-22-pivottable-style-fidelity.md) - PivotTable style fidelity pass covering modern Office theme style materialization, matrix header styling, visual harness dropdown rendering, and remaining visual disparities.
- [fidelity/2026-06-22-pivottable-button-placement-fidelity.md](fidelity/2026-06-22-pivottable-button-placement-fidelity.md) - PivotTable button placement fidelity pass covering native matrix headers, report-filter value-cell dropdown targets, and remaining button chrome disparities.
- [fidelity/2026-06-22-pivottable-group-fidelity.md](fidelity/2026-06-22-pivottable-group-fidelity.md) - PivotTable group fidelity pass covering native row-label indentation import, expand/collapse glyph rendering, grouped parent styling, and updated visual corpus evidence.
- [fidelity/2026-06-22-pivottable-source-sheet-visual-fix.md](fidelity/2026-06-22-pivottable-source-sheet-visual-fix.md) - PivotTable source-sheet/report-filter fidelity pass covering native cache source sheets and report-filter dropdown diagnostics.
- [fidelity/2026-06-22-pivottable-tabular-adornments.md](fidelity/2026-06-22-pivottable-tabular-adornments.md) - PivotTable tabular/outline row-label adornment pass covering native expand/collapse boxes outside compact layout.
- [fidelity/2026-06-22-pivottable-strict-visual-metrics.md](fidelity/2026-06-22-pivottable-strict-visual-metrics.md) - PivotTable strict visual metrics pass adding exact same-size pixel metrics alongside normalized visual diffs.
- [fidelity/2026-06-22-pivottable-native-style-offsets.md](fidelity/2026-06-22-pivottable-native-style-offsets.md) - PivotTable native style offset pass covering Excel `firstDataRow`/`firstDataCol` header and stripe footprint fidelity.
- [fidelity/2026-06-23-pivottable-theme-font-fidelity.md](fidelity/2026-06-23-pivottable-theme-font-fidelity.md) - PivotTable theme font and style fidelity pass covering loaded style font identity, shared-cache style ownership, `PivotStyleMedium2`/`PivotStyleDark3` palette correction, and local `Aptos Narrow` fallback rendering evidence.
- [fidelity/2026-06-23-pivottable-layout-group-visual-fidelity.md](fidelity/2026-06-23-pivottable-layout-group-visual-fidelity.md) - PivotTable layout/group visual pass covering repeated row-label gutter alignment, `PivotStyleMedium6` compact group fill, scale-once visual harness rendering, regenerated native Excel corpus evidence, and remaining geometry/text gaps.
- [fidelity/2026-06-23-pivottable-pause-resume.md](fidelity/2026-06-23-pivottable-pause-resume.md) - PivotTable pause/resume note covering the pushed Medium12 outline-style state, latest 16-case visual metrics, remaining typography/chrome gaps, and restart checklist.
- [fidelity/2026-06-23-pivottable-loaded-body-adornments.md](fidelity/2026-06-23-pivottable-loaded-body-adornments.md) - PivotTable loaded native body-surface and outline adornment pass covering white body materialization, `LastRenderedRange` adornment scans, 16-case visual evidence, and remaining typography/chrome gaps.
- [fidelity/2026-06-23-pivottable-outline-parent-style-fidelity.md](fidelity/2026-06-23-pivottable-outline-parent-style-fidelity.md) - PivotTable outline parent-row style pass covering loaded native outline group bands, 16-case visual evidence, and remaining text/chrome gaps.
- [fidelity/2026-06-23-pivottable-text-metrics-experiment-handoff.md](fidelity/2026-06-23-pivottable-text-metrics-experiment-handoff.md) - PivotTable pause handoff after reverted compact text-metrics and Medium13 border experiments, with resume targets and exact visual evidence paths.
- [fidelity/2026-06-23-pivottable-visual-metrics-json.md](fidelity/2026-06-23-pivottable-visual-metrics-json.md) - PivotTable visual harness pass adding machine-readable `metrics.json` output and a current 16-case native PivotTable metrics ranking.
- [fidelity/2026-06-23-pivottable-compact-label-fidelity.md](fidelity/2026-06-23-pivottable-compact-label-fidelity.md) - PivotTable compact row-label fidelity pause note covering child-label gutter reservation, 16-case visual deltas, evidence roots, verification, and remaining non-external gaps.
- [fidelity/2026-06-23-pivottable-medium13-tabular-style-fidelity.md](fidelity/2026-06-23-pivottable-medium13-tabular-style-fidelity.md) - PivotTable Medium13 tabular style pass covering loaded outer row-label bold/stripe styling, Medium13 body grid rules, 16-case visual deltas, and remaining non-external gaps.
- [fidelity/2026-06-23-pivottable-expand-collapse-chrome-fidelity.md](fidelity/2026-06-23-pivottable-expand-collapse-chrome-fidelity.md) - PivotTable expand/collapse chrome pass covering the 8 px outline box adjustment, 16-case visual deltas, rejected experiments, agent findings, and remaining non-external gaps.
- [fidelity/2026-06-23-pivottable-medium12-outline-style-fidelity.md](fidelity/2026-06-23-pivottable-medium12-outline-style-fidelity.md) - PivotTable Medium12 outline style pass covering loaded native outline parent, subtotal, and grand-total surfaces, 16-case visual deltas, and remaining typography/chrome gaps.
- [fidelity/2026-06-23-pivottable-medium13-body-fill-fidelity.md](fidelity/2026-06-23-pivottable-medium13-body-fill-fidelity.md) - PivotTable Medium13 body-fill fidelity pass covering banding stripe fill tint materialization and grand-total column fill behavior.
- [fidelity/2026-06-23-pivottable-aptos-narrow-font-fidelity.md](fidelity/2026-06-23-pivottable-aptos-narrow-font-fidelity.md) - PivotTable Aptos Narrow font fidelity pass covering Windows CloudFonts cache loading and per-style font identity alignment.
- [fidelity/2026-06-23-pivottable-aptos-narrow-fallback-metrics.md](fidelity/2026-06-23-pivottable-aptos-narrow-fallback-metrics.md) - PivotTable Aptos Narrow fallback metrics pass covering visual delta measurements with and without the CloudFonts font available.
- [fidelity/2026-06-23-pivottable-chrome-font-layer-fidelity.md](fidelity/2026-06-23-pivottable-chrome-font-layer-fidelity.md) - PivotTable chrome and font layer fidelity pass covering header chrome sizing, label layer rendering, and 16-case visual evidence.
- [fidelity/2026-06-23-pivottable-timeline-source-sheet-layout.md](fidelity/2026-06-23-pivottable-timeline-source-sheet-layout.md) - PivotTable timeline source-sheet layout pass covering timeline cache source sheet rendering and layout fidelity against native Excel corpus.
- [fidelity/2026-06-23-pivottable-timeline-visual-anchor-fidelity.md](fidelity/2026-06-23-pivottable-timeline-visual-anchor-fidelity.md) - PivotTable timeline visual anchor fidelity pass covering timeline slicer overlay placement and scroll anchor alignment.
- [fidelity/2026-06-23-pivottable-parity-session-results.md](fidelity/2026-06-23-pivottable-parity-session-results.md) - PivotTable parity session results covering completed style/chrome fixes, 16-case visual metrics ranking, and remaining non-external gaps.
- [fidelity/2026-06-23-pivottable-corpus-gap-pause-handoff.md](fidelity/2026-06-23-pivottable-corpus-gap-pause-handoff.md) - PivotTable corpus gap handoff covering remaining visual-corpus gaps, pushed state, and resume checklist.
- [fidelity/2026-06-23-linux-dialog-parity-pause-handoff.md](fidelity/2026-06-23-linux-dialog-parity-pause-handoff.md) - Linux/Avalonia dialog parity pause handoff covering chrome-alignment wave progress, pushed state, and outstanding dialog gaps.
- [fidelity/2026-06-24-pivottable-parity-continued.md](fidelity/2026-06-24-pivottable-parity-continued.md) - PivotTable parity continuation (waves 1–4, 2026-06-24) covering further style/chrome fixes against the 16-workbook native corpus and remaining non-external gaps.
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
- [reviews/comprehensive-code-review-2026-06-19.md](reviews/comprehensive-code-review-2026-06-19.md) - June 19 review iteration covering FreeW document fidelity, format cross-check behavior, and shared project wiring.
- [reviews/comprehensive-code-review-2026-06-19-iter2.md](reviews/comprehensive-code-review-2026-06-19-iter2.md) - June 19 review iteration covering Avalonia save/edit safety, command recalc contracts, save warnings, and structured-table totals.
- [reviews/comprehensive-code-review-2026-06-19-iter3.md](reviews/comprehensive-code-review-2026-06-19-iter3.md) - June 19 review iteration covering FreeW DOCX/editor outline behavior, Avalonia print/CUPS handling, and format-fidelity tooling.
- [reviews/comprehensive-code-review-2026-06-19-iter4.md](reviews/comprehensive-code-review-2026-06-19-iter4.md) - June 19 review iteration covering FreeW DOCX/editor fidelity, Avalonia file-operation safety, accounting command routing, and macOS readiness.
- [reviews/comprehensive-code-review-2026-06-19-iter5.md](reviews/comprehensive-code-review-2026-06-19-iter5.md) - June 19 review iteration covering document package fidelity, corpus validation, and format cross-check hardening.
- [reviews/comprehensive-code-review-2026-06-19-iter6.md](reviews/comprehensive-code-review-2026-06-19-iter6.md) - final June 19 review iteration; use with the cumulative review log for current review status.
- [reviews/comprehensive-code-review-2026-06-21-iter1.md](reviews/comprehensive-code-review-2026-06-21-iter1.md) - June 21 review iteration covering CI/main push coverage, format cross-check failure behavior, FreeW HTML vertical merges, and XLS metadata preservation.
- [reviews/comprehensive-code-review-2026-06-21-iter2.md](reviews/comprehensive-code-review-2026-06-21-iter2.md) - June 21 review iteration covering XLSX protection metadata, solution/workflow preflight coverage, FreeW MHTML/HTML import fidelity, and copy-sheet positioning.
- [reviews/comprehensive-code-review-2026-06-21-iter3.md](reviews/comprehensive-code-review-2026-06-21-iter3.md) - June 21 review iteration covering quoted workflow-trigger guards, FreeW DOCX package metadata preservation, and copy-sheet no-op follow-up scope.
- [reviews/comprehensive-code-review-2026-06-21-iter4.md](reviews/comprehensive-code-review-2026-06-21-iter4.md) - June 21 review iteration covering quoted YAML trigger-key guards, default test lane coverage, FreeW MHTML image metadata, and sheet-move no-op handling.
- [reviews/comprehensive-code-review-2026-06-21-iter5.md](reviews/comprehensive-code-review-2026-06-21-iter5.md) - June 21 review iteration covering quoted nested workflow triggers, review index guards, FreeW HTML/DOCX preservation fidelity, and sheet-tab command routing.
- [reviews/comprehensive-code-review-2026-06-21-iter6.md](reviews/comprehensive-code-review-2026-06-21-iter6.md) - June 21 review iteration covering block-list workflow triggers, review-log completeness, FreeW DOCX allocator guard coverage, and sheet-tab evidence wording.
- [reviews/comprehensive-code-review-2026-06-21-iter7.md](reviews/comprehensive-code-review-2026-06-21-iter7.md) - June 21 review iteration covering final workflow/docs and FreeW DOCX clean passes plus sheet-tab evidence wording cleanup.
- [reviews/comprehensive-code-review-2026-06-21-iter8.md](reviews/comprehensive-code-review-2026-06-21-iter8.md) - final June 21 no-findings validation for workflow/docs guards, FreeW DOCX allocator coverage, and sheet-tab evidence wording.
- [reviews/comprehensive-code-review-2026-07-01-iter1.md](reviews/comprehensive-code-review-2026-07-01-iter1.md) - July 1 subagent-assisted review covering core XLSX/ODS/formula data integrity, WPF workbook-window workflows, FreeW Save As format selection, corpus provenance, and preflight coverage.
- [reviews/command-icon-audit-2026-05-30.md](reviews/command-icon-audit-2026-05-30.md) - proposal-only command icon audit.
- [reviews/command-icon-review-2026-05-29.md](reviews/command-icon-review-2026-05-29.md) - prior SVG command-icon audit.
- [reviews/command-icon-visual-consistency-2026-05-30.md](reviews/command-icon-visual-consistency-2026-05-30.md) - visual-consistency review for command artwork.
- [reviews/performance-review-2026-05-28.md](reviews/performance-review-2026-05-28.md) - May 28 UI performance review, measurements, and remaining bottlenecks.

## History

- [history/status-2026-08-08.md](history/status-2026-08-08.md) - current status snapshot covering the next tester release candidate off main, FreeP/FreeW/Avalonia maturation since 2026-06-24, and release posture.
- [history/status-2026-06-24.md](history/status-2026-06-24.md) - prior status snapshot covering the next tester release candidate off main, current workbook/document file-format surface, and release posture.
- [history/status-2026-06-21.md](history/status-2026-06-21.md) - prior status snapshot covering the v0.8.127 tester release, current format support, promotion blockers, and hygiene rules.
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
- [history/build-history-metrics.md](history/build-history-metrics.md) - generated build-history and provider-log metrics, regenerated periodically (currently through 2026-08-09) by `tools/Build-ProjectHistoryMetrics.ps1`; token columns aggregate per-machine `project-history-tokens-<MachineId>.json` extracts from `.metrics-data/` across all contributing machines.
- [history/thread-commit-timing.md](history/thread-commit-timing.md) - historical generated first-parent thread timing report with commit counts, discovery offsets, implementation spans, and integration lags.
- [history/implementation-plan.md](history/implementation-plan.md) - historical formula/XLSX implementation plan retained for context.
- [archive/superpowers/](archive/superpowers/) - historical implementation plans and specs; not current build-status documentation.

## Visual Assets

- Current runtime command artwork lives in `src/FreeX.App.Host/Resources/CommandIconsSvg/`.
- [icon-audit/freex-icon-audit-2026-06-18.md](icon-audit/freex-icon-audit-2026-06-18.md) is the durable generated icon-audit summary; generated HTML/JSON tables are local artifacts and should be regenerated, not committed.
- [icon-audit/freew-icon-audit-2026-06-19.md](icon-audit/freew-icon-audit-2026-06-19.md) is the durable FreeW generated icon-audit summary; generated HTML/JSON tables are local artifacts and should be regenerated, not committed.
- Historical UI screenshot evidence is no longer checked in under `docs/ui-test-artifacts`; keep new screenshots there only when they are current review evidence and referenced by [testing/ui-test-catalog.md](testing/ui-test-catalog.md).
- The obsolete generated PNG icon review set was removed. Use the SVG command-icon reviews and source assets above for future icon work.
