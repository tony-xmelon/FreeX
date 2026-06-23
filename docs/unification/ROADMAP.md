# Unification Program — Architecture Roadmap

The north star and the remaining work to get there. Companion to `README.md` (principles) and
`LOG.md` (per-change execution record). Newest strategic decisions are reflected inline.

## Vision

A family of sister apps — **FreeX** (spreadsheet), **FreeW** (word processor), **FreeP** (presentations),
and more — on **Windows, Linux, macOS** (and possibly more), where each app is, as close as feasible:

- a **thin renderer per platform** (WPF on Windows, Avalonia on Linux/macOS), plus
- a **per-app document model** (the genuinely app-specific part: cells+formulas / paragraphs+runs / slides+shapes),

sitting on top of a **fat shared portable tier** that holds everything else — application logic
(planning/decision/validation/formatting), chrome (ribbon/backstage/dialogs/shell), document plumbing
(OPC packaging, properties, styling primitives, units), and cross-cutting services (undo, options,
recent files, diagnostics, autosave, file-lifecycle, print/export, update, file-associations).

Full purity is unattainable; the goal is to get as close as feasible and stop where the cost exceeds
the benefit (genuine platform/domain divergence stays divergent).

## Strategic decision — renderer strategy: **DUAL THIN RENDERERS** (2026-06-23)

We keep **two** renderers — **WPF for Windows** (fidelity/perf, esp. the FreeX grid and FreeW FlowDocument
editor) and **Avalonia for Linux/macOS** — and make **both thin** by draining their logic into the shared
portable tier. We do **not** retire WPF. End state: two thin renderers over a fat shared portable tier.
(The alternative — Avalonia-primary on all platforms, retire WPF — was considered and declined for
Windows-fidelity risk. Revisit only if dual-renderer maintenance cost proves too high.)

The dominant lever under this strategy is the same for every app: **push logic out of the renderers
(WPF *and* Avalonia) into the portable `*.App.Presentation` / `Free.Shared.*` tiers**, so each renderer
shrinks toward pure widget-tree mapping.

## Where we are (measured 2026-06-23, LOC of `.cs`, excl. tests/obj/bin)

| Layer | FreeX | FreeW | FreeP |
|---|---|---|---|
| Shared tier `Free.Shared.*` | ~22k total, consumed by all three | ← | ← |
| Per-app domain `Core.*` | ~227k | ~25k | ~0.3k |
| Portable app logic `App.Presentation`+`App.Services` | ~48k | **~0.2k (new, this roadmap)** | none |
| WPF renderer `App.Host`(+`App.UI`) | ~144k | ~17k host | ~0.8k (scaffold) |
| Avalonia renderer `App.*.Avalonia` | ~58k | ~2.8k (stub) | none |

Reality checks:
- **FreeX's renderer is thick and doubled** — ~144k WPF + ~58k Avalonia implement the spreadsheet UI twice,
  against only ~48k portable. Most "rendering" code is logic-trapped-in-a-framework. This is the largest gap.
- **FreeW/FreeP have ~no portable tier** — FreeW logic is WPF-trapped; its Avalonia frontend is a 2.8k stub
  (effectively Windows-only). FreeP is a scaffold.
- **Chrome is genuinely shared already** (ribbon, backstage, shell, dialogs, PDF, file-lifecycle, options,
  diagnostics, undo) — the portable-tier pattern is proven by FreeX's `App.Presentation`.

## Workstreams

Status legend: ✅ done · 🟡 in progress · ⬜ not started · ⏸ blocked/deferred

### WS-A — Renderer thinning (dominant, multi-session)
Drain logic from FreeX's WPF (`App.Host`/`App.UI`, ~166k) **and** Avalonia (`App.*.Avalonia`, ~58k) into
`FreeX.App.Presentation`/`Free.Shared.*`, so both renderers become thin widget-tree mappers over one
portable logic source. The line-level dedup is exhausted; the remaining prize is **disentangling logic from
framework** inside the big renderer files (e.g. FreeW `DocumentView.cs` 8.2k, `FreeWRibbonCommands.cs` 4.5k;
FreeX grid/editor). Hard, entangled, incremental. ⬜

### WS-B — Portable tiers for FreeW & FreeP 🟡
Give FreeW and FreeP the `App.Presentation` split FreeX has, so they thin out and their cross-platform ports
don't re-duplicate a third copy. **FreeW:** an audit found only ~1k LOC cleanly portable today (the rest is
genuine WPF rendering — `DocumentView`, `FreeWRibbonCommands` — which is WS-A territory). Standing up the
tier + migrating the easy planners is the template.
- ✅ **Batch 1 (done):** created `freew/FreeW.App.Presentation` (pure net10.0) + `.Tests`; migrated 3 UI-free
  planners (`BackstageInfoSafetyPanePlanner`, `MailMergePreviewNavigationPlanner`, `CommentListPlanner`).
- ⬜ **Prerequisite for backstage planners:** move the portable records `BackstageFieldRow` /
  `BackstageActionGroup` / `BackstageActionRow` out of `Free.Shared.Shell.Wpf` into portable
  `Free.Shared.Shell` (they are pure data but Windows-homed today).
- ⬜ **Batch 2 (after prereq):** `BackstageAccountPanePlanner`, `BackstagePrintPanePlanner`, then
  `BackstageHomePanePlanner`, `BackstageOpenPanePlanner`, `BackstageSaveAsFileTypePlanner`,
  `BackstageSharePanePlanner`, `BackstageExportFileTypePlanner`; split `FreeWRibbonIcons.Resolve` (portable)
  from `.Install` (WPF), and `ScreenshotCapture.PngToInlineImage` (portable) from `CaptureRegionPng` (GDI).
- ⬜ **FreeP:** build its portable tier from the start as the presentation domain is implemented.

### WS-C — Shared document substrate ⬜
Lift common `Core.*` **plumbing** into shared, leaving only the app-specific models. Candidates: OPC packaging
(extend `Free.Shared.Opc`), document/core properties, styling primitives (font/color/fill/border), units/
measurement, undo/redo (✅ shared), autosave/recovery (✅ shared). Audit the three `Core.*` trees for the
common substrate vs genuine domain. Medium; central files — sequence carefully.

### WS-D — Chrome completion ⏸ (contended)
Finish shared dialogs + Avalonia backstage/chrome parity for FreeW/FreeP; status bar / QAT sharing.
**Currently worked by ~7 parallel `dialog-*`/macOS sessions — deferred here to avoid collision.**

### WS-E — Neutralize FreeX-homed shared code ⬜
Some shared code still lives under FreeX names (e.g. `PseudoLocalization` in `FreeX.App.Localization`).
Promote to neutral `Free.Shared.*` so FreeW/FreeP consume without a FreeX dependency. Small.

### WS-F — Platform leaves ⬜
Per-OS thin shims: file dialogs, fonts/DPI, native macOS menus, packaging/update (Velopack ✅ Windows),
file-associations (✅ Windows). Need Linux/macOS leaves. Small-medium, ongoing.

## Sequencing

WS-B / WS-C / WS-E are pure wins under the dual-thin-renderer strategy and don't collide with the active
`dialog-*`/macOS sessions — do these first. WS-D waits for the dialog sessions to settle. WS-A is the
long-haul background effort (disentangle logic from the big renderer files), advanced opportunistically as
each file is touched. The byte-level dedup frontier is exhausted (see `LOG.md` / memory) — the remaining
work is **structural** (extract tiers, share substrate), not line-for-line.

## Contention discipline

The repo is under OneDrive with many parallel worktrees sharing one `.git`. Always: work in a **fresh**
worktree (never the shared checkout), **never `git stash`**, commit by explicit path, verify
`git ls-files | wc -l` > 0 before building, build with `-m:1`, and avoid the hot `dialog-*` / `Free.Shared.IO`
/ macOS files while those sessions are active.
