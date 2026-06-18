# Unification Program — Execution Log

Newest entries first. Each phase records: what changed, how it was verified, and any decisions/gotchas.

---

## P1 — FreeX backstage rail → shared `BackstageFrame` (de-brittling pilot) — 🔄 IN PROGRESS

**Intent.** Replace FreeX's hand-rolled `StartScreenSidebar` (the backstage nav rail) with the shared, Phase-0-enriched `BackstageFrame`, hosting FreeX's existing content panes (`SsHomeView`/`SsInfoView`/`SsPrintView`) through the frame's `ContentFactory`. Simultaneously convert the backstage-coupled **source-text** hygiene tests to **automation-tree / behavioural** assertions — proving the de-brittling pattern (principle 3) on a real, bounded slice.

**Why this is the pilot.** The earlier scoping showed the migration's cost was dominated not by the rail swap but by the brittle source-assertion net (`MainWindowSourceHygieneTests.Backstage.cs` asserting literal `x:Name="StartScreenSidebar"`, handler names, etc.) and by production screenshot-tour code driving the rail by `x:Name`. Fixing those the right way (automation ids the frame already sets in P0) makes this and every future shared migration cheap.

**Scope guardrails.**
- Pane *internals* (the ~700 lines of XAML inside `SsHomeView`/`SsInfoView`/`SsPrintView`) and print rendering stay untouched — the frame owns rail + content-swap only.
- Preserve all keytips, automation ids, localized names, and accessibility behaviour (route them through `BackstageEntry`, which P0 made capable of carrying them).
- Reparent the existing pane elements into the frame's content host (a WPF element has one visual parent) — detach-from-parent helper required.

**Status:** implementation in progress on `unification-program`.

---

## P0 — Enrich `BackstageFrame` to a superset — ✅ DONE (on `main`)

Commit `f15c176ac` (merged to `main` before this branch was cut).

**What changed.** `BackstageEntry` gained six optional, null-defaulting properties (`KeyTip`, `AutomationId`, `AutomationName`, `AutomationHelpText`, `TooltipTitle`, `TooltipDescription`) on both `Pane()` and `Command()` — every existing FreeW call site compiles unchanged. `BackstageFrame.BuildNavButton` applies them null-guarded via `RibbonTooltip.Set*` + `AutomationProperties.Set*`. Added rail-gated arrow-key navigation (Up/Down/Home/End; Esc still closes).

**Verification.** `dotnet build FreeX.slnx -c Release` clean (0/0); `FreeW.App.Host.Tests` 64/64 (60 pre-existing + 4 new `SharedBackstageFrameTests`). FreeW rail unchanged (metadata-free entries render identically).

**Decision.** Levelled the shared frame *up* to FreeX's bar rather than levelling FreeX down — establishing governance principle 2. FreeW transparently gained keytip/automation support it didn't previously model.
