# Unification Program — Execution Log

Newest entries first. Each phase records: what changed, how it was verified, and any decisions/gotchas.

---

## P1 — FreeX backstage rail → shared `BackstageFrame` (de-brittling pilot) — ✅ DONE (on `unification-program`)

**Commits:** `b8cfbf685` (impl), `0483c8015` (test de-brittling).

**What changed.**
- **Rail swap.** FreeX's hand-rolled `StartScreenSidebar` (~200 lines of XAML) is gone. The rail is now the shared `BackstageFrame`, built in new `src/FreeX.App.Host/MainWindow.BackstageFrame.cs` with all 12 entries carrying full FreeX metadata (keytips, automation ids/names/help, rich tooltips, command-icon names). The three content panes (`SsHomeView`/`SsInfoView`/`SsPrintView`) are kept verbatim, parked collapsed in a `StartScreenPaneHolder`; each pane entry's `ContentFactory` runs the pane's live-refresh and reparents the element (a `Detach` helper handles the single-parent rule). `MainWindow.Backstage.cs` `ShowStartScreen`/`HideStartScreen`/`Show{Home,Info,Print}View` now drive the frame; obsolete rail code (the `PreviewKeyDown` arrow handler, rail-button forwarders) was removed. Screenshot-tour code retargeted from `Ss*NavBtn.Focus()` to the frame API.
- **Shared frame API (additive, FreeW-safe).** `FocusEntry(automationIdOrLabel)` / `IsEntryFocused(...)`; `Show(...)`/`SelectPane(...)` accept a pane label OR automation id (language-invariant landing); `ConfigureBackButton(...)`; `DecorateNavButtons(...)` (lets FreeX mirror keytip/title/desc onto its own `RibbonTooltip` so its Alt-keytip overlay lights up the rail); `Divider(dockBottom)`; labels render via `AccessText` (FreeX mnemonics); Home/End focus the first/last rail button deterministically; focus helpers set focus-scope focus so focus lands off-foreground (tests).
- **Test de-brittling (the pilot).** New `BackstageRailHarness` opens a live MainWindow backstage and reads the rail's automation tree. `MainWindowXamlKeyTipTests.Backstage.cs` and the rail-coupled subset of `MainWindowSourceHygieneTests.Backstage.cs` converted from literal `x:Name`/handler-name source assertions to behavioural automation-id / keytip / pane-swap / focus assertions, intent preserved. Content-pane tests (Recent/Pinned, search, Info copy, progress footer, templates) and file-IO ceremony assertions left as source/XAML. `RibbonScreenshotTourPlannerTests` retargeted to the new frame API.

**Verification.**
- `dotnet build FreeX.slnx -c Release` clean (0 warnings / 0 errors; warnings-as-errors).
- `FreeW.App.Host.Tests` 64/64 (additive frame change confirmed non-breaking).
- `RibbonScreenshotTourPlannerTests` 85/85; all converted backstage tests green.
- Baseline diff (parent commit, identical to `main` modulo docs): **zero** backstage/rail/StartScreen tests fail on `unification-program`, and the baseline's one backstage failure (`CtrlP_RoutesThroughBackstagePrintEntryPoint`, source-text) is now **fixed** behaviourally. All residual `FreeX.App.Host.Tests` failures are pre-existing drift (ribbon SVG/parity/adaptive, docs/inventory, non-backstage source-hygiene) — several rooted in a **missing untracked `src/FreeX.App.Host/Resources/CommandIconsSvg` asset directory absent in both worktrees** — none introduced by P1.

**Gotcha recorded.** `Free.Shared.Ribbon.Wpf.RibbonTooltip` (set by the frame) and FreeX's `FreeX.App.Host.RibbonTooltip` (read by FreeX's keytip overlay) are *different* attached-property types — the frame's keytips must be mirrored onto FreeX's via `DecorateNavButtons` or the rail Alt-keytips go dark.

---

## P0 — Enrich `BackstageFrame` to a superset — ✅ DONE (on `main`)

Commit `f15c176ac` (merged to `main` before this branch was cut).

**What changed.** `BackstageEntry` gained six optional, null-defaulting properties (`KeyTip`, `AutomationId`, `AutomationName`, `AutomationHelpText`, `TooltipTitle`, `TooltipDescription`) on both `Pane()` and `Command()` — every existing FreeW call site compiles unchanged. `BackstageFrame.BuildNavButton` applies them null-guarded via `RibbonTooltip.Set*` + `AutomationProperties.Set*`. Added rail-gated arrow-key navigation (Up/Down/Home/End; Esc still closes).

**Verification.** `dotnet build FreeX.slnx -c Release` clean (0/0); `FreeW.App.Host.Tests` 64/64 (60 pre-existing + 4 new `SharedBackstageFrameTests`). FreeW rail unchanged (metadata-free entries render identically).

**Decision.** Levelled the shared frame *up* to FreeX's bar rather than levelling FreeX down — establishing governance principle 2. FreeW transparently gained keytip/automation support it didn't previously model.
