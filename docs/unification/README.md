# FreeFamily Unification Program

> **Status:** the `unification-program` branch has been merged into `main` and deleted (all phases below landed
> on `main`; the branch no longer exists as of this writing). This document is kept as the historical record
> of the program's principles and phase-by-phase execution.
> **Goal:** Maximise what is shared and kept consistent across a growing family of sister apps (FreeX = spreadsheet, FreeW = word processor, more to come) so that divergent codebases do **not** accumulate regressions and technical debt.

## Why this program exists

Shared-tier value scales **linearly** with the number of apps (each shared component is reused N times). Divergence cost scales **super-linearly** — every pair of apps can drift, and every regression can recur independently in each copy. With a growing family, "share aggressively by default" is the correct posture. The open questions are only:

1. **What genuinely generalises** vs. what is real domain difference (do not force-unify the latter).
2. **What is currently taxing the sharing we already do** (and removing that tax).

This branch is the deliberate, documented execution of that, kept separate from `main` so the team can A/B the unified approach against the current stable build before adopting.

## Current shared spine (already healthy)

<!-- VERIFY: table below reflects the June 2026 program snapshot (7 projects). As of this audit (2026-08-08)
     `shared/` has grown to 19 csproj — it now also includes Free.Shared.Ribbon.Avalonia, Free.Shared.Shell.Avalonia,
     Free.Shared.Theme(.Wpf/.Avalonia), Free.Shared.Drawing, Free.Shared.Localization, Free.Shared.Pdf(.Skia/.Wpf) —
     added by later sessions after this doc's last edit. Re-run `Glob shared/**/*.csproj` for the current list
     before treating this table as exhaustive. -->

Seven shared projects under `shared/` as of the program's initial phases, with a clean portable/Windows split and **no domain leakage, nothing "shared in name only."** FreeX, FreeW, and (later) FreeP consume them.

| Project | TFM | Role |
|---|---|---|
| `Free.Shared.Commands` | `net10.0` | Generic undo/redo engine (`UndoRedoStack<TCommand,TPayload>`) |
| `Free.Shared.Opc` | `net10.0` | OOXML/zip file-format helpers (XML normalize, password, size guard) |
| `Free.Shared.AppServices` | `net10.0` | Neutral app services: document state, recent files, autosave, status-bar model, diagnostics store, settings persistence (`JsonSettingsStore<T>`), path planning, share readiness |
| `Free.Shared.Ribbon` | `net10.0` | Declarative ribbon model + adaptive layout engine + command/state seams |
| `Free.Shared.Ribbon.Wpf` | `net10.0-windows` | WPF realization: ribbon renderer, QAT, **BackstageFrame**, ShellChrome, dialogs |
| `Free.Shared.Shell` | `net10.0` | Portable backstage/recent-file/export planners + shell-string seams (P3 split: now WPF-free) |
| `Free.Shared.Shell.Wpf` | `net10.0-windows` | WPF shell realizers: dialog focus/sizing/button-row, message-box helper, image-dimension decoder, window-layout geometry |

Pattern in use throughout: **neutral model (POCO/planner) + thin per-platform renderer**, with interface seams (`IRibbonRenderer`, `IUserMessageService`, `IBackstageStrings`, `IApplicationDataPathProvider`, …) implemented once per host.

## Governance principles (how we avoid divergence)

1. **Neutral model + thin per-platform renderer** is the standard shape for any cross-app surface.
2. **The shared tier is always a _superset_.** Level the shared component *up* to the richest consumer; never level an app *down*. (Established when enriching `BackstageFrame` for FreeX's keytip/automation parity in Phase 0.)
3. **Assert behaviour / the automation tree, not source text.** Source-text "hygiene" tests pin structure as strings and make every shared migration a multi-file test rewrite. Prefer automation-id / behavioural assertions so sharing stays cheap.
4. **Contract tests at every seam.** Each app implements the host-side interface; a shared contract test verifies it, so a new app cannot silently break the contract.
5. **Share-first for cross-cutting concerns; app-specific only for genuine domain difference** (the core document models stay separate).

## Roadmap

Status legend: ✅ done · 🔄 in progress · ⬜ planned · 💤 deferred (wait for a 2nd consumer)

| # | Workstream | Value | Status |
|---|---|---|---|
| P0 | **Enrich `BackstageFrame`** to a superset (keytips, automation ids, tooltips, arrow-nav) | Unblocks FreeX adoption; FreeW richer for free | ✅ on `main` (`f15c176ac`) |
| P1 | **FreeX backstage rail → shared frame, _as the test de-brittling pilot_** | Shared rail across apps **+** proves automation-tree tests | ✅ on this branch (`b8cfbf685`, `0483c8015`) |
| P2 | **File-lifecycle planner** (Open/Save/SaveAs + dirty-prompt + recent registration) | Biggest dedup; app #3 gets file support in ~a day | ✅ shared planner + FreeW adoption on this branch (`7540fc21b`, `50add8dd0`) · **P2b** = FreeX decisions routed through the shared planner ✅ (`5a27f5661`) |
| P3 | **Split `Free.Shared.Shell`** into neutral (`net10.0`) + `.Wpf` (`net10.0-windows`) | Unblocks Avalonia/Linux/macOS reuse of the planners | ✅ on this branch (`a02b71194`) · **P3b** = the two `Rect`-returning planners neutralized (`ShellRect`) + moved to the portable tier ✅ |
| P4 | ~~Adopt `WorkbookDocumentState` in FreeW~~ (folded into P2 ✅); share **options persistence** (`JsonSettingsStore<T>` + FreeW options); **wire FreeW local diagnostics** | Removes hand-rolled dirty bool; gives FreeW settings + local crash files | ✅ on this branch (`7cd56ed3e`, `b5edd2070`, `1b34455c3`) · **P4b** = FreeX `AppOptionsStore` now sits on the shared `JsonSettingsStore<AppOptions>` ✅ |
| P5 | **Shared test-support package** + extract **screenshot-tour rendering harness** | App #3 doesn't reinvent test tooling | ✅ on this branch (`a3b388ee8`, `de1040b57`) · Part 1 = neutral source-extraction (`SourceTextTestSupport`), resx mechanics (`ResxResourceTestSupport`) + locator factories into the auto-linked `tests/SharedTestInfrastructure`, FreeX helpers re-homed as thin shims · Part 2 = screenshot render/crop/encode primitives → `Free.Shared.Ribbon.Wpf.ScreenshotCapture` (tour logic stays app-specific) |
| P6 | **"New sister app" scaffold** (shell + ribbon + file lifecycle + diagnostics pre-wired) | App #3 starts from the shared baseline, not a FreeX fork | ⬜ |
| — | Print/export orchestration · update/distribution · file associations | Real but premature | 💤 until a 2nd consumer exists |

**Keep app-specific (do NOT unify):** core document models (spreadsheet grid vs. word flow are genuinely different), format registries, spreadsheet-specific status stats, and each app's resx *content*.

## The biggest lever: de-brittle the tests

FreeX has ~3,530 lines across six `MainWindowSourceHygieneTests.*.cs` files plus ~164 `x:Name`/source-text assertions across ~30 test files that assert **exact source strings**. They don't test behaviour — they pin structure as text, so **every shared migration becomes a multi-file test rewrite.** FreeX already has the better pattern in-house (`UiAutomationCatalogSnapshotTests` assert the automation tree, rename/refactor-proof, reusable across apps). P1 converts the backstage-coupled subset as the pilot; the pattern then rolls out incrementally.

## How to compare against stable

<!-- VERIFY (historical): this section described the pre-merge A/B comparison workflow. The
     `unification-program` branch and its `.worktrees/unification` checkout no longer exist — the work is
     merged into `main`. Kept here for historical context on how the comparison was originally done. -->

- **Stable:** the main checkout at `…/FreeX` on branch `main`.
- **Unified:** this worktree at `…/FreeX/.worktrees/unification` on branch `unification-program`.

Both were independently buildable (`dotnet build FreeX.slnx -c Release`) and runnable, so the two backstage/shell experiences could be exercised side by side before the branch was merged into `main`.

See [LOG.md](LOG.md) for the per-phase execution record (what changed, verification results, decisions).
