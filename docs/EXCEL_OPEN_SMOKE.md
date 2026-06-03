# Real Excel XLSX open/save/reopen smoke

`tools/FreeX.ExcelOpenSmoke` is a Windows-only COM smoke check for `.xlsx` interoperability with
desktop Microsoft Excel. It exists because Open XML SDK validation can pass while Excel still
rejects a workbook during `Workbooks.Open`, `SaveCopyAs`, or a later reopen.

Run from the repo root.

## FreeX-authored open/save/reopen

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --generate-freex-fixture
```

That command writes a non-chart FreeX workbook under
`%USERPROFILE%\freex-xlsx-verify\excel-smoke\<timestamp>\generated`, stages the exact file Excel
will open, then validates:

1. Excel opens the FreeX-created XLSX.
2. Excel writes an `.xlsx` copy with `SaveCopyAs`.
3. Excel closes the workbook.
4. Excel reopens the saved copy.
5. FreeX loads the Excel-saved copy through `XlsxFileAdapter`.

Chart fixture coverage is still available:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --generate-chart-fixtures
```

The broader FreeX feature fixture set covers formulas, validation, conditional formatting, tables,
links/comments, images/sparklines, shapes/text boxes, PivotTables/pivot caches, protection, and
page setup:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --generate-freex-feature-fixtures
```

Add `--freex-resave-before-excel` to make those generated FreeX workbooks load/save through FreeX
with an actual marker-sheet edit before Excel opens them:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --freex-resave-before-excel --generate-freex-feature-fixtures
```

Formula, structured table, drawing/shape, and PivotTable feature fixtures have retention
expectations, not just passive summary counts. When `--save-reopen` is used, the smoke fails if
FreeX cannot load the expected feature metadata before Excel opens the staged workbook, if Excel
open/reopen loses the expected formula cells, structured tables, worksheet shapes, or PivotTables,
or if FreeX cannot reload the Excel-saved copy with the expected metadata still present.

## Excel-authored through FreeX

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --generate-excel-fixture
```

That command creates an Excel-authored workbook through COM under the run directory, including a
native table, data validation, conditional formatting, comment, hyperlink, text box, named range,
and native PivotTable/pivot cache. It then loads and saves the workbook through `XlsxFileAdapter`,
then validates the FreeX-saved copy with the same Excel open/`SaveCopyAs`/close/reopen sequence.
The FreeX-first path adds a small `FreeXSmoke` marker worksheet before saving so the adapter writes
a new package instead of preserving an unchanged source package.

To validate an existing Excel-created or Excel-modified workbook through the same FreeX-first path:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --freex-resave-before-excel C:\Users\anton\freex-xlsx-verify\excel-authored.xlsx
```

## Existing files

Open-only smoke remains available for existing files:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- C:\Users\anton\freex-xlsx-verify\H_histogram_fixed.xlsx C:\Users\anton\freex-xlsx-verify\I_waterfall_fixed.xlsx
```

Use `--save-reopen` to make the same inputs prove Excel save/reopen plus FreeX reopen:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen C:\Users\anton\freex-xlsx-verify\H_histogram_fixed.xlsx C:\Users\anton\freex-xlsx-verify\I_waterfall_fixed.xlsx
```

## Corpus manifest smoke

Existing `.xlsx` files in `test-corpus/manifest.csv` can be selected directly by manifest row. This
is the repeatable desktop-Excel pass for public, regression, and populated local-private corpus
samples:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --freex-resave-before-excel --corpus-manifest test-corpus\manifest.csv --corpus-source public --corpus-source regression
```

`--corpus-source <source_type>` and `--corpus-status <expected_status>` are repeatable filters.
When no status filter is supplied, the tool selects `supported-pass`, `supported-metadata-pass`,
`supported-pivot-metadata-pass`, and `public-pass` rows. Missing generated or local-private files are
reported as skipped, not silently ignored.

## Operational details

- Run output, generated fixtures, staged workbooks, FreeX-saved copies, and Excel-saved copies live
  under `%USERPROFILE%\freex-xlsx-verify\excel-smoke\<timestamp>` by default.
- Every run writes `%runDirectory%\excel-smoke-report.json` with selected corpus rows, skipped
  corpus rows, per-workbook paths, summary counts, and failure details.
- `--out <directory>` can choose a different run directory, but it must stay under `%USERPROFILE%`
  to avoid Excel Protected View behavior.
- Directory inputs use `--pattern <glob>`, defaulting to `*.xlsx`.
- The process sets `Thread.CurrentThread.CurrentCulture` and `CurrentUICulture` to `en-US` before
  creating `Excel.Application`.
- Excel is launched with `Visible=false`, `DisplayAlerts=false`, and `AutomationSecurity=3` when
  the installed Excel build accepts that property.
- A COM rejection with `0x800A03EC` is reported as an Excel workbook validation failure.
- In `--save-reopen` mode, an Excel-saved copy containing repair/recovery log XML is reported as a
  workbook validation failure.
- The tool tracks the Excel PID it creates and kills orphan `EXCEL` processes that were not present
  before the smoke run.

Expected use for chart maintenance:

1. Use this tool for focused real-Excel smoke checks when touching chart package writing.
2. Treat the full chart parity source of truth as
   `C:\Users\anton\freex-xlsx-verify\chart-interop\20260601-threedcolumn-caveat-final-main-sync-full`.
3. Treat exit code `0` as "real Excel opened every staged workbook"; any non-zero exit needs triage
   before handoff, with new failures compared against the 28-case chart interop harness.

Expected result: exit code `0` means every requested workbook completed the selected validation
surface. Any non-zero exit means at least one workbook still needs package repair or the local
machine cannot run desktop Excel COM.

## Verified baseline

As of 2026-06-03 on the local desktop Excel COM environment:

- FreeX-authored feature fixtures passed Excel open/`SaveCopyAs`/close/reopen plus FreeX reopen:
  `8/8`, including the authored PivotTable/pivot-cache fixture.
- FreeX-authored feature fixtures also passed the authored-then-FreeX-edited path
  (`--freex-resave-before-excel --generate-freex-feature-fixtures`): `8/8`.
- The Excel-authored fixture, including a native Excel PivotTable and pivot cache, passed
  Excel-authored -> FreeX save/edit -> Excel open/`SaveCopyAs`/close/reopen -> FreeX reopen:
  `1/1`. The FreeX source load and reopened Excel save both reported `pivots 1; pivot caches 1`,
  and the FreeX-saved workbook passed Open XML SDK schema validation with `errors=0`.
- Pivot retention assertions passed for the FreeX-authored pivot fixture after Excel rewrote the
  workbook/pivot-table cache id to `0`; the FreeX source load and reopened Excel save both reported
  `pivots 1; pivot caches 1`, and the FreeX-saved workbook passed Open XML SDK schema validation
  with `errors=0`.
- Formula and structured-table retention assertions passed for the FreeX-authored feature fixtures
  and the Excel-authored fixture. The final feature fixture smoke reported `formulas 4` for the
  grid/formulas fixture and `tables 1` for the table fixture through Excel open/reopen and FreeX
  reload of the Excel-saved copy; representative FreeX-saved outputs passed Open XML SDK schema
  validation with `errors=0`.
- Excel-side worksheet shape assertions passed for the objects/links, images/sparklines,
  shapes/text, and Excel-authored fixtures. The final feature fixture smoke reported shape counts of
  `1`, `1`, and `2` for those three FreeX-authored drawing fixtures through Excel open/reopen, and
  representative FreeX-saved outputs passed Open XML SDK schema validation with `errors=0`.
- Public + regression corpus rows selected from `test-corpus/manifest.csv` with
  `--save-reopen --freex-resave-before-excel --corpus-source public --corpus-source regression`
  passed: `34/34`.
- The 34 FreeX-saved corpus workbooks from that run also passed Open XML SDK schema validation:
  `errors=0` for every file.
- The local-private Partner Dashboard regression row
  `local-private-partner-dashboard-20250116` passed
  `--save-reopen --freex-resave-before-excel`: `1/1`. The FreeX-saved workbook also passed Open XML
  SDK schema validation with `errors=0`.

The 2026-06-03 corpus pass specifically covers prior Excel/OpenXML failures from invalid
`styles.xml` ordering (`dxfs`/`tableStyles`/`colors`), invalid `workbook.xml` ordering
(`workbookPr` before `workbookProtection`), dangling authored pivot-style `dxfId` references,
missing authored pivot cache records, missing pivot data-field markers, and invalid preserved
`x14:workbookPr/@defaultImageDpi` values.
