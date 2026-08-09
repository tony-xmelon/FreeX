# Unification Program — Execution Log

Newest entries first. Each phase records: what changed, how it was verified, and any decisions/gotchas.

---

## Dedup exhaustion campaign report - DRAFT (2026-08-09)

Refreshed the [dedup exhaustion report](DEDUP-EXHAUSTION-2026-08-09.md) through the final implementation
checkpoint and regenerated residual evidence. The last renderer extractions were FreeW table-border endpoint
projection (`50f48c1aca`), FreeP chart-marker geometry (`ba00a89312`), FreeP selection-adorner projection
geometry (`ec3faa3ee4`), and FreeP inline baseline placement (`3b149d3878`).

Upstream synchronization preserved or repaired shared ownership in `7f7506e5d0`, `5c56d0198c`, and
`8fc243fc79`; synchronized analysis commit `ad82671328` is the checkpoint recorded by residual-metrics commit
`fd07a9db50`. The current measurement covers 309,986 renderer code lines: 11,205 exact duplicate lines
(3.614679%), 11,963 normalized duplicate lines (3.859207%), and a campaign renderer delta of 26,618 additions
versus 63,352 deletions, net **-36,734 C# LOC**.

Final integration, synchronized build/test gates, and FreeX WPF visual parity remain explicitly **PENDING**
for the parent orchestrator. This documentation entry does not claim those results.

---

## FreeW/FreeP Avalonia shared shell frame - DONE (dedup slice)

**Branch:** `codex/dedup-avalonia-shell-frame-20260627`.

**Goal.** Create the first shared Avalonia shell/frame extraction for the simpler sister apps without touching
FreeX's larger Avalonia host.

**What changed.**

- Added `Free.Shared.Shell.Avalonia`, a small `net10.0` Avalonia-coupled shared project with
  `SisterAppClientFrameBuilder` and `SisterAppStatusBarChrome`.
- FreeW Avalonia now supplies its ribbon, document workarea, find bar, and status controls to the shared frame.
  The shared frame owns top-ribbon, bottom-status/find, and fill-workarea docking.
- FreeP Avalonia now supplies its ribbon, slide workarea, and status text to the same shared frame.
- Added focused FreeW/FreeP Avalonia guards proving the shell frame is used and preserving the headless
  MainWindow/ribbon/status construction shape.
- Solution wiring now lists the new shared shell project; preflight also required listing existing tracked
  FreeP rendering/generate-fixture projects and refreshing the generated dialog parity inventory.

**Deliberately left for a later slice.** No Avalonia startup runner was added; the current startup paths stay
app-owned. FreeX Avalonia remains untouched until a dedicated adoption pass can map its larger host surface.

**Validation.**

- `dotnet build FreeW.slnx --configuration Release` - clean, 0 warnings / 0 errors.
- `dotnet build FreeP.slnx --configuration Release` - clean, 0 warnings / 0 errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~MainWindowShellFrameTests|FullyQualifiedName~RibbonAndDocumentTests" --logger "trx;LogFileName=freew-avalonia-shell-frame.trx"` - 9/9 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~MainWindowHeadlessTests" --logger "trx;LogFileName=freep-avalonia-mainwindow-shell-frame.trx"` - 17/17 passed.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-RepositoryPreflight.ps1` - clean.

---

## Session 2026-06-24/25 — theming, localization convergence, dedup waves, FreeW Avalonia parity — ✅ DONE

A large multi-track session (all landed on `main`, gated green). Summary; details in memory + per-commit messages.

**Theming (WS-G) — built end-to-end.** New `Free.Shared.Theme` (token contract: `ThemeColor` ARGB, 21 semantic
color roles, typography, metrics) + `Free.Shared.Theme.Wpf`/`.Avalonia` appliers + `BrandThemes.FreeX/FreeW/FreeP`
(+`FreeXMidnight` demo). Rounds: foundation → title bar + status bar token-driven (one source → both renderers)
→ typography/metrics + **Win/Linux chrome parity baseline** (`docs/parity/theme-token-baseline.md`) → all FreeX
WPF chrome to `DynamicResource` → FreeW + FreeP apply themes + chrome consumes tokens → shared ribbon neutral
colors (byte-identical cross-app) → shared ribbon **accent per-app** (FreeP ribbon adopts brick brand). Reskin =
swap the `Theme` object (`FREEX_THEME=midnight`). Default look byte-identical throughout (verified by tests +
headless render PNGs).

**Localization convergence — the Win = Linux fidelity fix.** Host-WPF (5,077 keys, 43 locales) and Avalonia/Loc
(1,701 keys, 1 locale) were divergent catalogs. Converged onto ONE shared superset in `FreeX.App.Localization`
(6,401 keys + 43 satellites); Host `UiText` reads it; **Windows byte-identical (test-verified), Linux gained
~3,376 keys + 42 locales**; mnemonic `_` stays canonical (Avalonia strips). Dead duplicate Host `.resx` removed.

**Dedup waves.** Cross-app audit confirmed the shared tier already captures most non-rendering code. Landed:
`ConditionalFormat.Clone()` → Core.Model; `PivotFieldItemsReader` → Presentation + RibbonIcon perf guard;
shared help dialogs (`SharedAboutDialog`/`SharedLegalNoticesDialog`); `AppVersionFormatter` +
`SkiaPdfAvailabilityHelper`; `FileFormatDescriptor` → `Free.Shared.IO`; OPC property constants/W3CDTF →
`Free.Shared.Opc` (both slash conventions); **`DrawingMlUnits`** (EMU/dxa/points) → `Free.Shared.Opc`; FreeX
options onto shared `INormalizableApplicationOptions`; FreeW Avalonia `SidePaneBase`. Investigated + correctly
**declined** UiText→Loc collapse and RibbonMetadata collapse (genuine architectural divergence — NOT-DEDUP).

**FreeW Avalonia ↔ WPF parity (R1–R8).** Took FreeW's Avalonia shell from a 2.8k stub to a real shell, all as
thin views over the portable `FreeW.App.Presentation` planners + `FreeW.Core.Model` (no Host/Core edits):
file lifecycle (3-way save prompt + recent files + autosave w/ recovery), backstage File screen (8 planner-driven
panes), navigation pane (heading outline + search), reviewing pane (tracked changes + accept/reject), reveal-
formatting pane + full find/replace dialog, **print-layout chrome + multi-page pagination + Print/Web/Draft view
modes** (visually verified via a `FreeW.PageLayoutShot` headless render tool).

**Decisions/gotchas.** Dual-thin-renderer strategy confirmed. Adding a `freew.*` Avalonia ribbon command requires
a matching `{slug}.svg` asset + the Host `RibbonCommandIconAssetTests` gate (not in the Avalonia test run; asset
copy needs a non-incremental rebuild). Safe-dedup discipline: with many parallel sessions hot, the safe frontier
is processed/empty — remaining real dedup is owned by active sessions (shapes → Geometry; FreeP → DrawingML/OPC;
FreeW parity → ribbon/doc-props) and resumes as those fields clear.

---

## FreeX/Avalonia picture insertion placement planner — ✅ DONE (dedup slice)

**Branch:** `codex/picture-insertion-placement-dedup-20260623`; implementation commit message: `Share picture insertion placement planning`.

**Goal.** Make picture/object insertion placement a shared application-service decision instead of keeping one WPF-only planner plus an Avalonia-local copy of the same width/height fallback and command-building rules. The renderer should only decode native image dimensions; command placement should be common.

**What changed.**

- **New shared `PictureInsertionPlacementPlanner`** in `FreeX.App.Services`: normalizes optional native image dimensions, preserves the existing default picture size fallback, and delegates the final `InsertPictureCommandFactory.Build(...)` call. This makes "where and how large should this inserted picture be?" a shared rule for WPF, Avalonia, and future workareas.
- **WPF is now a thin renderer adapter.** `MainWindow.Drawing.cs` and screenshot-tour insert-object persistence keep the WPF-specific `ImageDimensionDecoder` boundary, then pass the decoded `PictureInsertionSize` into the shared planner. The WPF-only `InsertObjectPlacementPlanner` was removed.
- **Avalonia now uses the same planner.** `MainWindow.InsertObjects.cs` returns the same shared `PictureInsertionSize` model from its decoder and routes both Insert Picture and object placeholder/image flows through `PictureInsertionPlacementPlanner`, removing the Avalonia-local fallback/build duplication.
- **Tests moved to the shared layer.** The WPF-only planner tests became `FreeX.App.Services.Tests/PictureInsertionPlacementPlannerTests.cs`; the duplicate Avalonia `InsertPictureCommandFactory` tests were removed because the shared factory is already covered in `FreeX.App.Services.Tests`.

**What deliberately stayed platform/app-specific.** Native image dimension decoding, file/object picker UI, screenshot-tour orchestration, and command execution/refresh remain in their owning WPF or Avalonia layers. The shared planner owns only portable placement decisions and command construction.

**Verification.**

- `dotnet build FreeX.slnx --configuration Release`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build --logger "trx;LogFileName=default-tests-picture-placement-cd72.trx"`
- `dotnet test FreeX.UiTests.slnx --configuration Release --no-build --logger "trx;LogFileName=ui-tests-picture-placement-cd72-rerun.trx"`
- Combined current-main gate: 22,248 total / 22,062 passed / 0 failed / 186 skipped.
- WPF parity-capture comparison against the current `main` build before merge: 77 PNGs plus `manifest.json` on each side, 0 missing files, 0 hash differences.

**Decision / note.** This slice intentionally shares the command-planning rule without pulling renderer image APIs into shared code. That keeps the future sister-app contract narrow: provide optional native dimensions and the selected sheet/cell, then let shared services produce the insert command.

---

## P5 — Shared test-support (parameterized source/locator helpers) + screenshot-tour render primitives — ✅ DONE (on `unification-program`)

**Commits:** `a3b388ee8` (Part 1 — shared test-support), `de1040b57` (Part 2 — screenshot-tour render primitives).

**Goal.** Reduce the test tooling a future sister app would reinvent by promoting genuinely-reusable test infrastructure into the shared, auto-linked `tests/SharedTestInfrastructure/` (every `*.Tests` project — FreeX **and** FreeW — picks it up via the root `Directory.Build.targets`, zero csproj wiring). The principle followed throughout: **the read/extract/reflect/render *mechanics* are neutral and shared; the *which app / which file* concern stays with the caller via thin shims.**

### Part 1 (primary) — re-home the source-hygiene & localization *engines*

- **New `SourceTextTestSupport`** (WPF-free, no namespace, auto-linked). The neutral engine behind the source-hygiene tests: `ExtractBetweenMarkers(source, start, end)` (the "extract a C# method/region body" mechanic behind `ReadClassSource`), `ReadSources(reader, [sep,] files…)` (join over a caller-supplied reader), and the reflection walkers `GetPrivateField<T>` / `GetPrivateMethod` (walk the base-type chain).
- **New `ResxResourceTestSupport`** (WPF-free, auto-linked). Neutral resx/placeholder mechanics: `ReadResxValues(path | dir,file)`, `CompositePlaceholderTokens`, `AccessKeyCount`, `CountAsciiLettersOutsideCompositePlaceholders` (the `[GeneratedRegex]` composite-format/access-key patterns moved here verbatim).
- **`TestWorkspaceFileLocator`** (already shared) gained three neutral helpers: `SourceReaderRootedAt(projectRootParts)` — the "read a source file relative to a project root, locating it up the tree" reader **factory** (the engine behind per-app `ReadHostSource`); and `FindFileFromBaseDirectory` / `FindDirectoryFromBaseDirectory` — the base-directory walker the two per-app `RepositoryFileLocator` copies hand-rolled (preserving their exact `"Could not find repository file/directory '…'"` messages).
- **FreeX shims now delegate, behaviour unchanged:**
  - `DialogSourceTestSupport.ReadClassSource` → `ExtractBetweenMarkers`; `.GetPrivateField` → shared; `.InvokePrivateHandler` finds the method via `GetPrivateMethod` (the WPF `RoutedEventArgs` construction stays here); `.ReadHostSourcesWithSeparator` → `ReadSources`.
  - `LocalizationResourceTestSupport` is now a pure FreeX shim — `ResourceDirectory` (FreeX's `Resources/Strings.resx`) stays, the four measurement methods delegate to `ResxResourceTestSupport`. No longer `partial`/regex-bearing.
  - Both `RepositoryFileLocator` copies (`FreeX.App.Services.Tests` file-finder, `FreeX.App.Presentation.Tests` dir-finder) collapsed to one-line delegations.
- **Kept app-specific (correctly):** the **WPF-coupled** handler-invoke / button-click / mouse-event helpers in `DialogSourceTestSupport` (shared infra is auto-linked into portable **`net10.0`** test projects too — those files must stay WPF-free); and `LocalizedXamlTestSupport` (deeply FreeX-coupled — `UiText`, `{local:Loc}`, `local:RibbonMetadata.CommandName`).

### Part 2 (secondary) — screenshot-tour render primitives (DONE, cleanly separable)

The tour *logic* (what to render, foreground/focus guards, manifest schema) is FreeX-specific, but the render/crop/encode/write mechanics are generic and were cleanly separable without touching tour logic.

- **New `Free.Shared.Ribbon.Wpf.ScreenshotCapture`** (`public static`): `CaptureVisualToPngAsync(visual, dir, file, logicalHeight?)` (window/visual capture with optional crop-to-height), `CaptureElementToPngAsync(element, dir, file)` (VisualBrush element capture), `WritePngAsync`, `DeviceDpiScale`. Home chosen as `Free.Shared.Ribbon.Wpf` (already a FreeX+FreeW WPF dependency) rather than a new project, per the task's allowance.
- **FreeX delegates:** `MainWindow.CaptureCurrentWindowAsync` / `CaptureElementAsync` now call the shared helper; the FreeX foreground-focus **assertions stay in place** around the render. Both methods keep their **names + signatures**, so every tour call site — and the `RibbonScreenshotTourPlannerTests` that pin those call sites (`CaptureElementAsync(dialog, …)` etc.) — is untouched.

**Verification.**
- `dotnet build FreeX.slnx -c Release` **and** `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors), Part 1 and Part 2.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — **0 failures** (App.Services 1163, App.Host.Logic 1546+5skip, Presentation 988, Core.Model 3987, Core.Formula 2949, Core.IO 2633, Avalonia 439, Ribbon 465, Integration 78, Calc 784) — identical to the P2b baseline; the `RepositoryFileLocator`/Logic.Tests shim-linked helpers all resolve.
- **`MainWindowSourceHygieneTests` pass/fail set unchanged:** **157 pass / 10 fail** before == after; the 10 fails are the same pre-existing content-drift (ribbon-chart/border/pivot/draw/format-painter/number-format/arrange-all/startup-controller/live-e2e), none touching the re-homed engines. The 268 localization + `ObjectDialogTests` (which exercise `ResxResourceTestSupport` + `ExtractBetweenMarkers` through the shims) **all pass**.
- `RibbonScreenshotTourPlannerTests` **85/85**. `FreeW.App.Host.Tests` **81/81** (FreeW auto-links the two new shared files and compiles/passes).
- **Part 2 end-to-end smoke:** `FREEX_SHEET_TAB_TOUR=1` (element capture) and `FREEX_SS_TOUR=1` (window capture, crop-to-height) both ran with `FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER=1` and produced **fresh, valid PNG evidence** through the shared primitives (`screenshots/sheet-tabs-tour/*.png`, `screenshots/max_Home.png` / `max_Insert.png`). Tours throw + delete evidence on failure, so produced PNGs == working capture.
- Preflight `tools/Test-DotNetProjectReferences.ps1` (53 projects) ✅. No new projects/solutions (Part 1 = files into existing auto-linked dir; Part 2 = one file into an existing shared project), so no `.slnx` edits needed.

**Decisions / notes.**
- **No BAIL on Part 2.** It was cleanly separable — the inner primitives touch only WPF types, no FreeX tour/`MainWindow` state — so the extraction was surgical (two method bodies → shared calls) with the guards left intact.
- **Worktree discipline:** all edits under `.worktrees/unification`; the main checkout was never touched.

---

## P2b — FreeX file-lifecycle DECISIONS via shared `FileLifecyclePlanner` — ✅ DONE (on `unification-program`)

**Commit:** `5a27f5661`.

**What changed.** P2 promoted FreeX's file-lifecycle *decision* ceremony to the shared, portable `FileLifecyclePlanner` and adopted it in FreeW. P2b routes FreeX's own file-IO decisions through the same shared planner — making it the single source of decision truth across both apps — while preserving FreeX's richer *mechanics* (async open-with-progress, dirty-generation tracking, multi-window close, unsupported-feature warnings, adapter resolution) exactly. This used the **thin-adapter pattern at the decision points**, not a call-site rewrite:

- **Dirty-gate (New / Open / Close).** `MainWindow.WorkbookLifecycle.cs` `ConfirmSaveBeforeDestructiveActionAsync` now makes its two decisions through the shared planner: the "is the document dirty → prompt?" decision is `FileLifecyclePlanner.PlanDirtyGate(_workbookDirty)`, and the Save/Don't-Save/Cancel answer mapping is `FileLifecyclePlanner.ResolveDirtyGate(prompt)`. FreeX still owns the WPF `ShowOwnedMessage` prompt and maps `MessageBoxResult` → the neutral `SaveChangesPrompt`; the planner's `DirtyGateAction` maps back to FreeX's `SaveChangesConfirmation` (Continue / DiscardWithoutSaving / Cancel). The method **signature, name, and return type are unchanged**, so all three call sites (New/Open via `OpenFileAsync`, Close via `MainWindow_Closing`) are untouched.
- **Save-vs-Save-As resolution.** Extracted a small `SaveResolvedAsync()` helper whose branch decision is the shared `FileLifecyclePlanner.PlanSave(_workbookDirty, _currentFilePath)`: no usable path (or no save-capable adapter) → Save-As dialog; otherwise save to the existing path. FreeX's adapter-resolving `FileSavePlanner.TryResolveExistingPath` remains the **mechanism** that produces the concrete `FileSaveTarget(path, adapter)`. Both the dirty-gate's "Save then proceed" branch and `SaveButton_Click` (`MainWindow.Backstage.cs`) now call this one helper, removing a duplicated existing-path-vs-dialog branch and routing the Save command through the shared decision too.
- **Recent-files registration.** Both registration sites in `MainWindow.Backstage.cs` — after Open (`OpenFileAsync`, honouring `suppressRecentFiles` for recovery snapshots/templates) and after a save commits (`SaveWorkbookToTargetAsync`, inside the `SaveCompletionPlanner` `ApplyFileContext` block) — now gate the MRU write on `FileLifecyclePlanner.PlanRecentRegistration(path, suppressRecentFiles)`. The `_recentFiles.AddOrUpdate(...)` store write stays FreeX-specific.

**What stayed FreeX-specific (mechanics, not decisions).** `FileSavePlanner` (adapter resolution + path-normalized clean-save skip via `CanSkipCleanSave`) and `WindowCloseDecisionPlanner` (the "edits arrived mid-async-save → stay open" re-check). These are genuinely richer than the shared planner and live in `FreeX.Core.IO` / `FreeX.App.Host` respectively; `FreeX.Core.IO` does **not** reference `Free.Shared.AppServices`, so pulling the shared planner down into it would have meant a new project reference policed by the dependency/portability guards — out of proportion to the win. The decision dedup lives entirely in the App.Host layer, which already references and globally imports `Free.Shared.AppServices`, so **no csproj changes** were needed.

**No shared-planner extension required.** FreeX's needs (`PlanDirtyGate` / `ResolveDirtyGate` / `PlanSave` / `PlanRecentRegistration`) were already fully expressible by the P2 planner — nothing additive, so FreeW is logically untouched (re-verified green regardless).

**Tests — de-brittled, intent preserved.** `MainWindowSourceHygieneTests.Backstage.cs`:
- `FileNewSaveSaveAsAndClose_RouteThroughDirtyPromptAndOwnedMessages`: the `ConfirmSaveBeforeDestructiveActionAsync` assertions that pinned the old inline `TryResolveExistingPath`/`SaveWorkbookWithDialogAsync` text now assert the **decision routing** (`PlanDirtyGate` / `ResolveDirtyGate` / `DirtyGateAction.* => SaveChangesConfirmation.*`) plus the `SaveThenProceed => await SaveResolvedAsync()` delegation; the moved Save-vs-Save-As resolution is asserted against the new `SaveResolvedAsync` (`PlanSave == PromptSaveAs`, `TryResolveExistingPath`, dialog/target fallthrough). `SaveButton_Click` is asserted to delegate to `SaveResolvedAsync`. Intent — "the dirty-gate prompts then saves/discards, and Save resolves existing-path-vs-dialog" — is preserved, now pinned to the shared decision rather than inlined mechanics.
- `BackstageSaveAs_ForcesSaveDialogInsteadOfExistingPathSave`: line that incidentally matched the old `SaveButton_Click`'s `await SaveWorkbookWithDialogAsync();` text was retargeted to assert against the `SaveAsButton_Click` method body itself (`await SaveWorkbookWithDialogAsync()` and **not** `SaveResolvedAsync`) — same intent (Save As forces the dialog, never the existing-path save), no longer coupled to an unrelated method's wording.
- While in this test, corrected a **pre-existing stale pin** (`CreateNewWorkbook();` → `InitializeNewWorkbook(_newWorkbookNameSequence.Next());`) that had `FileNewSaveSaveAsAndClose` failing at baseline for a reason unrelated to P2b; the test is now genuinely green and actually exercises the P2b assertions.

**Verification.**
- `dotnet build FreeX.slnx -c Release` and `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors).
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — **0 failures** (App.Services **1163**, App.Host.Logic 1546+5skip, Core.Model 3987, Core.Formula 2949, Core.IO 2633, Avalonia 439, Presentation 988, Ribbon 465, Integration 78, Calc 784). The decision planner suites green explicitly: `FileLifecyclePlannerTests`/`FileDialogFilterTests`/`FileDialogResultTests` **29**, `FileSavePlannerTests` **22**, `WindowCloseDecisionPlannerTests` **12**.
- `FreeX.App.Host.Tests` (the environmental-failure project, not in DefaultTests.slnx) — `MainWindowSourceHygieneTests` failing-set went **12 → 10** (fixed `FileNewSaveSaveAsAndClose` + kept `BackstageSaveAs` green; **0 new** failures). The remaining 10 are the same pre-existing ribbon/chart/border/pivot/draw/format-painter/number-format/arrange-all/startup-controller/live-e2e drift, none file-IO related.
- `FreeW.App.Host.Tests` **81/81** green.
- **Functional smoke:** `FREEX_FILE_BACKSTAGE_WORKFLOWS_TOUR=1 FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER=1 FreeX.App.Host.exe` → **exit 0**, evidence retained (10 PNGs + manifest under `screenshots/file-backstage-workflows-tour/`: New, Open recent/pinned/filtered, Save, Save-As native-dialog guard, saved + reopened title/path, Print preview, Export). The tour throws and deletes evidence on any failure, so produced evidence == the real New/Open/Save/Save-As/Export file IO works end-to-end through the rerouted decisions.

**Decisions / notes.**
- **Thin-adapter, not call-site rewrite** (per the task's preferred approach): the planner became the decision source of truth by rewriting the *bodies* of `ConfirmSaveBeforeDestructiveActionAsync` and the recent-registration inlines, leaving the call sites the source-hygiene tests pin intact. The one new helper (`SaveResolvedAsync`) is a small refactor that *removed* a duplicated branch rather than adding churn.
- **No BAIL.** Behaviour is preserved exactly; test churn was clean de-brittling (3 assertions retargeted + 1 stale pin corrected), well within the P1 pilot pattern — not the "invasive rewrite" the bail condition guards against.

---

## P4b — FreeX `AppOptionsStore` on shared `JsonSettingsStore` — ✅ DONE (on `unification-program`)

**Commit:** `e92736d8e`.

**What changed.** P4 flagged FreeX's `AppOptionsStore` (`src/FreeX.App.Services/AppOptionsStore.cs`) as duplicating the generic JSON load/serialize/atomic-write/error-capture plumbing that P4 promoted to the shared `JsonSettingsStore<T>`. This pass retires that duplication while **preserving FreeX behaviour exactly**:

- `AppOptionsStore.LoadFromPath` / `SaveToPath` now delegate the I/O to the shared `JsonSettingsStore<AppOptions>.LoadFromPath` / `SaveToPath` statics. The hand-rolled `try/File.Exists/Deserialize/catch` and `try/AtomicFileWriter/Serialize/catch` bodies (plus the local `JsonSerializerOptions`) are gone — the shared store already does exactly that (safe load → fresh default; atomic write via `AtomicFileWriter`; never-throw exception capture).
- **FreeX-specific behaviour stays in `AppOptionsStore`:** the `options.json` store-path resolution (`AppStoragePathPlanner` / `FREEX_OPTIONS_PATH`), the `AppOptions.NormalizePersistedCollections()` step (run on every successful load and before every save, as before), surfacing failures via `AppOptions.SetPersistenceError(...)` (cleared on a successful save), and the user-facing **"options"** wording.
- **The only shared-tier change:** `JsonSettingsStore<T>.LoadFromPath` / `SaveToPath` gained an **optional `noun` parameter (default `"settings"`)** so a caller can read `"Failed to load/save options from/to '…'"` instead of the generic `"settings"` wording. Purely additive — every existing shared/FreeW call site is untouched and the shared store's own tests still assert the `"settings"` default.

**Why it was safe (the message-text + normalization risk P4 called out).** The risk was the tests asserting exact `"Failed to load/save **options**"` text and the inline `NormalizePersistedCollections`. The `noun` parameter preserves the message text verbatim, and normalization stays inline in `AppOptionsStore` (load-success and pre-save), so no FreeX option test needed rewriting — the adaptation is thin, not a behaviour change. (One benign nuance: the shared `LoadFromPath` doesn't distinguish "file missing" from "loaded a value," so `NormalizePersistedCollections` now also runs on the fresh default returned for a missing file; that is provably a no-op since `new AppOptions()` is already in normalized form.)

**Verification.**
- `dotnet build FreeX.slnx -c Release` and `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors).
- `FreeX.App.Services.Tests` **1163/1163** green — including all 6 `AppOptionsStoreTests` (missing/future-schema load, corrupt→defaults+`"Failed to load options"`+path, blocked-write→`"Failed to save options"`+path+temp-cleanup, atomic-save-clears-error round-trip) and the 7 `JsonSettingsStoreTests` (still asserting the `"settings"` default).
- `FreeXOptionsPersistenceTests` (App.Host.Tests) **22/22** green — the host-level "Failed to load/save options" assertions hold.
- `FreeWOptionsTests` **6/6** green — the additive shared-store signature change didn't disturb FreeW's store façade.

---

## P3b — Neutralize the two Rect-based Shell planners (now portable) — ✅ DONE (on `unification-program`)

**Commit:** `653b59f9a`.

**What changed.** P3 had to classify `WindowResetPositionPlanner` and `SideBySideLayoutPlanner` into `Free.Shared.Shell.Wpf` even though they are "pure geometry," because they returned `System.Windows.Rect` (a WindowsBase/WPF type). This pass finishes the job so they live in the portable tier:

- **New neutral record `ShellRect`** in portable `Free.Shared.Shell` (`shared/Free.Shared.Shell/ShellRect.cs`): `readonly record struct ShellRect(double X, double Y, double Width, double Height)` with `Left`/`Top` aliases that mirror `Rect`'s member names (so existing `.Left`/`.Top`/`.Width`/`.Height` call sites and tests read unchanged). Named `ShellRect` (not `LayoutRect`) deliberately — `FreeX.App.Presentation.Charts` already has an unrelated `LayoutRect`, so a distinct name avoids confusion.
- **Both planners MOVED** `shared/Free.Shared.Shell.Wpf/` → `shared/Free.Shared.Shell/` and retargeted to return `ShellRect` instead of `System.Windows.Rect`. Namespace stays `Free.Shared.Shell`, so consumers churn by zero `using`s. The `.Wpf` copies were `git rm`'d.
- **Consumer churn is minimal.** `MainWindow.MultiWindow.cs` `ViewResetWindowPositionBtn_Click` reads `.Left/.Top/.Width/.Height` off the planner result — works unchanged on `ShellRect`. `WorkbookWindowRegistry.EnableSideBySide` feeds `SideBySideLayoutPlanner.Tile` results into the WPF-typed `IWorkbookWindow.TileToWorkArea(Rect)` seam, so it now constructs `new Rect(r.X, r.Y, r.Width, r.Height)` at that one WPF boundary (the only conversion needed). `IWorkbookWindow.TileToWorkArea` keeps its `Rect` signature, and `ArrangeAllLayoutPlanner` (which is FreeX-app-local, **not** shared) keeps returning `Rect` — both out of scope.
- `FreeX.App.Host` already referenced portable `Free.Shared.Shell` and globally imports its namespace; the planner tests (`FreeX.App.Host.Logic.Tests`) carry a global `<Using Include="Free.Shared.Shell" />`, so both resolve the moved types transitively with no edits.

**Verification.**
- `dotnet build shared/Free.Shared.Shell/Free.Shared.Shell.csproj -c Release` → `bin/Release/net10.0/`, **0/0**. `deps.json` grep for `PresentationCore|WindowsBase|PresentationFramework|System.Windows` → **zero hits**; the portable Shell stays WPF-free.
- `dotnet build FreeX.slnx -c Release` and `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors).
- `FreeX.App.Host.Logic.Tests` (the planner tests): the 10 `WindowResetPositionPlannerTests` + `SideBySideLayoutPlannerTests` **green**; full project **1546/1546** (5 skipped benchmarks), identical to the P3 baseline.
- `ViewCommandSourceTests`: `ViewWindowLiveHandlers_RouteThroughRegistryAndWindowLayoutPlanners` (asserts the `WindowResetPositionPlanner.Compute(...)` + `EnableSideBySide(...)` routing) **passes**. The sibling `ViewWindowHandlers_RouteThroughExpectedPlannersAndCommands` fails — confirmed **pre-existing drift**, not a P3b regression: it asserts `AutomationProperties.SetHelpText(button, description)` in `MainWindow.ViewCommands.cs`, a file P3b never touched and which does not contain that string.

---

## Visual validation follow-up — rail icons + content inset FIXED — ✅

Both diffs the visual comparison surfaced are now resolved; re-captured Home/Info/Print on the rebuilt unified app match stable.

- **Rail icons (the regression).** Root cause: two separate `RibbonIconFactory` classes — FreeX's own (`FreeX.App.Host`, loads branded `CommandIconsSvg`, used by the ribbon) and the shared one (`Free.Shared.Ribbon.Wpf`, used by `BackstageFrame`). The shared one exposes a `CommandIconElementResolver` hook *designed* for app artwork, but **FreeX never installed it**, so the rail fell back to geometric `RibbonCommandIconKind` glyphs. Fix: added `FreeX.App.Host.RibbonIconFactory.TryCreateCommandIconElement` (returns the branded SVG element, or **null** for unskinned commands so the shared geometry fallback is preserved — surgical) and wired it into `Free.Shared.Ribbon.Wpf.RibbonIconFactory.CommandIconElementResolver` in `App_OnStartup`. Recursion-safe (FreeX's factory never calls the shared one). Bonus: any shared chrome FreeX hosts (QAT, …) now reuses the same Office icons. The two `RibbonTooltip` types remain distinct (handled separately by `DecorateNavButtons`).
- **Content inset.** Added `BackstageFrame.SetContentPadding(Thickness)` (default stays `(40,28,40,28)` for FreeW's padding-less code-built panes); FreeX sets it to `0` because its reparented XAML panes carry their own insets — so content lands exactly where the hand-rolled rail had it (greeting back at ~x233/y95, matching stable).

Verified: `FreeX.App.Host` Release clean (0/0); backstage/rail tests **75/75**; Home + Info + Print visually match stable (branded icons, aligned content). Follow-ups P1-icons / P1-inset closed.

---

## Visual validation — stable (`origin/main`) vs unified backstage — ⚠️ ONE REGRESSION FOUND (now fixed, see above)

Built both Release from isolated worktrees (stable `0d67746d2`, unified `fa87b738e` — both **0 warnings / 0 errors**; the shared main checkout itself couldn't be built due to another session's `MSB3021` file lock — contention, not a code issue). Ran FreeX's `FREEX_BACKSTAGE_TOUR` + `FREEX_FILE_BACKSTAGE_WORKFLOWS_TOUR` (background-render) on each and compared Home/Info/Print states.

- ✅ **Rail structure identical** across all states: order, labels, selection band, bottom-docked Account/Options, greeting, Recent/Pinned, New tile, recent list.
- ✅ **Pane hosting via `ContentFactory` is pixel-faithful** — Info pane and even the heavy **Print** pane (reparented `DocumentViewer` + live page preview) render with no clipping/breakage. The core migration mechanic (reparent existing XAML panes) is visually de-risked, including the hardest pane.
- ⚠️ **REGRESSION — rail icons.** Stable shows FreeX's branded per-command SVG icons (house/folder/printer/person/gear); unified shows the shared frame's generic geometric `RibbonCommandIconKind` glyphs (grid/cylinder/rectangle/chevron). Cause: shared `BackstageFrame.BuildIcon` builds its own `RibbonIcon` from `RibbonCommandIconKind` and ignores FreeX's `CommandName→CommandIconsSvg` resolution. **Fix:** add a host icon seam to the frame (e.g. `Func<BackstageEntry,UIElement> iconFactory` / `DecorateNavButtons`-style hook) so FreeX supplies its branded icons — aligns with the superset principle. Follow-up P1-icons.
- ⚠️ **Minor — content inset.** Unified pane content sits ~27px lower / slightly more inset (shared frame content `Margin(40,28,40,28)` vs FreeX's original). Cosmetic; tune the frame content margin. Follow-up P1-inset.

---

## P3 follow-up — revert unused Avalonia→Shell reference (guard green) — ✅ FIXED

The `AvaloniaProjectPortabilityGuardTests` failure that P4 logged as "pre-existing" was in fact a **P3 regression**: P3 added a *speculative, unused* `Free.Shared.Shell` ProjectReference to `FreeX.App.Avalonia` "to prove portability," which trips the guard's deliberate **exact-ordered** reference allow-list. Portability is already proven structurally (P3's deps.json check: `Free.Shared.Shell` builds as `net10.0` with zero WPF), so the correct fix is to **remove the unused reference** rather than weaken the architectural tripwire. Avalonia will reference the portable Shell planners when it actually consumes them (a future workstream), updating the allow-list alongside real usage. `FreeX.App.Avalonia` rebuilds clean; guard test **4/4**. Branch is now green except the known environmental `FreeX.App.Host.Tests` failures (untracked `CommandIconsSvg` asset + worktree workspace-file source-scanners), which are identical on `main`.

---

## P4 — Shared `JsonSettingsStore<T>` (FreeW options) + FreeW local diagnostics — ✅ DONE (on `unification-program`)

**Commits:** `7cd56ed3e` (shared store + tests), `b5edd2070` (FreeW options), `1b34455c3` (FreeW diagnostics).

**Note on the former P4 item.** "FreeW adopts `WorkbookDocumentState`" was **already folded into P2** (`50add8dd0`) and is done — FreeW's hand-rolled `IsDirty` bool + `_currentPath` are the shared `WorkbookDocumentState`. This pass delivered the remaining two P4 items: shared **options persistence** and **FreeW diagnostics**.

**A) Shared options persistence.**
- **New `shared/Free.Shared.AppServices/JsonSettingsStore<T>`** (`net10.0`, no WPF). Generic JSON persistence for any settings POCO (`where T : class, new()`):
  - **Safe load** — missing file → fresh default (no error); corrupt/unreadable file → fresh default **and** an observable `LastError` (never throws).
  - **Atomic save** — through the existing `AtomicFileWriter` (sibling temp file + replace); returns false + `LastError` on failure, never throws; clears `LastError` on success.
  - **Product-rooted path** — `ForProductFile(fileName, pathProvider?, overridePath?)` derives `{appDataDir}/{AppProduct.Current.ProductDirectoryName}/{fileName}`, so the path respects whatever `AppProduct` the host installed (e.g. `%APPDATA%\FreeW\settings.json`). `ForPath(...)` for explicit/test paths. Static `LoadFromPath` / `SaveToPath` for one-shot use.
  - Factored from FreeX's `AppOptionsStore` (the same load/serialize/atomic-write/error-capture shape), promoted to the shared tier — **not duplicated**.
- **Public shape:** `JsonSettingsStore<T>.ForProductFile(...)` / `.ForPath(...)` → instance with `StorePath`, `LastError`, `T Load()`, `bool Save(T)`; plus statics `GetProductFilePath`, `(T,string?) LoadFromPath`, `string? SaveToPath`.
- **Proven in FreeW.** New app-specific `FreeWOptions` POCO (`RecentFilesCap`, `DefaultSaveFormat`, `UiLanguage` placeholder, with a `Normalize()` that clamps the cap and trims) + a thin `FreeWOptionsStore` façade over `JsonSettingsStore<FreeWOptions>` (file name `settings.json`, post-load normalize). `Program.Main` loads the options once at startup (after installing `AppProduct = "FreeW"`) and passes them into `MainWindow(FreeWOptions)` → `FileCommands`. **Real read site:** `FileCommands.SetSaved` now applies `FreeWOptions.RecentFilesCap` when registering a recent file. To make that possible without changing FreeX behaviour, `RecentFilesStore.AddOrUpdate` gained an **optional `maxRecentEntries` overload** (default = existing `MaxRecentEntries`, so FreeX is untouched); pinned entries are always retained.

**B) FreeW local diagnostics (file-store only, no Sentry).**
- `AppProduct.Current = "FreeW"` was already set in `Program.Main` (verified FreeW-correct: storage/diagnostics resolve `%LOCALAPPDATA%\FreeW`, not FreeX).
- New `FreeWDiagnostics` mirrors FreeX's `AppDiagnostics` **minus Sentry/`ICrashAnalytics`**: `CreateDefault(appVersion)` builds an `AppDiagnosticsFileStore` over `AppDiagnosticsOptions.CreateDefault()` (honours `FREEW_DIAGNOSTICS=0`) + `AppDiagnosticsMetadata.Create(version)`; `RecordEvent`/`RecordCrash` are best-effort wrappers; `RegisterCrashHandlers()` hooks `DispatcherUnhandledException` + `AppDomain.UnhandledException` + `TaskScheduler.UnobservedTaskException`. `Program.Main` registers handlers after the `Application` exists, records `app_start` before showing the window and `app_exit` after `Run`. App version comes from the entry assembly's `AssemblyInformationalVersion` (FreeW has no `AppInfo`).

**Verification.**
- `dotnet build FreeX.slnx -c Release` and `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors).
- **Shared store tests** (`tests/FreeX.App.Services.Tests`): **7 new** `JsonSettingsStoreTests` (load-missing→defaults, save→load round-trip, corrupt→defaults+error, blocked-write→error, product-path derivation, override-path, error-clearing) + **1 new** `RecentFilesStoreTests` cap-overload test. Project **1162/1163 pass**; the single fail is the **pre-existing** `AvaloniaProjectPortabilityGuardTests` (a stale P3 allow-list missing `Free.Shared.Shell`, which P3 legitimately added to `FreeX.App.Avalonia`) — confirmed failing identically with P4 stashed, **not introduced here** (flagged as a follow-up chip).
- **FreeW host tests** (`FreeW.App.Host.Tests`): **71 → 81** (+6 `FreeWOptionsTests`, +4 `FreeWDiagnosticsTests`; + a `FreeW` `AppProductTestDefaults` module-initializer so the shared path planner resolves the FreeW footprint). `dotnet test FreeW.slnx -c Release --no-build` all green: Core.Model 600, App.Host 81, Avalonia 17, **Core.IO 301** (the P3-flaky DOCX-IO test passed cleanly this run).
- **FreeX.DefaultTests.slnx** — no new failures vs baseline; only red is the same pre-existing `AvaloniaProjectPortabilityGuardTests`.

**Decisions / notes.**
- **FreeX `AppOptionsStore` was left as-is** (NOT refactored onto the shared store this pass). Its `Load`/`Save` call `AppOptions.NormalizePersistedCollections()` inline and its tests assert specific message text ("Failed to load/save **options**" vs the shared store's "settings"); sitting it on `JsonSettingsStore<AppOptions>` would either change that behaviour or force a multi-test rewrite — higher risk than the win. **Follow-up:** retire the duplication by having `AppOptionsStore` delegate to the shared store and folding the normalize step into a `Save`/`Load` hook, with the FreeX option tests updated to match.
- The model stays app-specific (`FreeWOptions` is FreeW's own); only the persistence is shared, per governance principle 5.
- FreeW does **no** remote telemetry — Sentry is FreeX-specific and was deliberately not pulled in.

---

## P3 — Split `Free.Shared.Shell` into portable (`net10.0`) + `.Wpf` (`net10.0-windows`) — ✅ DONE (on `unification-program`)

**Commit:** `a02b71194` (extract + retarget + consumers/solutions; docs in a follow-up commit).

**What changed.** `Free.Shared.Shell` was a single `net10.0-windows10.0.19041.0` (WPF-locked) project mixing pure planners with `System.Windows`-coupled helpers, so the Avalonia/Linux/macOS ports couldn't reuse the planners. Split by actual compiler dependency:

- **`Free.Shared.Shell` retargeted `net10.0-windows10.0.19041.0` → `net10.0`** (dropped `UseWPF`). Confirmed **WPF-free**: `dotnet build shared/Free.Shared.Shell/Free.Shared.Shell.csproj -c Release` emits to `bin/Release/net10.0/` and its `deps.json` has **zero** `PresentationCore`/`WindowsBase`/`System.Windows` references; its only ProjectReference is the already-portable `Free.Shared.AppServices` (net10.0). **8 portable types stayed:**
  - `BackstageRecentFileListPlanner` (+`BackstageRecentFileListPlan`), `BackstageGreetingFormatter`, `BackstageProgressOverlayPlanner`, `BackstageTabSelectionPlanner`, `IBackstageStrings`, `IShellStrings` (+`DefaultShellStrings`/`ShellStrings`), `PlannerPathHelpers`, `ExportAtomicWriter` (internal).
- **New `Free.Shared.Shell.Wpf`** (`net10.0-windows10.0.19041.0`, `UseWPF`, ProjectReference → portable `Free.Shared.Shell`; csproj mirrors `Free.Shared.Ribbon.Wpf` conventions). **9 WPF-coupled types moved**, namespaces kept stable (`Free.Shared.Shell`) so consumers churn by one ProjectReference, not a rename:
  - `DialogFocus`, `DialogButtonRowFactory`, `DialogSizing`, `DialogMessageHelper` (internal; uses `MessageBox`/`Window` + reads portable `ShellStrings.Current`), `StatusDialogKeyboardFocus`, `ComboBoxTextEditingExtensions`, `ImageDimensionDecoder` (WPF `BitmapDecoder`), `WindowResetPositionPlanner`, `SideBySideLayoutPlanner`.
  - **Surprise worth noting:** `WindowResetPositionPlanner` and `SideBySideLayoutPlanner` are described in code as "WPF-free … pure geometry," but they return `System.Windows.Rect` (WindowsBase/WPF), so they are *not* portable as written. Classified to `.Wpf` rather than refactored — promoting them later only needs swapping `Rect` for a neutral `(double X, double Y, double W, double H)` record. Logged here so a future pass can finish the job.
  - `InternalsVisibleTo` (`FreeX.App.Host`, `FreeX.App.Host.Tests`, `FreeX.App.Host.Logic.Tests`) lives on **both** projects: the portable one for `ExportAtomicWriter`, the `.Wpf` one for `DialogMessageHelper`.

**Consumers + solutions.**
- `FreeX.App.Host` gained a ProjectReference to `Free.Shared.Shell.Wpf` (heavy user of the WPF helpers). Its two test projects (`FreeX.App.Host.Tests`, `FreeX.App.Host.Logic.Tests`) resolve the WPF types **and** internals **transitively** through `FreeX.App.Host` — no direct edit needed; the unqualified `using Free.Shared.Shell;` keeps resolving across both assemblies.
- `FreeW.App.Host` was left referencing **only** the portable `Free.Shared.Shell` — it uses just `ShellStrings`/`DefaultShellStrings`, none of the WPF helpers. (FreeW being WPF/`net10.0-windows` referencing a `net10.0` project is fine.)
- **Portability proven:** `FreeX.App.Avalonia` (`net10.0`) now references the portable `Free.Shared.Shell` and builds clean — the planners are demonstrably reusable from the Avalonia port (not yet *consumed*, per task scope). `FreeW.App.Avalonia` left untouched; the portable planners are equally available to it.
- Added `Free.Shared.Shell.Wpf` to **`FreeX.slnx`** and **`FreeW.slnx`** (the only `*.slnx` listing `Free.Shared.Shell`; the FreeX test slnx files list test projects only and pull shared transitively, unchanged).

**Verification.**
- `dotnet build FreeX.slnx -c Release` and `dotnet build FreeW.slnx -c Release` — both **clean, 0 warnings / 0 errors** (warnings-as-errors).
- `dotnet build shared/Free.Shared.Shell/Free.Shared.Shell.csproj` — net10.0, no WPF (see above).
- Preflight: `tools/Test-DotNetProjectReferences.ps1` (53 projects) ✅ and `tools/Test-SolutionProjects.ps1 -SolutionPath FreeX.slnx` (42 entries) ✅. (`Test-SolutionProjects` against `FreeW.slnx` "fails" pre-existingly — it discovers all FreeX `src/tools` projects repo-wide and expects them in whatever solution it's pointed at; it is a FreeX-only check, unrelated to P3.)
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — **all green, 0 failures** (identical to baseline: App.Services 1155, App.Host.Logic 1546, Core.Model 3987, Core.Formula 2949, Core.IO 2633, Avalonia 439, Presentation 988, Ribbon 465, Integration 78, Calc 784).
- `dotnet test FreeW.slnx -c Release --no-build` — Model 600, App.Host 71, Avalonia 17 green; one **flaky** `FreeW.Core.IO.Tests` fail that **passed 301/301 on isolated re-run** and at baseline — a DOCX-IO test with zero Shell dependency, not a P3 regression.
- **`FreeX.App.Host.Tests` before/after failing-set diff (the rigorous check):** this project carries ~161 **pre-existing** environmental failures (ribbon-SVG/`CommandIconsSvg` missing-asset drift + source-hygiene tests that throw `FileNotFoundException: Could not locate workspace file`). Captured the unique failing-test-name set at baseline (P3 stashed, project rebuilt) vs with P3, identical invocation: **161 == 161, `Compare-Object` → 0 new, 0 fixed.** The moved-type tests (`DialogSizingTests`, `DialogFocusTests`) fail only on the workspace-file harness issue, not on any type/assembly resolution; there are **zero** TypeLoad/FileLoad errors. **P3 introduces no new failures.**

**Decisions / notes.**
- Kept namespaces at `Free.Shared.Shell` across both assemblies (governance: minimise consumer churn) — a consumer adds a second ProjectReference and existing `using`s keep working.
- Did not refactor the two `Rect`-returning planners into the portable tier this pass (noted above as a cheap follow-up).
- The portable Shell is now available to both Avalonia apps; only `FreeX.App.Avalonia` carries the reference today (proof-of-portability), wiring up actual consumption is out of P3 scope.

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
