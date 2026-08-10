# FreeFamily Unification Program

> **Status (2026-08-10):** the foundational program has landed and the current renderer/workflow dedup
> campaign is still active at integrated checkpoint `42e6ca0ca5`. Dated execution evidence is in `LOG.md`;
> generated residual measurement still describes the older `ad82671328` checkpoint until final regeneration.
> **Goal:** maximize what is shared across FreeX (spreadsheet), FreeW (word processor), and FreeP
> (presentations), leaving WPF and Avalonia as thin native renderers over focused app workareas.

## Why this program exists

Shared-tier value scales **linearly** with the number of apps (each shared component is reused N times). Divergence cost scales **super-linearly** — every pair of apps can drift, and every regression can recur independently in each copy. With a growing family, "share aggressively by default" is the correct posture. The open questions are only:

1. **What genuinely generalises** vs. what is real domain difference (do not force-unify the latter).
2. **What is currently taxing the sharing we already do** (and removing that tax).

Share decisions, workflows, planners, sessions, resource mechanics, and cross-cutting services. Preserve
native widget construction and genuine document-domain behavior.

## Current shared spine (already healthy)

The current spine has 20 projects under `shared/`, split between portable contracts/planners and deliberately
thin WPF, Avalonia, Windows, and Skia realization packages. FreeX, FreeW, and FreeP all consume it. The seven
foundational projects are listed below; the later additions are `Free.Shared.AppServices.Windows`,
`Free.Shared.Drawing`, `Free.Shared.IO`, `Free.Shared.Localization`, `Free.Shared.Pdf` plus its WPF/Skia leaves,
`Free.Shared.Ribbon.Avalonia`, `Free.Shared.Shell.Avalonia`, `Free.Shared.TextSearch`, and `Free.Shared.Theme`
plus its WPF/Avalonia leaves.

| Project | TFM | Role |
|---|---|---|
| `Free.Shared.Commands` | `net10.0` | Generic undo/redo engine (`UndoRedoStack<TCommand,TPayload>`) |
| `Free.Shared.Opc` | `net10.0` | OOXML/zip file-format helpers (XML normalize, password, size guard) |
| `Free.Shared.AppServices` | `net10.0` | Neutral app services: document state, recent files, autosave, status-bar model, diagnostics store, settings persistence (`JsonSettingsStore<T>`), path planning, desktop URI launching, share readiness |
| `Free.Shared.Ribbon` | `net10.0` | Declarative ribbon model + adaptive layout engine + command/state seams |
| `Free.Shared.Ribbon.Wpf` | `net10.0-windows` | WPF realization: ribbon renderer, QAT, **BackstageFrame**, ShellChrome, dialogs |
| `Free.Shared.Shell` | `net10.0` | Portable backstage/recent-file/export planners + shell-string seams (P3 split: now WPF-free) |
| `Free.Shared.Shell.Wpf` | `net10.0-windows` | WPF shell realizers: dialog focus/sizing/button-row, message-box helper, image-dimension decoder, window-layout geometry |

Pattern in use throughout: **neutral model (POCO/planner) + thin per-platform renderer**, with interface seams (`IRibbonRenderer`, `IUserMessageService`, `IBackstageStrings`, `IApplicationDataPathProvider`, …) implemented once per host.

## Active campaign checkpoint

The continuation integrated through `42e6ca0ca5` adds shared desktop URI launching, OOXML protection hashing,
Legal Notices presentation, directional-arrowhead/WordArt policies, and further product-portable ownership:

- FreeX renderer integration and core spreadsheet policies, plus the first typed localized validation
  descriptors;
- FreeW pagination/border geometry and application-frame, document-properties, comment, style, and zoom
  workflow contracts; and
- FreeP canvas/table layout, Backstage/file lifecycle, pane/workarea semantics, and header/footer dialog state.

The campaign is not yet exhausted. The active audit still covers FreeX validation/semantic-text adoption,
FreeW equation/list/table-grid/heading/selection projection and adoption holes, and FreeP slideshow/media/OLE
orchestration plus remaining semantic projection. See the [dated campaign report](DEDUP-EXHAUSTION-2026-08-09.md)
for the exact verification ledger and residual categories.

## Governance principles (how we avoid divergence)

1. **Neutral model + thin per-platform renderer** is the standard shape for any cross-app surface.
2. **The shared tier is always a _superset_.** Level the shared component *up* to the richest consumer; never level an app *down*. (Established when enriching `BackstageFrame` for FreeX's keytip/automation parity in Phase 0.)
3. **Assert behaviour / the automation tree, not source text.** Source-text "hygiene" tests pin structure as strings and make every shared migration a multi-file test rewrite. Prefer automation-id / behavioural assertions so sharing stays cheap.
4. **Contract tests at every seam.** Each app implements the host-side interface; a shared contract test verifies it, so a new app cannot silently break the contract.
5. **Share-first for cross-cutting concerns; app-specific only for genuine domain difference** (the core document models stay separate).

## Foundational roadmap (historical)

Status legend: ✅ done · 🔄 in progress · ⬜ planned · 💤 deferred (wait for a 2nd consumer)

| # | Workstream | Value | Status |
|---|---|---|---|
| P0 | **Enrich `BackstageFrame`** to a superset (keytips, automation ids, tooltips, arrow-nav) | Unblocks FreeX adoption; FreeW richer for free | ✅ on `main` (`f15c176ac`) |
| P1 | **FreeX backstage rail → shared frame, _as the test de-brittling pilot_** | Shared rail across apps **+** proves automation-tree tests | ✅ on this branch (`b8cfbf685`, `0483c8015`) |
| P2 | **File-lifecycle planner** (Open/Save/SaveAs + dirty-prompt + recent registration) | Biggest dedup; app #3 gets file support in ~a day | ✅ shared planner + FreeW adoption on this branch (`7540fc21b`, `50add8dd0`) · **P2b** = FreeX decisions routed through the shared planner ✅ (`5a27f5661`) |
| P3 | **Split `Free.Shared.Shell`** into neutral (`net10.0`) + `.Wpf` (`net10.0-windows`) | Unblocks Avalonia/Linux/macOS reuse of the planners | ✅ on this branch (`a02b71194`) · **P3b** = the two `Rect`-returning planners neutralized (`ShellRect`) + moved to the portable tier ✅ |
| P4 | ~~Adopt `WorkbookDocumentState` in FreeW~~ (folded into P2 ✅); share **options persistence** (`JsonSettingsStore<T>` + FreeW options); **wire FreeW local diagnostics** | Removes hand-rolled dirty bool; gives FreeW settings + local crash files | ✅ on this branch (`7cd56ed3e`, `b5edd2070`, `1b34455c3`) · **P4b** = FreeX `AppOptionsStore` now sits on the shared `JsonSettingsStore<AppOptions>` ✅ |
| P5 | **Shared test-support package** + extract **screenshot-tour rendering harness** | App #3 doesn't reinvent test tooling | ✅ on this branch (`a3b388ee8`, `de1040b57`) · Part 1 = neutral source-extraction (`SourceTextTestSupport`), resx mechanics (`ResxResourceTestSupport`) + locator factories into the auto-linked `tests/SharedTestInfrastructure`, FreeX helpers re-homed as thin shims · Part 2 = screenshot render/crop/encode primitives → `Free.Shared.Ribbon.Wpf.ScreenshotCapture` (tour logic stays app-specific) |
| P6 | **"New sister app" scaffold** (shell + ribbon + file lifecycle + diagnostics pre-wired) | FreeP starts from the shared baseline, not a FreeX fork | done through FreeP adoption |
| - | Print/export orchestration, update/distribution, file associations | Cross-app workflow reuse | done where multiple consumers exist; native leaves stay platform-local |

**Keep app-specific (do NOT unify):** core document models (cells/formulas, paragraphs/runs, slides/shapes),
format-specific package semantics, product command/profile content, localized resx *content*, and native
widget/event/lifecycle code that contains no reusable decision.

## Test infrastructure

`tests/SharedTestInfrastructure` owns repository discovery, source readers, temporary-directory lifetime,
resource-catalog assertions, and other neutral test mechanics used by all three products. Architecture/source
guards remain where they defend an ownership boundary, but new tests should prefer behavior, session/planner
contracts, and automation output over pinning renderer implementation text.

## Visual comparison

For renderer-thinning campaigns, capture FreeX WPF parity from a clean `origin/main` worktree and the candidate
worktree with the same parity-capture manifest. Compare every PNG and the manifest before integration. This
is in addition to repository preflight, the Release solution build, the default test lane, the UI lane for
WPF changes, and the focused ribbon lane for adaptive-layout work.

Those final synchronized gates and the campaign candidate comparison are still pending at `42e6ca0ca5`.

See [LOG.md](LOG.md) for the per-phase execution record (what changed, verification results, decisions).
