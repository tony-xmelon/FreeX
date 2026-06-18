# Unification Program — Execution Log

Newest entries first. Each phase records: what changed, how it was verified, and any decisions/gotchas.

---

## P2 — File-lifecycle planner (shared) + FreeW adoption — ✅ DONE (FreeX adoption = P2b, pending) (on `unification-program`)

**Commits:** `7540fc21b` (shared planner + tests), `50add8dd0` (FreeW adoption + WorkbookDocumentState).

**What changed.**
- **Shared `FileLifecyclePlanner`** (new `shared/Free.Shared.AppServices/FileLifecyclePlanner.cs`, `net10.0`, portable). Pure decisions, no WPF / no `Microsoft.Win32`:
  - **Dirty-gate** (before New/Open/Close): `PlanDirtyGate(isDirty) → DirtyGateIntent {ProceedWithoutPrompt | PromptSaveChanges}`, then `ResolveDirtyGate(SaveChangesPrompt {Save | DontSave | Cancel}) → DirtyGateAction {Cancel | SaveThenProceed | ProceedDiscardingChanges}`.
  - **Save-vs-Save-As resolution**: `PlanSave(isDirty, currentFilePath) → FileSaveIntent {UseExistingPath | PromptSaveAs | NothingToDo}` (never-saved always → PromptSaveAs; clean+path → NothingToDo).
  - **Recent registration**: `PlanRecentRegistration(path, suppressRecentFiles) → RecentFileRegistration {Register | Skip}`.
  - **Seams (host executes the I/O):** `IFileDialogService` with neutral `FileOpenRequest` / `FileSaveAsRequest` / `FileDialogResult` records; `FileDialogFilter.Build(...)` / `.DefaultExtension(...)` compose the Windows-style filter from per-app `FileFormatChoice(label, ext)` descriptors. Mirrors FreeX's existing `FileSavePlanner` / `WindowCloseDecisionPlanner` split, promoted to the shared tier (the FreeX ones stay in place until P2b retires them).
- **FreeW adoption** (`freew/FreeW.App.Host/FileCommands.cs` rewritten; `MainWindow.cs` Closing handler). `FileCommands` now drives New/Open/Save/SaveAs/Close through the planner; its hand-rolled `IsDirty` bool + `_currentPath` field are **replaced by the shared `WorkbookDocumentState`** (dirty flag, generation, current path). FreeW supplies the thin host side: native `OpenFileDialog`/`SaveFileDialog` over its single `.docx` `FileFormatChoice` (filter via `FileDialogFilter`), the existing `DocxReader`/`DocxWriter`, and WPF `MessageBox` seams for the 3-way Save/Don't&nbsp;Save/Cancel prompt + error messages. Public surface (`IsDirty`/`CurrentPath`/`DisplayName`/`MarkDirty`/`New`/`Open`/`OpenPath`/`Save`/`SaveAs`/`OpenSnapshot`/`RecentEntries`) is preserved, so `BackstageView` / `AutosaveCoordinator` / command bindings compile unchanged.
- **Behaviour win.** New/Open/Close now run the shared dirty-gate. FreeW previously dropped unsaved work without prompting; the window `Closing` handler now gates on a Save-before-close prompt and cancels the close if the user backs out (the autosave/recovery snapshot is only torn down once the close commits). Save resolves Save-vs-Save-As consistently with FreeX.

**Verification.**
- `dotnet build FreeX.slnx -c Release` clean (0 warnings / 0 errors; warnings-as-errors).
- **Shared planner tests:** `FreeX.App.Services.Tests` (the AppServices planner test project) **1155/1155** green — 29 new across `FileLifecyclePlannerTests` / `FileDialogFilterTests` / `FileDialogResultTests` (dirty→prompt, clean→skip, Save-existing vs Save-As fallthrough, recent registration, Cancel aborts, filter/record composition).
- **FreeW host tests:** `FreeW.App.Host.Tests` **71/71** green — 7 new in `FileLifecycleTests` covering the dialog-free paths (clean New, MarkDirty idempotence, OpenPath, Save→existing-path, clean-Save no-op, OpenSnapshot) over a live `DocumentView`+`FileCommands`, proving the `WorkbookDocumentState` adoption end-to-end.

**Decisions / notes.**
- The 3-way save-changes prompt needs Save/Don't&nbsp;Save/Cancel, which the shared `IUserMessageService.AskYesNo` can't express; FreeW keeps a small WPF `MessageBox.Show(YesNoCancel)` seam inside `FileCommands` rather than widening the shared interface. The planner returns the neutral `SaveChangesPrompt`; only the prompt rendering is host-local.
- The dialog-popping Open/SaveAs paths can't run headless, so FreeW tests cover the clean/existing-path flows; the prompt→action mapping is exhaustively covered by the shared pure-planner tests.
- **Follow-ups:** **P2b** = migrate FreeX's `OpenFileAsync`/`SaveButton_Click`/`SaveWorkbookWithDialogAsync`/`ConfirmSaveBeforeDestructiveActionAsync` onto the shared planner (its richer async/generation/multi-window path is already expressible — `WorkbookDocumentState.DirtyGeneration` + `SaveCompletionPlanner` slot in unchanged). The former **P4** "FreeW adopts `WorkbookDocumentState`" item is **folded into this pass** and done.

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
