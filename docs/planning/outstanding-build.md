# FreeX Outstanding Build List

**Last updated:** 2026-08-08
**Basis:** originally reviewed on 2026-06-03 from repository Markdown, active code under `src/` and `tests/`, and release metadata. Current-status pointer refreshed on 2026-08-08; see [../history/status-2026-08-08.md](../history/status-2026-08-08.md) for the current snapshot.

This remains the long-form backlog and historical implementation ledger. Older rows are preserved when useful for context, but the current status snapshot and dated fidelity/release docs should win when they disagree with a June 3 metric.

## Current Code Baseline

Confirmed present in code and tests:

- Core spreadsheet shell, command bus, undo/redo, virtualized WPF grid, multi-sheet UI, native/CSV/XLSX adapters.
- Current workbook format adapters cover XLSX read/write, XLSM/XLTM read/write (macro-enabled content type; retained `vbaProject.bin`), XLTX templates, legacy XLS/XLSB/XLT open, ODS read/write, SpreadsheetML 2003, CSV variants, tabular text, Formatted Text (space-delimited) `.prn`, SYLK, DIF, DBF open, HTML tables, Single File Web Page `.mht`/`.mhtml`, read-only PDF tabular-data import (PdfPig grid extraction), and FreeX native `.fxl`.
- Formula engine at 488/488 in-scope functions with catalog guards and category-focused Excel parity tests. This includes modern lookup/dynamic-array functions (`XLOOKUP`, `XMATCH`, `SEQUENCE`, `RANDARRAY`, `FILTER`, `SORT`, `SORTBY`, `UNIQUE`, `TAKE`, `DROP`, `CHOOSEROWS`, `CHOOSECOLS`, `VSTACK`, `HSTACK`, `TOROW`, `TOCOL`, `WRAPROWS`, `WRAPCOLS`, `EXPAND`, `SINGLE`), higher-order formulas (`LET`, `LAMBDA`, `MAP`, `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, `MAKEARRAY`), statistical distributions, financial bond/depreciation helpers, database functions, `HYPERLINK`, discrete engineering base/bit functions, locale-specific text helpers (`ASC`, `DBCS`, `PHONETIC`, `BAHTTEXT`), regex/text helpers, and local web-text helpers (`ENCODEURL`, `FILTERXML`). Formula hardening now includes Excel cached-result fixtures, inverse/round-trip property tests, dynamic-array error/volatility edge guards, and structured-reference current-row/spaced-header coverage; remaining formula work is ongoing parity proof as new edge cases are discovered (see `docs/parity/functions.md`).
- Spill infrastructure and formula AST caching in recalculation.
- Formula reference rewriting for insert/delete/paste/autofill paths.
- Autofill drag UI and `AutofillCommand`; Flash Fill command/service baseline.
- Sort/filter, Advanced Filter copy-to replacement semantics, Text to Columns, Remove Duplicates, Data Validation, Consolidate, Goal Seek, Scenario Manager, Forecast Sheet, one- and two-variable Data Tables, Subtotal, grouping/outline.
- Conditional formatting model/UI for cell-value, formula, top/bottom/above-average, color scales, icon sets, and advanced data-bar dialog options including min/max length, gradient, border, axis, negative colors, and x14 data-bar explicit threshold serialization.
- Page layout, page setup, print/export, custom views, workbook/theme commands, chart/object/theme baselines. PDF export uses raster pages with selectable text/link overlays for worksheet cells, row/column headings, headers/footers, displayed comments/notes, nested simple fixed-document text, fully visible embedded chart titles, X/Y axis titles, legend entries, category and value-axis tick labels, and data labels for classic embedded category charts, plus slice legend entries and value/percentage data labels for embedded pie-family charts (pie, 3-D pie, and doughnut); internal workbook hyperlinks now write direct PDF destinations when the exported page range contains the target cell. PDF/A, tagged PDF, vector chart graphics, chart-sheet pagination, and full chart text coverage remain deferred.
- Slicer/timeline metadata, authored state, pane controls, cache relationships, native floating drawing-anchor retention, Insert commands, and connected PivotTable filtering are implemented.
- PivotTable functional core is implemented, including creation, refresh, field layout/source/options changes, filtering/grouping/sorting, Show Values As, calculated fields/items, built-in and custom workbook-catalog value-field number formats, GETPIVOTDATA, Show Details, PivotChart sync, slicer/timeline integration, external/OLAP pivot-cache source metadata load/save, custom PivotStyle definition metadata load/save, and PivotChart chart-space design metadata round-trip for `pivotFmts`, external-data relationship pointers plus package relationship type/target/target-mode metadata, plot-area and legend manual layout metadata, 3D view metadata, date-system/language, color-map overrides, print settings, style ids, chart protection flags, rounded corners, auto-title-deleted state, hidden-row-data visibility, blank-display behavior, rendered data-table options, and data-label-over-maximum flags. PivotChart Options now edits field buttons, data-table/legend-key display, rounded corners, hidden-row data visibility, and blank-cell display mode. Remaining gaps are exact PivotStyle gallery UI/rendering semantics, richer PivotChart layout/design editing beyond these chart-space flags, and external/OLAP/data-model refresh or execution.
- Unsupported XLSX feature detection and open/save warnings for macros, Power Query, data model/Power Pivot, linked data types, track changes, chart/dialog/macro sheet types, form controls/ActiveX, digital signatures, custom ribbon UI, Office add-ins/web extensions, live web queries/web publishing metadata including `xl/connections.xml` web-query connection metadata, SmartArt diagrams, embedded objects, and unsupported chart package parts, with retained-opaque package wording rather than general package-loss wording.
- Accessibility: `SheetGrid` and sheet-tab `TabChrome` have correct `AutomationProperties.Name`; `GridView` exposes worksheet grid, selection, visible cell grid-item, value, and selection-item UIA patterns through custom automation peers; all dialogs have `IsDefault`/`IsCancel` and programmatic initial focus; source-level UIA property guards plus focused `GridViewAutomationPeerTests` cover the current peer contracts.
- Keyboard shortcuts at **100% parity (88/88)**; AutoFilter shortcut improvements in `DataFilterCommands` (PR #48).
- All `MessageBox.Show` calls in dialog classes migrated to `IUserMessageService`/`DialogMessageHelper`; all dialog access keys and `IsDefault`/`IsCancel` states audited (PR #47).
- XLSX corpus at **182 rows** (+31 new feature buckets plus generated volatile-dependency, document-thumbnail, signed-VBA-signature package graph fixtures, complete renderable chart-type corpus coverage, a user-approved COIN Tool local-private XLSM performance fixture, and a user-approved Partner Dashboard local-private Excel save/reopen regression row); per-feature XML structural comparisons now include conditional formatting, chart series, and data-validation rule semantics; live web-query warning/retention coverage includes connection metadata; 6 round-trip bugs fixed (PR #46). The current 2026-06-03 real Excel smoke baseline is green for FreeX-authored feature fixtures (8/8), the same fixtures after FreeX edits (8/8), the Excel-authored fixture through the FreeX save/edit path (1/1), public+regression corpus save/reopen rows (34/34, schema-validation errors=0 on the FreeX-saved packages), and the Partner Dashboard local-private row through the FreeX-save path (1/1). The metadata-package opt-in gate is tracked separately and its latest metadata-pass-focused desktop Excel run passed 52/52 before the 2026-06-08 corpus package-graph additions.
- Chart interop comparison is now evidence-backed: the latest complete `tools/FreeX.ChartInteropCompare` run passed 28/28 chart cases for FreeX render PNGs, FreeX-authored XLSX opened/exported by Excel, Excel-authored XLSX opened/exported by Excel, and Excel-authored XLSX loaded/saved by FreeX then reopened/exported by Excel. The harness records openability/export failures separately from visual mismatches.
- Localization foundation is now present in code and tests: `UiText`, `LocExtension`, neutral `Strings.resx`, 43 complete satellite resource cultures, startup UI-culture selection, WPF language metadata application, current-culture direct numeric cell entry, delimited CSV/TSV import, and Text to Columns numeric parsing with invariant fallback, plus resource/usage guard tests and pseudo-localization contract smoke coverage for high-risk shell/ribbon/dialog strings.

## Highest Priority Outstanding Work

1. **XLSX corpus and fidelity proof**
   - Current manifest has 182 rows: 126 generated rows, 25 public rows, 22 optional local-private rows, and 9 regression formula-cache workbooks.
   - Continue growing the 100+ row baseline with public/open-license, local-private, and regression workbooks.
   - Continue expanding corpus checks from model-summary stability into deeper per-feature comparisons.
   - **Done 2026-06-01:** `generated-dv-count-package-003` now verifies ten native `dataValidation` rules by type/operator/formula/`sqref` semantics after ordinary model edits.
   - **Done 2026-06-01:** the live web-query known-gap row now covers retained web-publish package parts plus web-query connection metadata and emits the expected unsupported-feature warning.
   - Add more Excel-authored formula-result fixtures that compare FreeX evaluation against cached Excel results for newly discovered high-risk edge semantics, especially volatility and spill boundaries.
   - Publish pass/fail rate by workbook and feature bucket before claiming 95% fidelity.

2. **Package-preserving XLSX save path**
   - Package-preserving XLSX save exists as a best-effort source-package merge.
   - Remaining work is broader retention coverage, deeper semantic comparisons, and manual desktop Excel open/save/reopen validation.
   - **Excel-openability of FreeX-authored chart XLSX is verified for the current 28-chart parity matrix (2026-06-01).** The original manual desktop Excel check found two P0 openability blockers: invalid modeled `theme1.xml` blocked every workbook, and invalid chart package XML/relationships blocked chart workbooks. Both are fixed. The latest full `tools\FreeX.ChartInteropCompare` run at `C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-threedcolumn-caveat-final-main-sync-full` passed 28/28 FreeX renderer PNGs, 28/28 FreeX-authored XLSX open/export checks in Excel, 28/28 Excel-authored native open/export checks, and 28/28 Excel-native -> FreeX -> Excel round-trip open/export checks.
   - **Chart interop status is evidence-driven rather than blocked.** chartEx package sidecars now use Excel's native style profile `id="201"` and color style `id="10"`; Pareto, Box-and-Whisker, Waterfall, Histogram, Treemap, Sunburst, and Funnel pass Excel openability/export and visual gates. Classic stacked/percent-stacked defaults and 3-D package cleanup also pass without broad known-gap allowances. No current chart visual allowances remain: the former `ThreeDColumn` Excel chart-export raster variance is handled by the harness as a byte-identical package round-trip with repeated-Excel-export raster drift, not an openability/package defect.

3. **Release documentation and packaging**
   - `user/guide.md` - written; covers all supported features, navigation, formulas, charts, PivotTables, data tools, printing, keyboard shortcuts.
   - `user/troubleshooting.md` - written; covers common issues, unsupported-feature warnings, formula errors, chart/PivotTable issues, known limitations.
   - Keep the docs index, current project status report, and tester release notes aligned with `main`.
   - The hosted tester release channel is complete: GitHub Actions publishes versioned and stable-latest Windows x64 `.exe` artifacts plus an MSIX package. The MSIX is signed when release certificate secrets are configured; until then, the workflow publishes unsigned MSIX assets for tester continuity. Remaining release packaging work is installer trust validation, Store-style submission, and the deferred in-app update lane.
   - `release/progress.json` now drives default tester-release version bands; `overallCompletion: 95` maps to the `v0.8.<run>` tester stream.
   - The accessibility validation gate from `release/test-distribution.md` has been audited: `SheetGrid`, sheet-tab automation metadata, and `GridView` grid/cell UIA provider contracts have automated coverage. Remaining: live keyboard-only and screen-reader validation with a human tester.

4. **Keytip overlay placement**
   - Continue UI automation coverage for the shortcut matrix and WPF key routing beyond the first process-scoped visible-control snapshot.
   - Improve keytip overlay placement toward Excel-perfect visual positioning. Control-type-aware placement landed 2026-05-31 (tab keytips anchor below the tab; command keytips bottom-center), and dropdown/split commands now hang keytips below the control frame as of 2026-06-04; remaining is finer pixel-perfect tuning.
   - Scoped nested submenu routing now strips active parent prefixes and has coverage beyond Conditional Formatting paths; continue adding coverage as new nested menus appear.
   - Keyboard shortcut parity is now **100% (88/88)** — keytip visual polish remains.

5. **XLSX warning coverage as new gaps are found**
   - Keep unsupported-feature detection aligned with newly discovered OOXML package parts.
   - Live web-query/web-publish warning coverage is current through `xl/connections.xml` web-query metadata as of 2026-06-01.
   - Add known-gap corpus rows whenever a workbook contains unsupported content that should be disclosed rather than silently lost.

## Code-Quality Hardening Backlog (2026-05-30 review)

From the 2026-05-30 comprehensive source review. The build is green and every prior P0/P1 correctness/security/data-loss finding is resolved. Full evidence and `file:line` references are in [reviews/comprehensive-code-review-2026-05-30.md](../reviews/comprehensive-code-review-2026-05-30.md).

### Resolved in this review (2026-05-30, second pass)

- **(P1, security) Done** — File-size + zip-bomb guard before open. `WorkbookOpenSizeGuard` rejects files over a 2 GiB cap and packages whose declared decompressed size (8 GiB) or compression ratio (1000:1) is bomb-like, before any decompression. Wired into `OpenWorkbookLoader` (file size) and `XlsxFileAdapter.LoadCore` (archive). 6 new unit tests + a loader test. (Old review §7.3.)
- **(P2, reliability) Done** — `RecalcEngine`'s defensive `catch (Exception)` now `throw`s under `#if DEBUG` so built-in-function bugs surface in tests instead of shipping as `#VALUE!`; the Release swallow is unchanged. Validated: calc 552/552 + formula 2630/2630 still green, so nothing was being masked.
- **(P2, fidelity) Done** — The three broad `catch { }` blocks in `XmlNativeBagSerializer` are narrowed to `catch (XmlException)`, so only malformed-XML is skipped and unexpected exceptions (OOM, etc.) propagate instead of silently dropping preserved fragments.
- **(P3, security hygiene) Done** — All URL shell launches now go through one guarded `ExternalUrlLauncher` (scheme allowlist enforced); the previously-unguarded help/feedback `Process.Start` and the hyperlink path both route through it. 5 new tests.
- **(P3, reliability) Done** — `RecentFilesStore` now saves via `AtomicFileWriter` (temp-then-rename), so an interrupted write can no longer corrupt `recent.json`. 2 new tests.

### Stale-cleared regression report (2026-06-01)

- **(P2, regression) — stale-cleared** The previously documented drag row/column resize-preview blocker is no longer open. Targeted Release verification on `main` at `3ddbbebb3` passed 8/8 for `MainWindowMouseResizeTests`: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --no-build --filter "FullyQualifiedName~MainWindowMouseResizeTests"`. Keep the preview contract covered by those tests: preview drag should not mutate sheet dimensions or refresh the viewport until commit.

### Remaining (deferred with rationale)

1. **(P1, perf) — deferred (needs perf baseline + visual verification)** Cache `FormattedText` in the GridView render loop and remove the per-probe-size allocation in shrink-to-fit (`GridView.Rendering.cs`). A correct cache must key on text/typeface/size/brush/dip/decorations and avoid re-mutating shared instances; there are no pixel/perf tests to catch a regression, so this needs a `performance/baseline.md` measurement and manual visual check before landing.
2. **(P2, perf) — deferred (correctness-sensitive)** Drive sheet/all recalc through the delta path instead of the unconditional full `RebuildFormulaDependencies` in `RecalculateSheetFormulas`/`RecalculateAllFormulas`. Safe delta-recalc needs dependency-dirty tracking (tied to the model-events item below); doing it without that risks stale cross-sheet/volatile results.
3. **(P2, perf) — deferred (hot-path refactor + baseline)** Pool transient evaluator buffers for the per-binary-op `ScalarValue[,]` allocations in `FormulaEvaluator`. `ArrayPool<T>` is 1-D; pooling 2-D buffers safely is a non-trivial restructure of the evaluator hot path and should be measured against `performance/baseline.md` first.
4. **(P3) — deferred (low value without P-list item 5)** Explicit `Reapply` command contract; only worth it alongside the shared snapshot abstraction below, otherwise it is an unused interface method.
5. **(P3, maintainability) — deferred (cross-cutting refactor)** Shared `SheetSnapshot` diff abstraction to replace per-command snapshot tuple types across ~15 commands.
6. **(P3, architecture) — deferred** Read-only model surfaces + event-driven invalidation for `Sheet`/`Workbook` (god-object collections are still publicly mutable; UI invalidation is manual). Single-threaded recalc remains a documented intentional decision (see "Calculation performance architecture" below).

## Product Parity Work Still Outstanding

1. **View and window management**
   - New Window and Switch Windows are live through the registry-backed workbook-window slice.
   - Hide Window, Unhide Window, View Side by Side, Synchronous Scrolling, Reset Window Position, and Arrange All are **done 2026-06-01**. Arrange All stores the workbook arrangement choice and applies live visible-window layouts for Tiled, Horizontal, Vertical, and Cascade through `WorkbookWindowRegistry` / `ArrangeAllLayoutPlanner`; Side by Side uses `SideBySideLayoutPlanner`, and Reset uses `WindowResetPositionPlanner`. Cross-window scroll mirroring is double-guarded against feedback loops.
   - Fine split-pane scroll feel parity is narrowed: mini-scrollbar wheel gestures now resolve the pane and axis from the chrome under the pointer before falling back to cell-region targeting (covered by `ResolveSplitPaneWheelTarget` and the host wheel-handler source test). Remaining polish is live WPF evidence for divider drag/visual feel and any newly found active-pane edge cases.
   - Split-pane merged-cell indexing now prunes regions outside queried pane row/column bounds before visible-row expansion; keep closing any newly discovered merged-cell edge cases.
   - Worksheet primary view-mode load/save now targets the primary `sheetView` (`workbookViewId="0"`) even when additional sheet views appear first in the XML; remaining view work is any deeper workbook/window view-mode polish found in real files.

2. **Charts, themes, and visual objects**
   - Chart interop comparison harness is active and current. It compares FreeX renderer PNGs, FreeX-authored XLSX opened/exported by Excel, Excel-authored XLSX opened/exported by Excel, and Excel-authored XLSX loaded/saved by FreeX then reopened/exported by Excel. Latest complete run: 28/28 chart cases passed openability/export and visual gates with 0 known-gap allowances and 28/28 byte-identical Excel-native/FreeX-round-trip packages; repeated Excel COM diagnostics are tracked as automation/openability failures rather than visual mismatches.
   - Histogram bin configuration (Excel "Format Axis ▸ Bins": automatic / bin width / number of bins, plus overflow & underflow bins) — **modeled + rendered + native-persisted 2026-06-01** (pure `HistogramBinPlanner` with 10 unit tests, `ChartModel.HistogramBinning`, renderer delegates to the planner, native JSON round-trip). Current XLSX support is bounded: native chartEx binning can be read and FreeX-authored histograms write a conservative chartEx binning layout, but FreeX-authored bin settings are intentionally not persisted through XLSX save/load while full openability-safe semantics remain unsettled. Follow-on: Format-Axis dialog UI to set bins and a safe full XLSX round-trip decision for bin settings.
   - Waterfall "Set as Total" per-point totals — **modeled + rendered + native-persisted + UI-wired 2026-06-01** (pure `WaterfallBarPlanner` with 11 unit tests, `ChartModel.WaterfallTotalPointIndices`, renderer delegates to the planner, plus the Set as Total UI path). This also fixed a rendering bug where a total column was drawn from the running total up by its own value (approximately `[sum, 2*sum]`) instead of as an anchor from zero to the cumulative (`[0, sum]`). chartEx output/readback now round-trips modeled total-point indices and writes connector visibility, axes, and subtotal metadata; follow-on work is visual styling refinements and live UI evidence.
   - Explicit chart dialogs/source coverage now covers Change Chart Type, Select Data, Move Chart, Chart Titles, Chart Styles, and chart area/legend/axis/series/data-label/trendline/error-bar formatting. Remaining chart UX work is the full Excel format-pane experience, live visual mutation evidence, and deeper layout/design editing beyond the modeled dialog slices.
   - Richer combo-chart mixes and advanced chart families such as treemap, sunburst, histogram, Pareto, box-and-whisker, waterfall, funnel, map, and true 3D mesh-style surface polish; blank-display rendering now covers line/area plus blank-as-zero column/bar charts, 2D/3D surface charts have standard OOXML package parts with series axes and value-colored matrix rendering paths, 3D clustered column/bar, 3D line, 3D area, and 3D pie now have standard OOXML package/rendering paths, chartEx treemap/sunburst/histogram/Pareto/box-and-whisker/waterfall/funnel have current Excel-openability/export and visual-gate evidence, and stock chart parity now includes high-low-close, open-high-low-close, volume stock package/rendering paths, date-axis rendering, and up/down bar candlestick rendering but still needs deeper formatting preset polish. Map charts remain deferred unless productized.
   - Deeper OOXML effect semantics and broader chart-theme extraction.
   - Arbitrary pie/doughnut data-label text angles and richer tick placement beyond renderer constraints.
   - Interactive picture/object resize (all 8 handles) and rotation handles — **done 2026-05-31** (`GridObjectDragPlanner` 8-direction resize + rotation grip; `SetDrawingObjectRotationCommand`).
   - Chart data-label content toggles (value / series / category / percentage / legend-key) wired through dialog + formatter — **done 2026-05-31** (#3 polish slice).
   - Crop is available via the Format Picture dialog. Basic two-color shape gradients plus None/Shadow/Glow/Soft Edges effects are implemented with undo/rendering/native JSON/XLSX coverage. Remaining: full Excel gradient/effect galleries, richer text/shape formatting, rotated selection-handle frame, and the legend-key colour swatch beside data labels.

3. **Conditional formatting**
   - Continue hardening advanced conditional-format semantics beyond current color-scale, data-bar, and icon-set model/UI/XLSX coverage.
   - Keep closing color-scale and data-bar XLSX/rendering edge semantics as new gaps are found.
   - x14 data-bar explicit threshold serialization is **done 2026-06-01** for modeled `num`, `percent`, `percentile`, and `formula` cfvo values with `xm:f` children.
   - Advanced data bar options (border, axis display, negative fill/border colors) are now exposed in the dialog UI (PR #26).
   - CF rule manager has double-click-to-edit and Enter/Delete keyboard shortcuts matching Excel's rule manager UX (PR #27).
   - Per-threshold icon overrides for icon-set rules now fully implemented (model, XLSX adapter, viewport, dialog UI) - PR #29.
   - Remaining: any deeper color-scale XLSX edge semantics.

4. **Data workflow polish**
   - AutoFilter `Filter by Color` menu availability now matches the modeled data: the command is hidden unless actual color choices exist.
   - Text to Columns General numeric conversion now accepts current-culture numbers with invariant fallback and rejects non-finite values.
   - Sort/filter dialog UX: multi-level sort, case-sensitive, orientation, sort-by-colour, and custom-list "First key sort order" are implemented; custom-list order is now actually applied to the primary key — **done 2026-05-31** (`CustomSortOrder`). Remaining: any further niche sort/filter dialog options.
   - Data Validation range-picker with live modal collapse/selection — **done** (`DataValidationRangeSelectionRequest`, present in code).
   - Full Scenario PivotTable-style reports — **done** (Scenario Manager "Summary" report via `ScenarioManagerAction.Report` / `ScenarioCommands`).
   - Advanced Subtotal dialog (replace current subtotals, page break between groups, summary below data, multiple summary functions) — **done** (present in code).
   - Forecast chart visualization — **done** (`ForecastSheetCommand` adds a `ForecastChartPlanner`-planned line chart — Actual/Forecast plus dashed lower/upper confidence bounds — to the generated sheet; reverting the command removes the sheet and its chart. Covered by `ForecastSheetCommandTests.ForecastSheetCommand_InsertsForecastChartOnGeneratedSheetAndUndoRemovesIt` + `ForecastChartPlannerTests`).

5. **Grouped-sheet propagation**
   - Selection Pane rename, visibility, and z-order edits now propagate across visible grouped sheets for supported pictures, shapes, and text boxes, with per-sheet object remapping and rollback when an equivalent object cannot be resolved.
   - Remove Duplicates, Subtotal, and Remove All Subtotals now propagate across visible grouped sheets with per-sheet remapped ranges; extend any remaining supported object/data commands where Excel applies actions across grouped sheets as they are identified.

6. **Localization and culture**
   - Foundation, neutral `en-US` resources, and 43 complete satellite resource cultures are implemented.
   - Current-culture direct numeric cell entry, delimited CSV/TSV import, and Text to Columns numeric parsing with invariant fallback are implemented.
   - Remaining work is native-speaker/translator review, broader core-message code boundaries, additional date/import parser audits, selectable pseudo-localized runtime/visual layout smoke coverage, and release/package language metadata validation.

7. **Calculation performance architecture**
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

- **Map Chart / true 3D mesh lane:** define the map-chart model, Insert/Change Chart picker behavior, renderer, XLSX read/write support, and known-gap retention story if Map is productized. Keep true 3D mesh-style surface as renderer/product-scope polish; the current treemap/sunburst/histogram/Pareto/box-and-whisker/waterfall/funnel chartEx families already have chart interop evidence.
- **View multi-window lane:** **COMPLETE 2026-06-01.** New Window + Switch Windows plus Hide Window, Unhide Window, Reset Window Position, View Side by Side, Synchronous Scrolling, and Arrange All are all live (registry-backed visibility/pairing/sync-scroll/arrangement state + `WindowResetPositionPlanner` / `SideBySideLayoutPlanner` / `ArrangeAllLayoutPlanner`). The buttons are present in `MainWindow.xaml` with dedicated live handlers and focused tests; do not re-hide them.
- **PivotTable ribbon-action lane:** completed in the Pivot contextual ribbon command breadth slice. PivotTable Name, PivotTable Options, Clear, Select, and Move PivotTable are routed from the Analyze tab with selected-PivotTable targeting, command/undo behavior where applicable, keytips, and focused source/planner/core command tests.

### Build Orchestrator

- Keep excluded placeholders out of the ribbon by preserving source guards around `MainWindow.xaml` and adaptive group profiles. The formerly deferred `View ▸ Window` commands (New Window, Switch Windows, Hide, Unhide, Reset Window Position, View Side by Side, Synchronous Scrolling, Arrange All) have working handlers and focused tests; do not remove them.
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

Treat `docs/archive/superpowers/plans/*` and `docs/archive/superpowers/specs/*` as historical implementation notes only. Prefer this document, `docs/parity/command-surface.md`, `docs/parity/shortcuts.md`, `docs/formats/fidelity-contract.md`, and `docs/formats/xlsx-corpus-report.md` for current build status.

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

Superseded by the faster verification policy: local verification, CI, and Tester Release now use normal .NET restore/build caching and parallelism by default. The old serial/no-build-server flags are reserved for a one-time rerun when stale build-server or output-lock state is the suspected failure mode.
