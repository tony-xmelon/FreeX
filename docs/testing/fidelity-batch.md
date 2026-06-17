# On-demand FreeX ↔ Excel fidelity batch

`tools/FreeX.FidelityCompare` opens a library of complex real-world `.xlsx` files in **both** FreeX and
desktop Microsoft Excel and compares them. It is deliberately **separate from the build/test/release
flow** — nothing in CI or the test projects references it, because it needs Excel installed (COM
automation) and is comparatively slow. Run it by hand when you want a broad real-world fidelity read.

It complements the in-build corpus (`tools/FreeX.ExcelOpenSmoke`, `docs/formats/xlsx-corpus-report.md`),
which uses generated/redistributed fixtures and runs in CI. This batch instead exercises a curated
library of feature-rich third-party workbooks.

## What it checks (functional axis)

For every corpus workbook it records, from FreeX (`FreeX.Core.IO` loader) and from Excel (COM):

- **Openability** — FreeX loads without throwing; Excel opens without raising.
- **Computed cell values** — cell-by-cell over the intersection of occupied cells (numbers within
  relative tolerance, text/bool exact), FreeX vs Excel's `Value2`.

### Two modes: load-fidelity vs compute-fidelity

- **Default (load-fidelity):** FreeX's *loaded* values (the file's cached formula results) vs Excel's live
  values. Catches loader bugs (e.g. time cells parsed as text) but masks engine gaps when the file's cache
  already matches Excel, and can show false diffs when a file ships a stale cache that Excel recomputes.
- **`--recalc` (compute-fidelity):** recomputes every FreeX formula through the engine
  (`RecalcEngine.RecalculateAllFormulas`, which passes each cell as `currentCell` so `COLUMN()`/`ROW()`
  resolve) before comparing — i.e. FreeX's engine vs Excel. This is the truer fidelity measure and surfaces
  engine gaps directly. It is noisier on workbooks built around **legacy array / implicit-intersection**
  formulas (e.g. `=A7:J7*B15` in one cell): Excel resolves the range to the single intersecting cell (a
  scalar via the implicit `@`), whereas FreeX spills the whole array → `#SPILL!`, with cascades into
  dependents. On the current Apache-POI seed corpus, the 2026-06-05 compute sweep passed 18/21; the 3 fails
  are POI's formula-engine torture fixtures and surfaced two real, sizeable gaps for follow-up: **implicit
  intersection** (the `#SPILL!` pattern above) and **`TEXT()` / number-format-code** handling (e.g. the `?`
  digit-placeholder and comma scaling emit literal placeholder characters instead of a formatted number).
- **Feature inventory** — sheets, charts, pivot tables, tables, comments. `namedRanges` and `hyperlinks`
  are recorded as raw per-side counts but **not** diffed: Excel's `Names` includes hidden built-ins
  (`Print_Area`, `_FilterDatabase`, table names) and its `Hyperlinks` auto-detects URL-like text, so the
  counts diverge for reasons that are not fidelity gaps. Conditional formats and data validations are
  inventoried on the FreeX side only (no cheap Excel COM count).

A file **FAILs** only on unambiguous functional differences: more than `--tolerance` percent of compared
cells differ, or a sheet is missing/extra. Charts/pivots/tables/comments diffs are surfaced for review but
do not auto-fail (COM counting methodology varies). **Every** individual value mismatch is logged to
`mismatches.txt` regardless of pass/fail, so low-frequency real gaps stay visible even on a passing file.
Output lands in a timestamped run folder: `results.csv` (per-file metrics), `mismatches.txt` (sampled
diffs), and `README.md` (summary table).

> Visual (pixel) comparison is a planned **next phase**. FreeX has no headless worksheet→image API yet
> (only `ChartRenderer` for charts), so whole-sheet rendering needs the WPF grid hosted headlessly or a
> PDF-export + rasterizer, then a perceptual-hash diff (the machinery in `FreeX.ChartInteropCompare`'s
> visual-evidence code is reusable for that step).

## Running it

From the repo root, with desktop Excel installed:

```powershell
pwsh tools/Run-FidelityBatch.ps1                 # fetch corpus, build, run all (load-fidelity)
pwsh tools/Run-FidelityBatch.ps1 -Recalc         # compute-fidelity: recompute FreeX formulas vs Excel
pwsh tools/Run-FidelityBatch.ps1 -Filter chart   # only files whose name contains "chart"
pwsh tools/Run-FidelityBatch.ps1 -Tolerance 1    # allow up to 1% of cells to differ
pwsh tools/Run-FidelityBatch.ps1 -SkipFetch      # skip the download step
```

Or directly: `tools/FreeX.FidelityCompare.exe [--filter <substr>] [--out <dir>] [--tolerance <pct>] [--recalc]`.

## The corpus

The library is catalogued in `fidelity-corpus/manifest.csv`; only the manifest and the downloader
(`tools/Fetch-FidelityCorpus.ps1`) are committed. The workbooks themselves download into the git-ignored
`fidelity-corpus/files/` folder, so no third-party binaries are redistributed from this repo. The catalogue
uses Apache POI test data (Apache-2.0) plus targeted MIT-licensed fixtures from ClosedXML, Open XML SDK, and
PhpSpreadsheet for form controls, ActiveX controls, dropdown validation, Budget-vs-Actual chart data, and
emoji/unicode strings. It is chosen for broad feature coverage across formulas, tables, pivots, charts,
conditional formatting, drawings, sparklines, worksheet structure, protection, and page setup; add your own
complex workbooks as `source=local` rows (they stay git-ignored). See `fidelity-corpus/README.md`.

## Interpreting results

These are real third-party files, so some diffs are expected and informative rather than bugs:

- **Formula-fixture files** (e.g. POI's `FormulaEvalTestData`) deliberately stage edge-case formulas and
  expected-result columns; a high value-mismatch count there is a prompt to investigate whether FreeX's
  loaded/recomputed value really diverges from Excel, not an automatic defect.
- **Chart counts** can differ when FreeX models a chart differently than Excel counts `ChartObjects` +
  chart sheets — worth a look, but check the underlying file before filing a gap.

Treat the run as a triage surface: start from `mismatches.txt`, confirm against the actual workbook, and
open a focused regression (or a `test-corpus` row) for anything that is a genuine FreeX fidelity gap.
