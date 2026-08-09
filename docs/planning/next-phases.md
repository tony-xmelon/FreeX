# FreeX Next Development Phases

**Last updated:** 2026-08-08
**Current state:** This is a June 3 development-phase snapshot retained as historical sequencing. The current status source is [../history/status-2026-08-08.md](../history/status-2026-08-08.md); it records the current tester release state, workbook/document file-format adapters, active fidelity/corpus workstreams, and remaining public-preview promotion blockers.

The June 3 baseline below is preserved for context: formula engine at 488/488 in-scope functions (100%), command surface at 100% of in-scope commands, shortcut parity at 100% (88/88), XLSX round-trip and corpus coverage at a 180-row manifest baseline, virtualized WPF UI, JSON-driven tester-release versioning, unsigned local MSIX packaging, deep PivotTable/PivotChart fidelity, UIA accessibility peers, a 43-culture localization resource foundation, and a chart interop harness with a latest-complete 28/28 openability/export plus visual-gate pass, 0 known-gap chart allowances, and 28/28 byte-identical Excel-native/FreeX-round-trip packages.

---

## Completed

### Phase 6: Formula Completeness

All 488 in-scope Excel functions are implemented and tested. The original Phase 6 buckets below are historical milestones; the current catalog is authoritative in [parity/functions.md](../parity/functions.md):

- **6A** - LET, LAMBDA, MAP, REDUCE, SCAN, BYROW, BYCOL, MAKEARRAY (+ recursive lambda support)
- **6B** - Full statistical distribution suite (normal, t, F, chi-squared, binomial, beta, gamma, Weibull, lognormal, exponential, FREQUENCY, SKEW, KURT, CONFIDENCE)
- **6C** - Complete financial bond math (accrued interest, coupon analytics, price/yield, odd-period, depreciation, IRR/XIRR/XNPV, treasury bills, and all remaining helpers)
- **6D** - OFFSET, FORMULATEXT, ISFORMULA, ISREF, CELL, INFO, GETPIVOTDATA
- **6E** - HYPERLINK plus discrete engineering base-conversion and bitwise functions

See [parity/functions.md](../parity/functions.md) for the full function list.

### PivotTable Fidelity

Core pivot semantics, XLSX round-trip, and refresh propagation are solid:

- Multiple row/column/value/filter fields; nested column matrices
- Grand-total visibility (row and column axes independently)
- Repeated-label suppression; blank-line spacing; compact/outline layout flags
- Page/row/column checked-item filters; row and column label filters; value filters with source-field targeting
- Label and value sorting (both axes); date/number grouping
- Top/bottom subtotals; calculated fields/items; Show Details (item/subtotal/grand-total/matrix/column-only data cells)
- Values-only and column-only layouts
- PivotChart binding; undoable bound chart-type changes; XLSX-authored round-trip; PivotTable style-name round-trip
- GETPIVOTDATA lookups for same-sheet and cross-sheet PivotTable references, page fields, row/column filters, subtotals, and grand totals
- Cross-sheet source data for PivotTable creation, source changes, slicers, timelines, and GETPIVOTDATA
- Insert Slicer and Insert Timeline command/UI authoring for worksheet-range PivotTables

### May 2026 Parallel Parity Push

The late May workstreams moved several remaining parity areas from feature build-out into hardening:

- Command surface remains at 100% coverage for in-scope commands.
- Formula work is now edge-case hardening rather than function coverage, with active Unicode, spill, and scalar coercion fixes.
- XLSX parity has expanded through chart part readers, slicer/timeline anchors, icon-set corpus coverage, public corpus checks, pivot writer refactors, and native JSON chart metadata.
- Dialog parity has broad coverage, with active cleanup continuing across focus behavior, access keys, and exact Excel-style dialog shell details.
- Ribbon/icon/layout polish has moved from first-pass icon coverage into consistency review, titlebar/QAT state polish, and layout fidelity.

### May 2026 Production Readiness Pass (PRs #45–#49, 2026-05-29)

The production readiness pass hardened accessibility, test corpus quality, dialog parity, shortcut coverage, and documentation:

- **Accessibility gate**: `SheetGrid` (`GridView`) has worksheet automation metadata plus grid, selection, visible cell grid-item, value, and selection-item provider coverage; `TabChrome` sheet-tab grid `AutomationProperties.Name` is bound to sheet name; `MainWindowUiaPropertiesTests` and `GridViewAutomationPeerTests` guard the current UIA contracts.
- **#46 XLSX corpus**: Manifest expanded from 144 to 175 rows; 3 per-feature XML structural comparisons (CF rules, chart series, DV counts) added; 6 round-trip bugs fixed.
- **#47 Dialog parity**: All remaining `MessageBox.Show` calls in dialog classes replaced with `IUserMessageService`; access keys and `IsDefault`/`IsCancel` audited across all dialogs.
- **#48 Shortcut parity**: AutoFilter shortcut improvements; shortcut parity now at 100% (88/88, 0 partial).
- **#49 Docs**: status and outstanding-build docs updated; `overallCompletion` raised to 95.

### May 31 and June 1 Integration and Localization Foundation

May 31 closed several late hardening slices and June 1 expanded the production localization substrate:

- Formula documentation and catalog status now track 488/488 in-scope functions.
- `UiText`, `LocExtension`, neutral `Strings.resx`, and 43 complete satellite resource cultures are present. Tests cover resource keys, XAML usage, automation metadata, language catalog discovery, satellite key/placeholder/access-key parity, blank-value prevention, full satellite assemblies without parent fallback, and Bulgarian terminology smoke coverage.
- Ribbon/sheet-tab polish continued through compact split-button segment fixes, standalone ribbon command layout at wider widths, sheet add/options icon polish, and tab navigation hover alignment.
- Object resize/rotation handles, chart data-label toggles, custom-list primary sort behavior, and keytip placement polish are recorded as done in the outstanding-build backlog.

---

## Phase 7: Advanced UI Polish (estimated: 2-3 sprints)

### 7-0: Overlap Stabilization

Before opening new broad UI workstreams, finish or explicitly pause dirty overlaps that touch the same file families:

- Keep one owner at a time for ribbon shell, dialog shell, pivot dialog/model, XLSX chart readers, and formula evaluator files.
- Merge focused formula, chart/XLSX, and dialog branches after targeted verification rather than letting many session branches drift.
- Clean generated build/log artifacts before status reviews so real source changes are visible.
- Keep this plan, [planning/outstanding-build.md](outstanding-build.md), and the newest project status report aligned after significant merges.
- Treat tester-release failures as release blockers when they occur before publish; the current known blocker is Core.IO corpus regression coverage, not the GitHub dispatch API.

### 7A: PivotTable Authoring UI

The model, refresh engine, and primary authoring layer cover the practical worksheet-range PivotTable surface:

- Field-list panel with checkbox toggles, drag-and-drop into row/column/value/filter zones, context menus, item filters, label/value filters, and Value Field Settings with built-in/custom number-format controls is implemented.
- Contextual PivotTable Analyze/Design tabs include Field List, Refresh, Show Details, PivotChart, Insert Slicer, Insert Timeline, Change Source, layout controls, style cycling, and style-option toggles.
- Remaining advanced UI parity is full Excel PivotChart Tools layout/design editing beyond chart-type changes and deeper per-element PivotStyle gallery theme semantics.

### 7B: Slicer and Timeline UI

Slicer and timeline metadata plus the worksheet-range PivotTable interaction layer are implemented:

- Slicer/timeline metadata loads/saves, cache relationships round-trip, and native package parts are retained where possible.
- Authored slicer/timeline state round-trips, pane controls filter connected PivotTables, and Insert Slicer/Insert Timeline commands are exposed from the contextual PivotTable ribbon.
- Remaining native-fidelity gap: exact Excel slicer/timeline floating drawing objects and style galleries.

### 7C: Advanced Chart Families

- Stock charts (OHLC/candlestick), radar, surface
- Statistical: histogram, Pareto, box-and-whisker
- Hierarchy: treemap, sunburst
- Modern: waterfall, funnel
- Full chart format pane/dialog UX for all chart families

June 1 status: `tools/FreeX.ChartInteropCompare` now provides repeatable Excel COM openability/export and visual-gate evidence. The latest complete run passed 28/28 chart cases with 0 known-gap allowances and byte-identical Excel-native/FreeX-round-trip packages, with current fixes for Pareto chartEx axis metadata, box-and-whisker chartEx metadata, waterfall chartEx XML and Set as Total UI, scatter connector defaults, classic chart default layout, and 3-D depth axis ids. chartEx passed 7/7 openability/export and visual gate with 0 chartEx known gaps. Remaining work is full chart formatting/layout UX, map-chart scope if productized, and keeping the chart gate green as writer changes continue.

### 7D: Conditional Formatting and Formatting Polish

- Icon-set model, XLSX round-trip, cell rendering, grouped menu presets, and core rule editing are implemented.
- Data-bar dialog coverage includes min/max length, gradient, border, axis, and negative-color options; remaining work is deeper XLSX/rendering edge fidelity as new gaps are found.
- Remaining polish is any deeper color-scale XLSX edge semantics as new gaps are found.

---

## Phase 8: Performance and Scalability (estimated: 1-2 sprints)

### 8A: Multi-threaded Recalculation

- Profile recalculation on large workbooks (50k+ formulas) before committing to threading
- If profiling confirms parallelism as the right fix: thread-safe topological evaluation (partition DAG into independent subgraphs, evaluate in parallel)
- Progress reporting and cancellation for long recalculations
- Result-parity tests against the single-threaded engine

### 8B: Large Workbook XLSX Parse Optimization

- SAX/streaming parse for shared-strings and worksheet XML to avoid full DOM allocation
- Incremental sheet-load: parse only the active sheet on open; load other sheets lazily
- Benchmark open time for a 10 MB+ workbook; publish perf baseline in `docs/performance/baseline.md`

---

## Phase 9: XLSX Corpus Expansion (ongoing)

- Continue expanding beyond the current 182-row manifest baseline
- Add public/open-license workbooks covering every feature bucket (charts, CF, pivot, validation, named ranges, shared formulas, etc.)
- Graduate per-workbook smoke tests to per-feature structural comparisons (cell values, styles, chart series counts, CF rules, etc.)
- Track and publish pass/fail rate by feature bucket; target 95% of supported features passing before any public release claim
- Add regression entries for every bug fix involving XLSX round-trip or formula result discrepancy

---

## Explicitly Excluded (won't change unless a design doc is written)

- **VBA / macros / COM add-ins / Office Scripts / Office web add-ins** - runtime not available; unsupported parts are preserved in the XLSX package and disclosed on open
- **Power Query, Power Pivot, OLAP data model, Microsoft linked data types** - requires Microsoft infrastructure; metadata is preserved in the XLSX package
- **Microsoft 365 co-authoring, cloud sharing, presence, Teams integration, version history** - requires Microsoft 365 identity and services
- **Enterprise controls** - sensitivity labels, IRM, digital signatures
- **Cube functions** (CUBEMEMBER, CUBEVALUE, etc.) - require a live SSAS/Power Pivot connection
- **External/live data functions** (WEBSERVICE, RTD) - require external service connectivity or real-time data providers
