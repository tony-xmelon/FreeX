# Unification Program — Architecture Roadmap

The north star and the remaining work to get there. Companion to `README.md` (principles) and
`LOG.md` (per-change execution record). Living document — updated as workstreams land.

## Vision

A family of sister apps — **FreeX** (spreadsheet), **FreeW** (word processor), **FreeP** (presentations),
and more — on **Windows, Linux, macOS**, where each app is, as close as feasible:

- a **thin renderer per platform** (WPF on Windows, Avalonia on Linux/macOS), plus
- a **per-app document model** (the genuinely app-specific part: cells+formulas / paragraphs+runs / slides+shapes),

over a **fat shared portable tier** that holds everything else — application logic
(planning/decision/validation/formatting), chrome (ribbon/backstage/dialogs/shell), document plumbing
(OPC packaging, properties, styling primitives, units), theming (design tokens), localization,
and cross-cutting services (undo, options, recent files, diagnostics, autosave, file-lifecycle,
print/export, update, file-associations).

Full purity is unattainable; get as close as feasible and stop where the cost exceeds the benefit
(genuine platform/domain divergence stays divergent).

## Strategic decision — renderer strategy: **DUAL THIN RENDERERS** (2026-06-23)

Keep **two** renderers — **WPF for Windows** (fidelity/perf) and **Avalonia for Linux/macOS** — and make
**both thin** by draining their logic into the shared portable tier. WPF is **not** retired. (Avalonia-primary
on all platforms was considered and declined for Windows-fidelity risk.) The dominant lever for every app:
**push logic out of both renderers into `*.App.Presentation` / `Free.Shared.*`** so each renderer shrinks
toward widget-tree mapping over one logic source.

## Where we are (updated 2026-06-25)

<!-- VERIFY: this snapshot is over 6 weeks stale as of 2026-08-08. FreeP in particular has grown far past
     "scaffold" — freep/ now has ~750 .cs files across 19 projects including FreeP.App.Avalonia (58 files),
     FreeP.App.Rendering.Avalonia, FreeP.App.Rendering.Wpf, FreeP.App.Recording(.Windows), FreeP.App.Ole.Windows,
     and shared/Free.Shared.Ribbon.Avalonia + Free.Shared.Shell.Avalonia now exist. Treat the table below as
     historical; re-audit against current freep/ and shared/ before relying on it. -->

| Dimension | FreeX (spreadsheet) | FreeW (word) | FreeP (slides) |
|---|---|---|---|
| Windows · WPF | mature | solid | scaffold |
| Linux/macOS · Avalonia | strong (dialog parity ongoing) | **substantial chrome + editing surface** | none yet |
| Shared-tier adoption | high | high | high (scaffold consumes it) |
| Applies shared theme | yes | yes | yes |
| Localization | one shared catalog (Win = Linux) | shared | shared |

Reality checks:
- **Shared tier now captures most non-rendering code.** A comprehensive cross-app audit (2026-06-25) confirmed
  the unification has been effective: file-lifecycle, ribbon model, backstage, theming, PDF, OPC, units,
  options, autosave, diagnostics, undo, localization are all shared. FreeP re-implements *nothing* — it
  consumes the shared tier out of the box.
- **FreeW Avalonia went from a 2.8k stub to a real shell** (this session): file lifecycle, backstage, side
  panes, page-layout + pagination + view modes — all consuming the portable `FreeW.App.Presentation` planners.
- **The remaining big gaps are feature build-out, not dedup**: FreeP's presentation domain (in active
  development by a dedicated session), and the deep Avalonia editing-surface fidelity (incremental).

## Workstreams

Status: done · in progress · blocked/contended · not started

### WS-A — Renderer thinning (long-haul, opportunistic) — in progress
Drain logic from the WPF + Avalonia renderers into the portable tier. The byte-level dedup is exhausted; the
remaining prize is disentangling logic from framework inside the big renderer files. Advanced opportunistically
as files are touched. FreeW's Avalonia editing surface (page layout/pagination/view modes) was built this
session as thin views over portable model APIs.

### WS-B — Portable tiers for FreeW & FreeP — done (FreeW) / via its session (FreeP)
`freew/FreeW.App.Presentation` stood up and all backstage/ribbon planners migrated; the portable backstage
records moved to `Free.Shared.Shell`. FreeW's Avalonia shell now consumes these planners. FreeP's portable
tier (`FreeP.App.Presentation` SlideCompositor) is being built by the FreeP-foundation session.

### WS-C — Shared document substrate — in progress
Landed: `FileFormatDescriptor` → `Free.Shared.IO`; OPC core/extended/custom property constants + W3CDTF →
`Free.Shared.Opc.OpcPackageProperties` (both ZIP-entry and PartName conventions); DrawingML/OOXML units
(EMU/dxa/points) → `Free.Shared.Opc.DrawingMlUnits`. Deferred (hot files): shared `CoreDocumentProperties`
(FreeW + FreeP doc-props), theme-color-scheme model. Future-high-value: the DrawingML/OPC/color overlap the
new FreeP IO opens up (shared color/geometry/package-walking across all three apps) — when FreeP settles.

### WS-D — Chrome completion — in progress
Ribbon, backstage, shell, dialogs, status bar are largely shared. FreeW Avalonia backstage built (app-specific,
mirroring FreeX). Remaining shared-Avalonia-chrome extraction is deferred until `FreeX.App.Avalonia` (dialog
parity) settles.

### WS-E — Neutralize FreeX-homed shared code — done
`PseudoLocalization` → `Free.Shared.Localization`. Localization fully converged into one shared superset
catalog (see below).

### WS-F — Platform leaves — in progress
Velopack update + file-associations shared (Windows). Linux/macOS leaves ongoing via the Avalonia work.

### WS-G — Theming (design tokens) — done
Built end-to-end this session. `Free.Shared.Theme` (token contract: 21 color roles + typography + metrics) +
WPF and Avalonia appliers + `BrandThemes.FreeX/FreeW/FreeP`. All three apps apply their own theme at startup;
all WPF chrome consumes tokens; the shared ribbon renderer is tokenized (neutral colors byte-identical
cross-app, accent per-app — FreeP's ribbon wears its brick brand). A Windows/Linux chrome typography+metrics
parity baseline is captured at `docs/parity/theme-token-baseline.md`. Reskinning is a `Theme`-object swap
(`FREEX_THEME=midnight` etc.). Remaining: migrate the last hardcoded colors as the contended chrome settles.

### Localization convergence — done (the Win = Linux fidelity fix)
FreeX-WPF and Avalonia previously used divergent catalogs (5,077 vs 1,701 keys; 43 vs 1 locales). Converged
onto **one shared superset catalog** in `FreeX.App.Localization` (6,401 keys + 43 locale satellites); Host
`UiText` reads it; Windows verified byte-identical by test; Linux gained ~3,376 keys + 42 locales. The dead
duplicate Host `.resx` files were removed.

## Active session map (2026-06-25)

<!-- VERIFY: this session-division snapshot is from 2026-06-25 and is stale as of the current audit
     (2026-08-08) — `unification-program` itself has since been merged into `main` and deleted, so "this
     session" and its "hot — do not edit" claim no longer apply. Kept for historical record of how work was
     divided at the time; do not use it to infer current session ownership. -->

Multiple sessions run in parallel over one OneDrive-shared `.git`. Division of labour:

| Session | Owns (hot — do not edit) |
|---|---|
| **Unification (this)** | shared tier, dedup, theming, localization, **FreeW Avalonia shell** |
| FreeW word-parity | `freew/FreeW.Core.*`, `freew/FreeW.App.Host/**` |
| FreeX dialog-parity / macOS | `src/FreeX.App.Avalonia/**`, FreeX dialog files |
| FreeP foundation | `freep/**` (pptx IO, compositor, WPF renderer, RenderCompare) |
| Shapes | `shared/Free.Shared.Drawing/**` (Geometry/ShapeGeometry port) |
| Code review | read-only |

## What's next (priority)

1. **FreeP's presentation domain** — the family's biggest gap; **actively owned** by the FreeP-foundation
   session (do not collide). The FreeP *Avalonia* renderer is the natural unification contribution once their
   compositor API stabilizes.
2. **Resume gated dedup as fields clear** — see `DEDUP-BACKLOG.md` for the verified, file:line-ranked
   candidates with per-item unlock conditions. Headliners: shared `CoreDocumentProperties` (B2) across all
   three `Core.IO` layers; finishing the `Free.Shared.Drawing` migration by deleting the un-deleted FreeX
   geometry originals (B3, ~633 LOC); cross-app color/EMU (B4); and residual adoption of the already-landed
   OPC helper substrate (B1) where app-local wrappers still duplicate `Free.Shared.Opc`.
3. **FreeW Avalonia polish** (incremental): rulers, deeper formatting fidelity.

The **safe, non-colliding dedup frontier is currently processed/empty** — remaining real dedup is owned by
active sessions and resumes as those fields clear (`DEDUP-BACKLOG.md` is staged to execute on the moment one does).

## Deferred alignment items (do when already touching the area)

- **Headless WPF dialog suppression audit.** File-command prompts are already service-injected in FreeX,
  FreeW, and FreeP through `IUserMessageService`; do not chase the old FreeW/FreeP file-command DI item.
  Remaining `HeadlessMessageBox.Handler` usage belongs to shared WPF dialog/test infrastructure and should be
  reduced only when a dialog-specific slice can prove a per-instance seam is cleaner than the current global
  test hook.

## Contention discipline

The repo is under OneDrive; many parallel worktrees share one `.git`. Always: work in a **fresh** worktree
(never the shared checkout), **never `git stash`**, commit by explicit path, verify `git ls-files | wc -l` > 0
before building, build with `-m:1`, push via fetch -> rebase -> `HEAD:main`, and **avoid files owned by an
active session** (see the session map). Adding a `freew.*` Avalonia ribbon command requires a matching
`{slug}.svg` asset + running `RibbonCommandIconAssetTests` (a non-incremental rebuild is needed for the asset
to propagate to test output).
