# FreeFamily Unification Program

> **Branch:** `unification-program` (kept **unmerged** so it can be compared side-by-side against stable `main`).
> **Goal:** Maximise what is shared and kept consistent across a growing family of sister apps (FreeX = spreadsheet, FreeW = word processor, more to come) so that divergent codebases do **not** accumulate regressions and technical debt.

## Why this program exists

Shared-tier value scales **linearly** with the number of apps (each shared component is reused N times). Divergence cost scales **super-linearly** — every pair of apps can drift, and every regression can recur independently in each copy. With a growing family, "share aggressively by default" is the correct posture. The open questions are only:

1. **What genuinely generalises** vs. what is real domain difference (do not force-unify the latter).
2. **What is currently taxing the sharing we already do** (and removing that tax).

This branch is the deliberate, documented execution of that, kept separate from `main` so the team can A/B the unified approach against the current stable build before adopting.

## Current shared spine (already healthy)

Seven shared projects under `shared/`, with a clean portable/Windows split and **no domain leakage, nothing "shared in name only."** Both FreeX and FreeW already consume them.

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
| P2 | **File-lifecycle planner** (Open/Save/SaveAs + dirty-prompt + recent registration) | Biggest dedup; app #3 gets file support in ~a day | ✅ shared planner + FreeW adoption on this branch (`7540fc21b`, `50add8dd0`) · **P2b** = FreeX adoption pending |
| P3 | **Split `Free.Shared.Shell`** into neutral (`net10.0`) + `.Wpf` (`net10.0-windows`) | Unblocks Avalonia/Linux/macOS reuse of the planners | ✅ on this branch (`a02b71194`) · **P3b** = the two `Rect`-returning planners neutralized (`ShellRect`) + moved to the portable tier ✅ |
| P4 | ~~Adopt `WorkbookDocumentState` in FreeW~~ (folded into P2 ✅); share **options persistence** (`JsonSettingsStore<T>` + FreeW options); **wire FreeW local diagnostics** | Removes hand-rolled dirty bool; gives FreeW settings + local crash files | ✅ on this branch (`7cd56ed3e`, `b5edd2070`, `1b34455c3`) · FreeX `AppOptionsStore`→shared = follow-up |
| P5 | **Shared test-support package** + extract **screenshot-tour rendering harness** | App #3 doesn't reinvent test tooling | ⬜ |
| P6 | **"New sister app" scaffold** (shell + ribbon + file lifecycle + diagnostics pre-wired) | App #3 starts from the shared baseline, not a FreeX fork | ⬜ |
| — | Print/export orchestration · update/distribution · file associations | Real but premature | 💤 until a 2nd consumer exists |

**Keep app-specific (do NOT unify):** core document models (spreadsheet grid vs. word flow are genuinely different), format registries, spreadsheet-specific status stats, and each app's resx *content*.

## The biggest lever: de-brittle the tests

FreeX has ~3,530 lines across six `MainWindowSourceHygieneTests.*.cs` files plus ~164 `x:Name`/source-text assertions across ~30 test files that assert **exact source strings**. They don't test behaviour — they pin structure as text, so **every shared migration becomes a multi-file test rewrite.** FreeX already has the better pattern in-house (`UiAutomationCatalogSnapshotTests` assert the automation tree, rename/refactor-proof, reusable across apps). P1 converts the backstage-coupled subset as the pilot; the pattern then rolls out incrementally.

## How to compare against stable

- **Stable:** the main checkout at `…/FreeX` on branch `main`.
- **Unified:** this worktree at `…/FreeX/.worktrees/unification` on branch `unification-program`.

Both are independently buildable (`dotnet build FreeX.slnx -c Release`) and runnable, so the two backstage/shell experiences can be exercised side by side. This branch is **not merged** until the team signs off on the comparison.

See [LOG.md](LOG.md) for the per-phase execution record (what changed, verification results, decisions).
