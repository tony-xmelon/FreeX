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
  relative tolerance, text/bool exact). FreeX's loaded value vs Excel's `Value2`.
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
pwsh tools/Run-FidelityBatch.ps1                 # fetch corpus, build, run all
pwsh tools/Run-FidelityBatch.ps1 -Filter chart   # only files whose name contains "chart"
pwsh tools/Run-FidelityBatch.ps1 -Tolerance 1    # allow up to 1% of cells to differ
pwsh tools/Run-FidelityBatch.ps1 -SkipFetch      # skip the download step
```

Or directly: `tools/FreeX.FidelityCompare.exe [--filter <substr>] [--out <dir>] [--tolerance <pct>]`.

## The corpus

The library is catalogued in `fidelity-corpus/manifest.csv`; only the manifest and the downloader
(`tools/Fetch-FidelityCorpus.ps1`) are committed. The workbooks themselves download into the git-ignored
`fidelity-corpus/files/` folder, so no third-party binaries are redistributed from this repo. The seed
catalogue is Apache POI test data (Apache-2.0) chosen for broad feature coverage; add your own complex
workbooks as `source=local` rows (they stay git-ignored). See `fidelity-corpus/README.md`.

## Interpreting results

These are real third-party files, so some diffs are expected and informative rather than bugs:

- **Formula-fixture files** (e.g. POI's `FormulaEvalTestData`) deliberately stage edge-case formulas and
  expected-result columns; a high value-mismatch count there is a prompt to investigate whether FreeX's
  loaded/recomputed value really diverges from Excel, not an automatic defect.
- **Chart counts** can differ when FreeX models a chart differently than Excel counts `ChartObjects` +
  chart sheets — worth a look, but check the underlying file before filing a gap.

Treat the run as a triage surface: start from `mismatches.txt`, confirm against the actual workbook, and
open a focused regression (or a `test-corpus` row) for anything that is a genuine FreeX fidelity gap.
