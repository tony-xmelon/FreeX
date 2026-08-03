# Avalonia parity Wave125 integration

Date: 2026-08-03

## Integrated slices

- FreeX repaired the bounded Linux parity capture runner by overriding the interactive Docker image entrypoint, validating route-safe surface ids, requiring exact successful run markers, and cleaning only its uniquely named container.
- FreeX refreshed the current-source Avalonia `dialog.GoalSeekStatus` evidence. Its paired mean pixel difference improved from 3.255188% to 2.087108%, a 35.88% relative reduction.
- FreeW measured the four Legal Notices tabs. Subpixel antialiasing and geometry/font probes regressed or failed to improve every tab, so all product changes were reverted and the rejected measurements were retained as evidence.
- FreeP added document-level OMML `m:lMargin` and `m:rMargin` parsing and renderer-neutral layout behavior, including display-default gating, val-less defaults, overlay precedence, and overflow fallbacks shared by WPF and Avalonia.

## Evidence

- Dialog inventory remains 57/57 routes with WPF capture evidence, Avalonia capture evidence, an Avalonia harness route, and shared/presentation backing.
- Visual evidence remains 94/94 paired surfaces with no missing pairs, nonblank failures, expected-size mismatches, or stale promoted evidence.
- The regenerated highest dialog triage score is 0.087879, below the 0.4 review-prioritization threshold.
- The repaired Linux runner completed the Goal Seek Status capture in the exact container `freex-wave125-integration-goalseek-20260803` with `app_exit=0` and `capture_validated=true`.

## Focused verification

- FreeX parity capture tests: 4 passed.
- FreeP margin parsing and layout tests: 14 passed.
- FreeP WPF document-math-margin renderer test: 1 passed.
- FreeP Avalonia document-math-margin renderer test: 1 passed.
- FreeW Legal Notices visual tests: 12 passed; shared metrics test: 1 passed; fresh WPF/Avalonia evidence captures completed.
- Dialog visual summary and cross-app parity dashboard regenerated successfully.
- Repository preflight passed.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- The default non-UI lane completed TRX results for all 21 test projects: 36,270 discovered, 36,136 passed, 134 intentionally skipped/not executed, and zero failures, errors, timeouts, or aborts. The outer command reached its five-minute wrapper timeout after the last TRX completed; no worktree-scoped test process survived.

## Residuals

- FreeW Legal Notices retains platform text-rasterization and one-pixel content-registration differences. No measured candidate improved all four tabs, so no visual regression was accepted.
- The 24 raw dialog PNG dimension differences all remain normalized by capture DPI; there are zero scale-aware dimension mismatches.
