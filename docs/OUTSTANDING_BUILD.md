# FreeX Outstanding Build List

**Last updated:** 2026-05-31
**Basis:** reviewed the repository Markdown files, cross-checked the active codebase under `src/` and `tests/`, and confirmed the current branch/worktree maintenance snapshot. Updated after production-readiness pass (PRs #45–#48) and the 2026-05-30 comprehensive source review ([CODE_REVIEW_COMPREHENSIVE_2026-05-30.md](CODE_REVIEW_COMPREHENSIVE_2026-05-30.md)), which verified the entire `src/` tree (967 files / ~178 KLOC), confirmed all 17 findings from the 2026-05-28 review are resolved, and recorded a small residual code-quality backlog (see below).

This is the current source-of-truth backlog for features still outstanding to build. Older planning docs are useful historical context, but several items they list as future work are now implemented.

## Current Code Baseline

Confirmed present in code and tests:

- Core spreadsheet shell, command bus, undo/redo, virtualized WPF grid, multi-sheet UI, native/CSV/XLSX adapters.
- Formula engine at 345/345 in-scope functions with catalog guards and category-focused Excel parity tests. This includes modern lookup/dynamic-array functions (`XLOOKUP`, `XMATCH`, `SEQUENCE`, `RANDARRAY`, `FILTER`, `SORT`, `SORTBY`, `UNIQUE`, `TAKE`, `DROP`, `CHOOSEROWS`, `CHOOSECOLS`, `VSTACK`, `HSTACK`, `TOROW`, `TOCOL`, `WRAPROWS`, `WRAPCOLS`, `EXPAND`), higher-order formulas (`LET`, `LAMBDA`, `MAP`, `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, `MAKEARRAY`), statistical distributions, financial bond/depreciation helpers, database functions, `HYPERLINK`, discrete engineering base/bit functions, locale-specific text helpers (`ASC`, `DBCS`, `PHONETIC`, `BAHTTEXT`), and local web-text helpers (`ENCODEURL`, `FILTERXML`). Formula hardening now includes Excel cached-result fixtures, inverse/round-trip property tests, dynamic-array error/volatility edge guards, and structured-reference current-row/spaced-header coverage; remaining formula work is ongoing parity proof as new edge cases are discovered (see `docs/FUNCTION_PARITY.md`).
- Spill infrastructure and formula AST caching in recalculation.
- Formula reference rewriting for insert/delete/paste/autofill paths.
- Autofill drag UI and `AutofillCommand`; Flash Fill command/service baseline.
- Sort/filter, Advanced Filter copy-to replacement semantics, Text to Columns, Remove Duplicates, Data Validation, Consolidate, Goal Seek, Scenario Manager, Forecast Sheet, one- and two-variable Data Tables, Subtotal, grouping/outline.
- Conditional formatting model/UI for cell-value, formula, top/bottom/above-average, color scales, icon sets, and advanced data-bar dialog options including min/max length, gradient, border, axis, and negative colors.
- Page layout, page setup, print/export, custom views, workbook/theme commands, chart/object/theme baselines.
- Slicer/timeline metadata, authored state, pane controls, cache relationships, native floating drawing-anchor retention, Insert commands, and connected PivotTable filtering are implemented.
- PivotTable functional core is implemented, including creation, refresh, field layout/source/options changes, filtering/grouping/sorting, Show Values As, calculated fields/items, built-in and custom workbook-catalog value-field number formats, GETPIVOTDATA, Show Details, PivotChart sync, slicer/timeline integration, external/OLAP pivot-cache source metadata load/save, custom PivotStyle definition metadata load/save, and PivotChart chart-space design metadata round-trip for `pivotFmts`, external-data relationship pointers plus package relationship type/target/target-mode metadata, plot-area and legend manual layout metadata, 3D view metadata, date-system/language, color-map overrides, print settings, style ids, chart protection flags, rounded corners, auto-title-deleted state, hidden-row-data visibility, blank-display behavior, rendered data-table options, and data-label-over-maximum flags. PivotChart Options now edits field buttons, data-table/legend-key display, rounded corners, hidden-row data visibility, and blank-cell display mode. Remaining gaps are exact PivotStyle gallery UI/rendering semantics, richer PivotChart layout/design editing beyond these chart-space flags, and external/OLAP/data-model refresh or execution.
- Unsupported XLSX feature detection and open/save warnings for macros, Power Query, data model/Power Pivot, linked data types, threaded comments, track changes, chart/dialog/macro sheet types, form controls/ActiveX, digital signatures, custom ribbon UI, Office add-ins/web extensions, SmartArt diagrams, embedded objects, and unsupported chart package parts, with retained-opaque package wording rather than general package-loss wording.
- Accessibility: `SheetGrid` and sheet-tab `TabChrome` have correct `AutomationProperties.Name`; `GridView` exposes a `DataGrid`-typed automation peer; all dialogs have `IsDefault`/`IsCancel` and programmatic initial focus; 10 UIA XAML-parse tests added (PR #45).
- Keyboard shortcuts at **100% parity (87/87)**; AutoFilter shortcut improvements in `DataFilterCommands` (PR #48).
- All `MessageBox.Show` calls in dialog classes migrated to `IUserMessageService`/`DialogMessageHelper`; all dialog access keys and `IsDefault`/`IsCancel` states audited (PR #47).
- XLSX corpus at **175 rows** (+31 new feature buckets); 3 per-feature XML structural comparisons; 6 round-trip bugs fixed (PR #46).

## Highest Priority Outstanding Work

1. **XLSX corpus and fidelity proof**
   - Current manifest has 175 rows: 121 generated rows, 25 public Tealeg rows, 20 optional local-private rows, and 9 regression formula-cache workbooks.
   - Continue growing the 100+ row baseline with public/open-license, local-private, and regression workbooks.
   - Continue expanding corpus checks from model-summary stability into deeper per-feature comparisons.
   - Add more Excel-authored formula-result fixtures that compare FreeX evaluation against cached Excel results for newly discovered high-risk edge semantics, especially volatility and spill boundaries.
   - Publish pass/fail rate by workbook and feature bucket before claiming 95% fidelity.

2. **Package-preserving XLSX save path**
   - Package-preserving XLSX save exists as a best-effort source-package merge.
   - Remaining work is broader retention coverage, deeper semantic comparisons, and manual desktop Excel open/save/reopen validation.

3. **Release documentation and packaging**
   - `USER_GUIDE.md` - written; covers all supported features, navigation, formulas, charts, PivotTables, data tools, printing, keyboard shortcuts.
   - `TROUBLESHOOTING.md` - written; covers common issues, unsupported-feature warnings, formula errors, chart/PivotTable issues, known limitations.
   - Keep the docs index, current project status report, and tester release notes aligned with `main`.
   - MSIX release automation now produces an unsigned local package in CI; remaining release packaging work is signing and installer trust validation.
   - `release/progress.json` now drives default tester-release version bands; `overallCompletion: 95` maps to the `v0.8.<run>` tester stream.
   - The accessibility validation gate from `TEST_DISTRIBUTION_PLAN.md` has been audited (PR #45): `SheetGrid` and sheet-tab automation peers fixed, 10 new UIA XAML-parse tests added. Remaining: live keyboard-only and screen-reader validation with a human tester.

4. **Keytip overlay placement**
   - Continue UI automation coverage for the shortcut matrix and WPF key routing beyond the first process-scoped visible-control snapshot.
   - Improve keytip overlay placement toward Excel-perfect visual positioning. Control-type-aware placement landed 2026-05-31 (tab keytips anchor below the tab; command keytips bottom-center); remaining is finer pixel-perfect tuning.
   - Extend nested submenu keytips beyond the current covered Conditional Formatting paths as new nested menus appear.
   - Keyboard shortcut parity is now **100% (87/87)** — keytip visual polish remains.

5. **XLSX warning coverage as new gaps are found**
   - Keep unsupported-feature detection aligned with newly discovered OOXML package parts.
   - Add known-gap corpus rows whenever a workbook contains unsupported content that should be disclosed rather than silently lost.

## Code-Quality Hardening Backlog (2026-05-30 review)

From the 2026-05-30 comprehensive source review. The build is green and every prior P0/P1 correctness/security/data-loss finding is resolved. Full evidence and `file:line` references are in [CODE_REVIEW_COMPREHENSIVE_2026-05-30.md](CODE_REVIEW_COMPREHENSIVE_2026-05-30.md).

### Resolved in this review (2026-05-30, second pass)

- **(P1, security) Done** — File-size + zip-bomb guard before open. `WorkbookOpenSizeGuard` rejects files over a 2 GiB cap and packages whose declared decompressed size (8 GiB) or compression ratio (1000:1) is bomb-like, before any decompression. Wired into `OpenWorkbookLoader` (file size) and `XlsxFileAdapter.LoadCore` (archive). 6 new unit tests + a loader test. (Old review §7.3.)
- **(P2, reliability) Done** — `RecalcEngine`'s defensive `catch (Exception)` now `throw`s under `#if DEBUG` so built-in-function bugs surface in tests instead of shipping as `#VALUE!`; the Release swallow is unchanged. Validated: calc 552/552 + formula 2630/2630 still green, so nothing was being masked.
- **(P2, fidelity) Done** — The three broad `catch { }` blocks in `XmlNativeBagSerializer` are narrowed to `catch (XmlException)`, so only malformed-XML is skipped and unexpected exceptions (OOM, etc.) propagate instead of silently dropping preserved fragments.
- **(P3, security hygiene) Done** — All URL shell launches now go through one guarded `ExternalUrlLauncher` (scheme allowlist enforced); the previously-unguarded help/feedback `Process.Start` and the hyperlink path both route through it. 5 new tests.
- **(P3, reliability) Done** — `RecentFilesStore` now saves via `AtomicFileWriter` (temp-then-rename), so an interrupted write can no longer corrupt `recent.json`. 2 new tests.

### Remaining (deferred with rationale)

1. **(P1, perf) — deferred (needs perf baseline + visual verification)** Cache `FormattedText` in the GridView render loop and remove the per-probe-size allocation in shrink-to-fit (`GridView.Rendering.cs`). A correct cache must key on text/typeface/size/brush/dip/decorations and avoid re-mutating shared instances; there are no pixel/perf tests to catch a regression, so this needs a `PERF_BASELINE.md` measurement and manual visual check before landing.
2. **(P2, perf) — deferred (correctness-sensitive)** Drive sheet/all recalc through the delta path instead of the unconditional full `RebuildFormulaDependencies` in `RecalculateSheetFormulas`/`RecalculateAllFormulas`. Safe delta-recalc needs dependency-dirty tracking (tied to the model-events item below); doing it without that risks stale cross-sheet/volatile results.
3. **(P2, perf) — deferred (hot-path refactor + baseline)** Pool transient evaluator buffers for the per-binary-op `ScalarValue[,]` allocations in `FormulaEvaluator`. `ArrayPool<T>` is 1-D; pooling 2-D buffers safely is a non-trivial restructure of the evaluator hot path and should be measured against `PERF_BASELINE.md` first.
4. **(P3) — deferred (low value without P-list item 5)** Explicit `Reapply` command contract; only worth it alongside the shared snapshot abstraction below, otherwise it is an unused interface method.
5. **(P3, maintainability) — deferred (cross-cutting refactor)** Shared `SheetSnapshot` diff abstraction to replace per-command snapshot tuple types across ~15 commands.
6. **(P3, architecture) — deferred** Read-only model surfaces + event-driven invalidation for `Sheet`/`Workbook` (god-object collections are still publicly mutable; UI invalidation is manual). Single-threaded recalc remains a documented intentional decision (see "Calculation performance architecture" below).

## Product Parity Work Still Outstanding

1. **View and window management**
   - New Window and Switch Windows are live through the registry-backed workbook-window slice.
   - Hide Window, Unhide Window, View Side by Side, Synchronous Scrolling, and Reset Window Position are deferred until workbook-window visibility, paired layout, and synchronized viewport routing exist; they are intentionally not surfaced as disabled ribbon placeholders.
   - Fine split-pane scroll feel parity.
   - Split-pane merged-cell edge cases across non-visible rows/columns.
   - Full workbook view-mode polish beyond the current state/persistence baseline.

2. **Charts, themes, and visual objects**
   - Full chart format panes/dialog UX.
   - Richer combo-chart mixes and advanced chart families such as treemap, sunburst, histogram, Pareto, box-and-whisker, waterfall, funnel, map, and true 3D mesh-style surface polish; blank-display rendering now covers line/area plus blank-as-zero column/bar charts, 2D/3D surface charts have standard OOXML package parts with series axes and value-colored matrix rendering paths, 3D clustered column/bar, 3D line, 3D area, and 3D pie now have standard OOXML package/rendering paths, and stock chart parity now includes high-low-close, open-high-low-close, volume stock package/rendering paths, date-axis rendering, and up/down bar candlestick rendering but still needs deeper formatting preset polish.
   - Deeper OOXML effect semantics and broader chart-theme extraction.
   - Arbitrary pie/doughnut data-label text angles and richer tick placement beyond renderer constraints.
   - Interactive picture/object resize (all 8 handles) and rotation handles — **done 2026-05-31** (`GridObjectDragPlanner` 8-direction resize + rotation grip; `SetDrawingObjectRotationCommand`).
   - Chart data-label content toggles (value / series / category / percentage / legend-key) wired through dialog + formatter — **done 2026-05-31** (#3 polish slice).
   - Crop is available via the Format Picture dialog. Remaining: gradients, richer shape effects, richer text/shape formatting, rotated selection-handle frame, and the legend-key colour swatch beside data labels.

3. **Conditional formatting**
   - Continue hardening advanced conditional-format semantics beyond current color-scale, data-bar, and icon-set model/UI/XLSX coverage.
   - Keep closing color-scale and data-bar XLSX/rendering edge semantics as new gaps are found.
   - Advanced data bar options (border, axis display, negative fill/border colors) are now exposed in the dialog UI (PR #26).
   - CF rule manager has double-click-to-edit and Enter/Delete keyboard shortcuts matching Excel's rule manager UX (PR #27).
   - Per-threshold icon overrides for icon-set rules now fully implemented (model, XLSX adapter, viewport, dialog UI) - PR #29.
   - Remaining: any deeper color-scale XLSX edge semantics.

4. **Data workflow polish**
   - Sort/filter dialog UX: multi-level sort, case-sensitive, orientation, sort-by-colour, and custom-list "First key sort order" are implemented; custom-list order is now actually applied to the primary key — **done 2026-05-31** (`CustomSortOrder`). Remaining: any further niche sort/filter dialog options.
   - Data Validation range-picker with live modal collapse/selection — **done** (`DataValidationRangeSelectionRequest`, present in code).
   - Full Scenario PivotTable-style reports — **done** (Scenario Manager "Summary" report via `ScenarioManagerAction.Report` / `ScenarioCommands`).
   - Advanced Subtotal dialog (replace current subtotals, page break between groups, summary below data, multiple summary functions) — **done** (present in code).
   - Remaining gap: **Forecast chart UX** rather than only the generated forecast-sheet formulas (`ForecastSheetDialog` generates the sheet; the forecast *chart* visualization is not yet built).

5. **Grouped-sheet propagation**
   - Extend grouped-sheet behavior for advanced object effects.
   - Extend grouped-sheet behavior for supported advanced data commands where Excel applies actions across grouped sheets.

6. **Calculation performance architecture**
   - Recalculation is intentionally single-threaded today.
   - Build multi-threaded recalculation only after large-workbook profiling proves it is needed.
   - If built, add thread-safe dependency graph/evaluation, progress reporting, cancellation, and result parity tests against the single-threaded engine.

## Ribbon Planned Command Handoff - 2026-05-30

The ribbon cleanup removed excluded placeholders from the visible command surface. Planned/deferred commands remain visible only where they represent an intended product lane rather than an excluded Microsoft integration.

### Active workstream check

Local worktree/branch status was checked on 2026-05-30 before opening these items:

- `codex/freex-ribbon-20260530` is clean and has no commits ahead of `main`.
- `codex/freex-commands-20260530` is working on clipboard TSV command behavior, not map charts, multi-window view, or PivotTable ribbon actions.
- `codex/freex-dialogs-20260530` is working on dialog access-key labeling, not these planned ribbon actions.
- `codex/freex-build-20260530` has dirty tester-publish/build script work, not product parity for these commands.
- `codex/freex-six-lane-integration-20260530` is behind `origin/main` and does not currently identify a dedicated owner for these planned ribbon actions.

No local active workstream was found for the planned map-chart or multi-window workbook buckets.

### Parity Orchestrator

- **Map Chart / advanced chart family lane:** define the map-chart model, Insert/Change Chart picker behavior, renderer, XLSX read/write support, and known-gap retention story. This can ride with the existing advanced chart family backlog for treemap/sunburst/histogram/Pareto/box-and-whisker/waterfall/funnel/map/true 3D mesh.
- **View multi-window lane:** New Window + Switch Windows are live (registry-backed). Hide Window, Unhide Window, Reset Window Position, View Side by Side, and Synchronous Scrolling are deferred and hidden from `MainWindow.xaml` until their visibility/pairing/viewport subsystems are implemented and verified.
- **PivotTable ribbon-action lane:** completed in the Pivot contextual ribbon command breadth slice. PivotTable Name, PivotTable Options, Clear, Select, and Move PivotTable are routed from the Analyze tab with selected-PivotTable targeting, command/undo behavior where applicable, keytips, and focused source/planner/core command tests.

### Build Orchestrator

- Keep excluded and deferred placeholders out of the ribbon by preserving source guards around `MainWindow.xaml` and adaptive group profiles. The live `View ▸ Window` commands are New Window and Switch Windows; advanced visibility/pairing commands should only return with working handlers, focused tests, and current parity-doc updates.
- When ribbon XAML or adaptive group changes land, include the focused Host tests that cover `InsertCommandSourceTests`, `HelpCommandSourceTests`, `RibbonTabParityTests`, and adaptive ribbon planner/engine behavior.
- If a future lane reintroduces an excluded Microsoft integration, require a product-scope design document first rather than adding a disabled ribbon placeholder.

## Explicitly Excluded Unless Scope Changes

These are documented exclusions, not current bugs:

- VBA macros, COM add-ins, Office web add-ins, and Office Scripts.
- Power Query, Power Pivot, OLAP/data model features, and Microsoft linked data types.
- Microsoft 365 Share/co-authoring, cloud permissions, presence, Teams-linked sharing, online template discovery, and version history.
- Enterprise Microsoft 365 controls such as sensitivity labels and IRM.
- Full Excel Help/search/support-account/training-template flows.

If any excluded area becomes a product goal, it should get a design document before implementation. Slicers/timelines and PivotTables are now active parity surfaces with documented remaining native-fidelity gaps rather than broad exclusions.

## Historical Docs To Treat Carefully

Stale root sprint/planning documents were removed on 2026-05-17 because they contained obsolete test counts, old release timelines, and outdated feature-scope claims.

Treat `docs/superpowers/plans/*` and `docs/superpowers/specs/*` as historical implementation notes only. Prefer this document, `docs/COMMAND_SURFACE_PARITY.md`, `docs/SHORTCUT_PARITY_MATRIX.md`, `docs/FIDELITY_CONTRACT.md`, and `docs/XLSX_CORPUS_REPORT.md` for current build status.

# Build Lane R1 Handoff - 2026-05-28

Branch: `codex/orch-build-fullaccess-clean-r1-20260528`
Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\orch-build-clean-r1`

## Tiny Build Slice Selected

Document the next build-verification slice so the Build lane can resume from a concrete, low-conflict task instead of another discovery pass.

## Next Implementation Slice

Add a focused build verification check around the smallest project that exercises the shared FreeX build path. Keep the implementation scoped to build documentation, build scripts, or one test project unless the failing check exposes a concrete product fix.

Expected steps:

- identify the canonical build/test command from the solution or project scripts;
- document the command and success criteria in the existing build/test docs;
- run the command from this isolated worktree after syncing from `origin/main`;
- commit only the build-lane documentation or narrowly related verification changes.

## Verification Checklist

- `git status --short --branch`
- `git fetch origin`
- `git merge origin/main`
- repository build command, for example `dotnet build` if the solution is the active entrypoint
- focused test command, for example `dotnet test` if tests exist for the touched area
- `git status --short --branch`

# Build Lane R2 Handoff - 2026-05-30

Branch: `codex/freex-build-20260530`
Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\freex-build`

## Build Verification Slice Completed

Added `tools\Test-DotNetSdkReadiness.ps1` and wired it into `tools\Test-RepositoryPreflight.ps1` so local preflight now fails early when:

- `dotnet` is missing from `PATH`;
- the installed SDKs do not include the Tester Release workflow `dotnet-version` band;
- any checked-in project targets a newer `net*` target framework than the workflow SDK band can cover.

This keeps future build workers from getting a late restore/build failure when the actual issue is an environment or workflow-target mismatch.

## Next Implementation Slice

The Tester Release workflow now uses the same Release build/test isolation flags as the local canonical verification commands. A future Build slice can still add a wrapper around the canonical restore/build/test sequence if the release-lane owner wants CI and local build verification to share one command surface.
