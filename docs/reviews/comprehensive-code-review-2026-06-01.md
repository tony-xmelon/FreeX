# FreeX Comprehensive Source Review — 2026-06-01

## 0. Method & Honest Coverage Statement

Fresh full-codebase pass on the latest synced `main` (HEAD `7b7ab770c`), focused on
identifying improvement areas as the app approaches completion. Approach: structural survey
(~209 KLOC source across 7 projects); high-signal pattern sweeps (exception handling,
sync-over-async, `async void`, culture-sensitive parsing, debt markers, resource disposal,
non-determinism); status refresh of the deferred backlog from the 2026-05-30 review; targeted
reads of the largest/hottest and most recently-churned files; and verification of every
grep-level signal before reporting it.

This review is **incremental** on top of two recent comprehensive reviews (2026-05-28,
2026-05-30) and the heavy chart/XLSX/perf churn since. Deep line-by-line correctness coverage
of all 209 KLOC is not claimed; the correctness baseline leans on the recent prior reviews plus
the now-extensive automated gates (see §4). Findings below are the genuinely-new or
status-changed items.

**Headline:** the codebase remains **mature, disciplined, and in good health.** The single
biggest issue discovered since the last review — **FreeX-authored XLSX did not open in Microsoft
Excel at all** — has been fully fixed and independently verified (plain workbooks, classic
charts, and all supported chartEx families now open in real Excel). The pattern sweeps came back
clean: no `NotImplementedException`, no `TODO/FIXME/HACK` markers, no `Thread.Sleep` in product
code, disciplined invariant-culture numeric parsing, and no sync-over-async or `async void`
anti-patterns. The remaining improvement areas are the **known deferred perf/architecture items**
(one of which, O1, has since landed) plus incremental maintainability/test-quality polish.

## 1. Verified resolved / improved since 2026-05-30

- **P0 (new, found+fixed this cycle): FreeX XLSX now opens in Excel.** Root causes were a
  schema-invalid modeled `theme1.xml` (blocking every workbook) and schema-invalid chart parts
  (blocking any workbook with a chart). Both fixed and verified three ways — Open XML SDK
  validator, real Excel via COM, and a chart-interop comparison harness (28/28 cases). New tools
  `tools/FreeX.ExcelOpenSmoke` and `tools/FreeX.ChartInteropCompare`, plus the permanent
  `XlsxSchemaValidationTests` gate, now guard this. (Re-verified in this review: smoke tool opened
  FreeX histogram + waterfall 2/2 in Excel.)
- **O1 — `FormattedText` per-cell allocation (was P1 perf): substantially addressed.** The render
  lane added `GridView.TextLayoutCache.cs` (keyed caches for default/wrapped/width/**shrink-probe**
  `FormattedText`) and `GridView.RenderSurfaceCache.cs`. This covers both halves of O1 (cache +
  remove per-probe shrink allocation). Recommend a `performance/baseline.md` measurement to close it
  formally and downgrade from the backlog.
- **Drag resize-preview regression (P2, flagged 2026-06-01): fixed.** `MainWindowMouseResizeTests`
  is 8/8 green again (was 2 failing on `ViewportCallCount`); addressed by the viewport side-pane
  refresh guard.

## 2. Still-open deferred items (verified present today)

These remain as recorded in `planning/outstanding-build.md`; none are correctness/security/data-loss.

- **O2 — transient evaluator allocations (perf, P2).** No `ArrayPool`/`ObjectPool` in
  `FreeX.Core.Formula`/`FreeX.Core.Calc`; per-binary-op `ScalarValue[,]` allocations remain.
- **F4 — sheet/all recalc always full-rebuilds dependencies (perf, P2).** `RecalculateAllFormulas`
  and `RecalculateSheetFormulas` both call `RebuildFormulaDependencies(workbook)` unconditionally
  ([RecalcEngine.cs:267,276](../../src/FreeX.Core.Calc/RecalcEngine.cs#L267)). Correct but does
  whole-workbook dependency work on every sheet recalc; needs dirty-tracking to do safely.
- **O4 — no explicit `Reapply` command contract (stability, P3).**
- **O5 — ad hoc per-command snapshot types (maintainability, P3).**
- **O6/O7 — god-object models with public-mutable collections; manual UI invalidation
  (architecture, P3, large/deferred).**
- **O8 — single-threaded recalc (perf, deferred by design).**

## 3. New observations (this review)

### N1 — Large host files / `MainWindow` god partial (maintainability, P3)

`FreeX.App.Host` is ~80 KLOC; `MainWindow` is spread across dozens of partials, several
1,000–2,300 lines (`MainWindow.Ribbon.cs` 2,330; `MainWindow.RibbonAdaptive.cs` 1,574;
`MainWindow.SheetTabs.cs` 1,433; `MainWindow.Selection.cs` 1,220). `FormulaEvaluator.cs` is
3,179 lines. These are internally consistent and well-factored into partials, but the sheer size
raises the cost of change and review. This is the same architecture-debt class as O6/O7 —
deferred, but worth continued extraction of pure logic into testable planners (the pattern
already used well across the codebase, e.g. the chart/window planners).

### N2 — Broad exception swallowing concentrated in XLSX IO (reliability/fidelity, P3)

~47 broad catches (bare `catch {` / `catch (Exception)`), heavily concentrated in
`FreeX.Core.IO` XLSX read/write (`XlsxStructuredTableWriter` 7, `XlsxWorkbookThemeWriter` 5,
`XlsxAdvancedConditionalFormatWriter` 4, etc.). Most are the deliberate "fall back to modeled
content / skip malformed XML" pattern. The 2026-05-30 review already narrowed the worst case
(`XmlNativeBagSerializer` → `catch (XmlException)`). Recommend continuing that precedent: narrow
these to the specific expected exceptions (`XmlException`, `FormatException`,
`InvalidOperationException`) so genuinely-unexpected failures (OOM, IO errors, logic bugs)
surface instead of silently degrading fidelity, and route the fallbacks through a diagnostic
counter rather than an empty body.

### N3 — Writer snapshot tests can enshrine invalid OOXML (test quality, P2-process)

The Excel-openability P0 was masked for a long time because the XLSX tests round-tripped only
through FreeX's own lenient reader / ClosedXML, and some writer tests asserted the *buggy* output
verbatim — e.g. a chartEx test that asserted `dataId="data0"` (schema-invalid; must be a
`UInt32`) gave false green. The new `XlsxSchemaValidationTests` (Open XML SDK, Excel-independent)
plus the Excel-open smoke and chart-interop harness are the correct fix-pattern. Recommendation:
prefer schema/round-trip/Excel-open assertions over verbatim writer-string snapshots, and extend
the schema-validation gate to broader workbook fixtures (not just charts) so this class of bug
cannot regress silently.

### N4 — Verified clean (negative results worth recording)

- **Culture safety:** no risky single-arg `double.Parse`/2-arg `double.TryParse` in core; numeric
  parsing consistently passes `CultureInfo.InvariantCulture`/`NumberStyles` (verified — the raw
  grep counts were all multi-line invariant calls). Important given the app runs on non-English
  Windows.
- **Async/threading:** no sync-over-async blocking (`Task.Result`/`.Wait()` on the UI path); the
  three `async void` methods are legitimate (the `MainWindow_Closing` handler uses the correct
  cancel-then-reclose idiom with a re-entrancy guard).
- **Resource disposal:** one-off `FileStream`/`File.Create` without `using` is not a systemic
  pattern (1 site).
- **Determinism:** the only core `DateTime.Now` is the `NOW()` worksheet function (correct — Excel
  local-time volatile), not hidden non-determinism.
- **Debt markers:** zero `TODO`/`FIXME`/`HACK`/`XXX`, zero `NotImplementedException`, one
  documented `#pragma warning disable` (ClosedXML obsolete-API shim).

## 4. Automated-gate inventory (what now protects correctness)

The verification surface has grown substantially and is a real strength: `FreeX.Core.IO.Tests`
(1,447+), `XlsxSchemaValidationTests` (Open XML SDK schema gate over all chart types),
`tools/FreeX.ExcelOpenSmoke` (real-Excel open of generated chart fixtures),
`tools/FreeX.ChartInteropCompare` (28-case FreeX↔Excel render+package+round-trip parity), formula
parity suites, and the ribbon/keytip/inventory snapshot guards. This is the most effective defense
against fidelity regressions and should be kept green as the writers evolve.

## 5. Prioritized improvement backlog (this review)

| Priority | Item | Area | Notes |
|---|---|---|---|
| P2 | N3 — prefer schema/Excel-open assertions over writer-string snapshots; widen schema gate to non-chart fixtures | Test quality | Process + incremental tests |
| P2 | O2 — pool transient `ScalarValue[,]`/argument buffers (needs `performance/baseline.md`) | Perf | Deferred, needs baseline |
| P2 | F4 — delta-drive sheet/all recalc instead of full dependency rebuild (needs dirty-tracking) | Perf | Deferred, correctness-sensitive |
| P3 | N2 — narrow broad XLSX-IO catches to specific exception types + diagnostics | Reliability/fidelity | Mechanical, per-file |
| P3 | N1 — continue extracting pure planners out of large `MainWindow`/`FormulaEvaluator` files | Maintainability | Ongoing |
| P3 | O4/O5/O6/O7 — `Reapply` contract, shared `SheetSnapshot`, read-only model + events | Architecture | Large, deferred by design |
| —  | O1 — `FormattedText`/render caching | Perf | **Landed**; close after a perf-baseline measurement |

## 6. Scope-completion assessment

No correctness, security, or data-loss findings in this pass. The most consequential risk to
shipping — Excel-openability of FreeX output — moved from *silently broken* to *fixed and
gated*. `release/progress.json` remains at `overallCompletion: 95` (`v0.8.<run>` band); the
honest gates to a higher number are the human-dependent release items already owned by other
workstreams (XLSX fidelity pass/fail proof, MSIX signing + installer trust, live screen-reader
accessibility validation), not the engineering items above. The remaining engineering backlog is
deferred perf + architecture polish, none of it blocking.

## 7. Build / baseline

Full solution build on `main` HEAD `7b7ab770c` (`dotnet build FreeX.slnx --disable-build-servers
-p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`): **Build succeeded, 0 Warning(s),
0 Error(s).** `FreeX.Core.IO.Tests` confirmed green (1,447) during the chart-fidelity work this
cycle, and the Excel-open smoke + chart-interop harness pass.
