# FreeX Code Review — 2026-06-18 (Iteration 4: the three deferred workstreams)

Took on all three items deferred after iterations 1–3, using parallel investigation agents + delegated implementation agents. Mid-iteration, `origin/main` landed a large concurrent ribbon refactor (`FreeX.Ribbon.Definitions` extraction + restyle + slicer rendering, ~60 commits) that **superseded** most of the UI-lane workstream — so this iteration ships the independent, non-superseded wins and documents the rest honestly.

## 1. Chart "Value From Cells" round-trip fidelity (the High deferred item) — DELIVERED

Excel's per-series range data labels (`c15:datalabelsRange`) were read but never written, so the emoji/percent labels were stripped on XLSX save and never persisted to `.fxl`.

- **Model:** added `ChartSeriesRangeDataLabels` (per-series `c15:f` formula + `ptCount` + cached points) with correct structural equality; the flat `RangeDataLabels` the renderer uses stays in sync.
- **Reader:** `XlsxChartDataLabelReader.ApplyRangeDataLabels` now captures `c15:f` + `c15:ptCount` + cached pts (tolerant of both `c15` and `c` namespaces); wired into the bar-series loops too.
- **Writer:** `XlsxChartXmlWriter.Series` re-emits the `c:ext[uri={02D57815-…}]/c15:datalabelsRange` block (formula + `dlblRangeCache` with `ptCount`) as the last child of every `c:ser`; guards against degenerate/empty definitions (Excel-repair risk).
- **Native `.fxl`:** DTO persists `SeriesRangeDataLabels` and rebuilds the flat list on load.
- **Tests:** new `XlsxChartRangeDataLabelsTests` (reader capture, XLSX write-back, FXL round-trip).
- **Caveat:** the `c15` ext structure/uri is MS-ODRAWXML-spec-derived — no sample workbook with range labels exists in the repo to validate against real Excel.

Verification: `Core.IO.Tests` 2633 passed / 0 failed on current `origin/main`.

## 2. WPF UI lane — mostly SUPERSEDED by main; one real product bug fixed

I triaged all 131 `FreeX.App.Host.Tests` failures (85 deterministic / 46 environmental) and an implementation agent fixed all 85. **But while that was in flight, `origin/main` extracted the ribbon into `FreeX.Ribbon.Definitions` and fixed the same source-hygiene/parity tests with a better-integrated approach** (`DialogSourceTestSupport.ReadRibbonDefinitionSource` + a generated `FreeXRibbonHandlerMap.g.cs`). My test-infrastructure rewrite (`RibbonXamlCatalogSnapshotReader` projecting from the catalog) conflicted fundamentally with theirs, so I **dropped the superseded UI-lane commit** rather than force a broken mixed merge.

**Kept (still real on current `main`, independent of the ribbon refactor):**
- **Accessibility + localization of the `UpdateReadyIndicator` button** — it still ships a hardcoded English ToolTip and no `AutomationProperties.Name`. Switched ToolTip/label/Name to `{local:Loc Key=…}` and added the 3 keys to all 44 locale resx files. Fixes `LocalizationUsageTests` + `MainWindowXamlKeyTipTests`.

**Noted for main's ribbon workstream (not re-applied, to avoid colliding with their active refactor):**
- The XAML→declarative extraction dropped ampersands/qualifiers from several ribbon group headers ("Get Transform" → should be "Get & Transform Data", "Sort Filter" → "Sort & Filter", "Layouts" → "Chart Layouts", …) and lost the Insert Slicer / Insert Function commands. My agent had restored these to Excel parity; since `origin/main` owns the ribbon definition now, this is flagged for that workstream rather than re-applied here.
- The Format Painter persistent-click preview handler and 4 Borders submenu handlers were dropped in the cutover — same disposition.
- The 46 environmental UI tests (`MainWindowAdaptiveRibbonTests`, `RibbonAdaptiveMeasurementCacheTests`, `RibbonResizeCoordinatorTests`, `MainWindowRibbonKeyTipTests`) need an interactive desktop and only pass on a rendering host.

## 3. Minor items

- **Done:** corrected the `DrawFormControlSunkenEdge` comment to match the edges it actually draws.
- **Deferred with rationale:** `DrawingObjectEffect.Opacity` default 0→1 (JSON round-trip/equality risk for ~0 value); Avalonia status-bar view-model cache (marginal allocation savings vs. invalidation-correctness risk).

## Verification
`FreeX.slnx` Release build **0/0**; `FreeX.DefaultTests.slnx` **all green** (~19,970 tests, incl. the new chart round-trip tests); the localization + accessibility test classes pass (90 tests).
