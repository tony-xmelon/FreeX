# XLSX IO performance — large workbooks

Status as of 2026-06-14. Benchmark workbook: 3 sheets × 20 000 rows × 15 cols
= 900 045 cells, 4.8 MB on disk (FreeX-generated, canonical grid).

<!-- VERIFY: numbers below are ~2 months stale as of this audit (2026-08-08); IO work continued after this
     snapshot (e.g. startup pipeline prewarm landed 2026-06-14 same day, COIN XLSM open optimization
     2026-06-20, and further patch-save fix/feature commits since). The qualitative picture (ClosedXML-bound
     open, patch-save much closer to Excel than a full save) still matches the current codebase shape
     (XlsxFileAdapter still wraps ClosedXML), but re-run the benchmark below before citing exact figures. -->

Generate: `dotnet run --project tools/FreeX.AppIoBench -c Release -- --generate
--out %TEMP%\freex-large.xlsx --rows 20000 --cols 15 --sheets 3`

Measure a single-cell patch-save: `--path %TEMP%\freex-large.xlsx --edit
existing-literal --cell B5 --value patched --repeat 3`.

Excel COM baseline on the identical file (en-US): **open ≈ 2.0 s, full SaveAs
≈ 1.6 s**. (Temp-folder files open read-only under Protected View, so measure
open + SaveAs rather than editing in place.)

## Where we stand

| Operation        | Excel | FreeX (orig)  | FreeX (now)   |
|------------------|-------|---------------|---------------|
| Open (steady)    | ~2.0s | ~16s          | ~7.9s         |
| Save (1 cell)    | ~1.6s | ~92s / 13 GB  | ~5s / 0.6 GB  |

Save is now within ~3× of Excel (was ~57×). Open is ~4× Excel (was ~8×).

Open phase split (steady-state ~7.9 s): `closedxml_workbook_open` ≈ 3.66 s
(ClosedXML's own parse), `workbook_materialize` ≈ 1.70 s (FreeX),
`package_metadata` ≈ 0.83 s, `sheet_xml_layout` ≈ 0.79 s, `package_prep`
≈ 0.81 s (was ~2.6 s before the load grid-scan fix). ClosedXML's parse is now
the single largest phase (~46%).

## What was fixed

- **Patch-save normalizers** no longer load every worksheet's full cell
  XDocument to confirm a no-op. Header-only normalizers run through
  `XlsxWorksheetHeaderNormalization` (pruned, sheetData-less, memoized); the
  grid normalizer uses a streaming "already canonical" pre-scan
  (`XlsxWorksheetGridXmlNormalizer.IsWorksheetGridCanonical`) that reuses the
  normalizer's exact predicates over an `XmlReader`. Pre-flight r-less-row
  guard is streaming.
- **Load sanitizer** `HasWorksheetGridXmlSchemaIssues` (run on every load, its
  hint is always null because the answer depends on cell content) now uses the
  same streaming scan instead of a full per-worksheet XDocument load. This cut
  `package_prep` from ~2.6 s to ~0.8 s and ~640 MB off open allocation, taking
  steady-state open from ~10 s to ~7.9 s.

## Remaining opportunities (ranked)

1. **Open is ClosedXML-bound (largest gap, largest effort).** After the
   sanitizer fix the dominant phase is `closedxml_workbook_open` ≈ 3.66 s —
   ClosedXML's own parse, irreducible without replacing it. The big win —
   reading cells with FreeX's own streaming reader and dropping ClosedXML for
   the bulk load — is a large architectural change (styles, shared strings,
   defined names, formula model all currently come from ClosedXML). Deferred.

2. **`workbook_materialize` (~1.8 s, FreeX code).** Converting the XLWorkbook
   into FreeX's model. Worth profiling for allocation churn / redundant lookups;
   a self-contained win that does not touch ClosedXML.

3. **Save: skip the grid canonical re-scan on repeated saves.** The scan reads
   every cell on each save. After a successful patch the output grid is
   canonical, so the re-captured `XlsxSourcePackage` could carry a per-sheet
   "grid canonical" flag and skip the scan on saves 2+. Helps interactive
   edit→save→edit→save sessions (not a single cold save). Threading the flag
   through `SheetXmlLayout`/`XlsxSourcePackage` is moderate plumbing.

4. **Save: redundant worksheet decompressions.** A single patch-save currently
   decompresses worksheets several times (r-less pre-flight, grid scan, header
   prune, streaming cell patch, post-loop re-prune). The post-loop
   `InvalidateAll` re-prune is conservative; it could be skipped when the cell
   loop changed no header elements. Small, low-risk.

## Notes / gotchas

- The streaming canonical scan is **conservative**: anything it cannot prove
  canonical (cell/row `extLst`, `cm`/`vm` metadata indices, foreign-namespace
  attributes, values that re-serialize differently) is reported non-canonical so
  the authoritative full normalizer runs. A false "dirty" only costs a full
  load; a false "canonical" would corrupt output, so every uncertain branch
  returns dirty.
- ClosedXML recompresses only the rewritten worksheet entry on patch-save
  (`CompressionLevel.Fastest`); untouched entries are copied as raw compressed
  bytes. The patched file is slightly larger than the source for this reason.
