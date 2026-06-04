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

Those generated chart workbooks now assert chart counts separately from generic worksheet shapes,
and they use the same no-FreeX-load-warning gate when FreeX reload checkpoints are part of the
selected workflow.

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

The full generated supported corpus can also be generated from `test-corpus/manifest.csv` and
validated through the same FreeX-edited path:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --freex-resave-before-excel --generate-supported-corpus-fixtures --corpus-manifest test-corpus\manifest.csv
```

This generates the manifest rows backed by `XlsxCorpusFixtureFactory` under the run directory,
including both `supported-pass` model fixtures and `supported-metadata-pass` package fixtures by
default. It adds feature-tag expectations for formulas, structured tables, AutoFilter sheets, data validation,
conditional formatting, named ranges, charts, hyperlinks, comments, images, sparklines,
text boxes/shapes, formatting/styles/number formats, structure, protection, page setup,
allow-edit ranges, and PivotTables. Formatting/style tags assert Excel-visible styled cells and
non-General number-format cells; formatting detail tags assert Excel-visible bold, filled,
bordered, aligned, and wrapped cells where present. Structure tags assert Excel-visible merged
areas, freeze panes, hidden rows/columns, custom row/column dimensions, and outline rows/columns.
Page setup tags now assert Excel-visible print areas, print titles, landscape orientation,
scale-to-fit, print gridlines/headings, headers/footers, and manual page breaks. Use
`--corpus-status <status>` to narrow the generated set for focused runs.

Formula, named-range, structured table, AutoFilter, chart, validation/conditional-format, hyperlink/comment,
drawing/shape, sparkline/image, formatting/style/number-format/border/detail, structure,
protection/page-setup, allow-edit-range, and PivotTable feature
fixtures have retention expectations, not just passive summary counts. When `--save-reopen` is used, the smoke fails if
FreeX cannot load the expected feature metadata before Excel opens the staged workbook, if Excel
open/reopen loses the expected formula cells, named ranges, structured tables, AutoFilter sheets, charts, validation
cells, conditional-format rules, hyperlinks, comments, worksheet/workbook protection, worksheet
pictures, sparklines, text boxes, drawing shapes, Excel-visible formatting/number-format/detail,
structure/page setup/protected-range metadata, or PivotTables, or if FreeX cannot reload the Excel-saved copy with the expected metadata
still present. These supported FreeX-authored feature fixtures also fail on any FreeX load warning
before Excel or after reloading Excel's saved copy.

Excel-side feature probes are expectation-driven for manifest rows: the smoke always opens/saves and
reopens selected workbooks, but it only asks desktop Excel for expensive per-feature counts when the
row's tags require those counts. Inputs without feature expectations validate Excel openability and
repair-free SaveCopyAs without forcing unrelated empty table/pivot/formatting probes.
For generated and local-private supported corpus rows without declared warning expectations, the
smoke also fails on any FreeX load warning before Excel or after reloading Excel's saved copy.
Public corpus rows without declared warning expectations now participate in the same no-warning
assertion unless their manifest tags identify an unsupported or excluded warning-tolerated surface,
such as the public chartsheet retention row.

## Excel-authored through FreeX

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --generate-excel-fixture
```

That command creates an Excel-authored workbook through COM under the run directory, including a
native table, data validation, conditional formatting, comment, hyperlink, text box, named range,
worksheet/workbook protection, and native PivotTable/pivot cache. It then loads and saves the
workbook through `XlsxFileAdapter`, then validates the FreeX-saved copy with the same Excel
open/`SaveCopyAs`/close/reopen sequence.
The FreeX-first path adds a small `FreeXSmoke` marker worksheet before saving so the adapter writes
a new package instead of preserving an unchanged source package.
The Excel-authored fixture is also warning-free: FreeX must emit zero load warnings when saving the
native Excel source and when reloading Excel's saved copy.

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

The local-private Partner Dashboard row `local-private-partner-dashboard-20250116` carries
additional retention gates when the file is present. The FreeX-resaved path must retain at least
`16000` formulas, `1` table, `3` PivotTables, `1` pivot cache, `5` validations, `47` hyperlinks,
`117` comments, `1` picture, and `120` Excel-visible worksheet shapes; Excel open/save/reopen must
also preserve the hyperlink, comment, and picture counts. Conditional-format retention is gated at
`100` rules before Excel opens the FreeX-saved copy and `66` rules after Excel save/reopen,
reflecting Excel's normalization of duplicate status-text rules in that workbook. The row also
participates in the supported-workbook no-warning gate: FreeX must emit zero load warnings before
Excel and zero load warnings after reloading Excel's saved copy.

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
- FreeX-saved copies and Excel-saved copies are validated with the Open XML SDK Microsoft 365
  schema validator; any package-open or schema error is reported as a workbook validation failure.
- Metadata rows can declare required Excel-saved package parts. The smoke then opens the
  Excel `SaveCopyAs` ZIP and fails if any required package part disappeared; this now covers the
  generated slicer, timeline, and custom XML package rows.
- Excel-saved `calcChain.xml` style-reference validation errors are ignored when Excel itself wrote
  the copy, because Excel can emit those after a successful open/save/reopen cycle without a repair
  log. The same schema issue still fails when it appears in a FreeX-saved workbook.
- Open XML SDK can reject legacy Excel metadata children (`smartTagPr`, `smartTags`, and
  `singleXmlCells`) even when desktop Excel opens, saves, and reopens the workbook without repair
  logs. The smoke ignores only those legacy-child diagnostics; unrelated schema errors still fail.
- Excel-saved `pageSetup` DPI minimum-value diagnostics are ignored only when Excel itself wrote the
  copy after a successful open/save/reopen cycle. The same schema issue still fails when it appears
  in a FreeX-saved workbook.
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

As of 2026-06-04 on the local desktop Excel COM environment:

- FreeX-authored feature fixtures passed Excel open/`SaveCopyAs`/close/reopen plus FreeX reopen:
  `8/8`, including the authored PivotTable/pivot-cache fixture, with zero FreeX load-warning rows
  after reloading Excel-saved copies.
- FreeX-authored feature fixtures also passed the authored-then-FreeX-edited path
  (`--freex-resave-before-excel --generate-freex-feature-fixtures`): `8/8`, with zero FreeX load
  warnings before Excel and after reloading Excel-saved copies.
- The Excel-authored fixture, including a native Excel PivotTable and pivot cache, passed
  Excel-authored -> FreeX save/edit -> Excel open/`SaveCopyAs`/close/reopen -> FreeX reopen:
  `1/1`. The fixture also covers an Excel-authored text box, comment, hyperlink, worksheet
  protection, and workbook structure protection. The FreeX source load and reopened Excel save both
  reported `pivots 1; pivot caches 1`; FreeX emitted zero load warnings at both load checkpoints;
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
- Excel-side metadata assertions now cover validation/conditional formatting too: the validation/CF
  fixture must expose validation cells and `4` conditional-format rules through Excel open/reopen.
- Excel-side formatting assertions now cover generated supported-pass formatting/style rows through
  Excel open/reopen: styled cells, non-General number-format cells, bold cells, filled cells,
  bordered cells, aligned cells, and wrapped cells are asserted where tagged. Focused 2026-06-04
  formatting-detail verification passed the three tagged formatting rows, and the stabilized
  expectation-driven smoke restored the full generated `supported-pass` run to `52/52` after FreeX
  resave, including `generated-grid-basic-001`. Earlier generated `supported-pass` runs caught a
  built-in Excel number-format ID load regression before the fix.
- Excel-side page setup and protected-range assertions now cover the protection/page fixture through
  Excel open/reopen: `1` print-area sheet, `1` print-title sheet, `1` landscape sheet, `1`
  scale-to-fit sheet, `1` print grid/headings sheet, `1` header/footer sheet, `2` manual page
  breaks, and `1` allow-edit range.
- Excel-side structure assertions now cover generated supported-pass structure rows through Excel
  open/reopen, including merged areas, freeze-pane sheets, hidden rows/columns, custom row/column
  dimensions, and outline rows/columns where tagged. A focused 2026-06-04 generated
  `supported-pass` run passed `52/52` after FreeX resave with those counters enabled.
- FreeX-side metadata assertions passed for validation/conditional formatting (`3` validations,
  `4` conditional formats), hyperlinks/comments (`3` hyperlinks, `1` comment),
  images/sparklines (`1` picture, `2` sparklines), text/drawing shapes (`1` text box, `1` drawing
  shape), protection (`1` protected sheet, workbook structure protection), and the Excel-authored
  fixture (`1` validation, `1` conditional format, `1` hyperlink, `1` comment, `1` text box).
  Representative metadata-heavy FreeX-saved outputs passed Open XML SDK schema validation with
  `errors=0`.
- Public + regression corpus rows selected from `test-corpus/manifest.csv` with
  `--save-reopen --freex-resave-before-excel --corpus-source public --corpus-source regression`
  passed: `34/34`; the supported public rows without unsupported-surface tags now also require
  zero FreeX load warnings before Excel and after reloading Excel-saved copies.
- The 34 FreeX-saved corpus workbooks from that run also passed Open XML SDK schema validation:
  `errors=0` for every file. The Excel smoke harness now performs this schema validation directly
  for FreeX-saved and Excel-saved outputs.
- The local-private Partner Dashboard regression row
  `local-private-partner-dashboard-20250116` passed
  `--save-reopen --freex-resave-before-excel`: `1/1`, with the manifest retention gates above.
  The original workbook was rejected by direct Excel COM open with `0x800A03EC`, while the
  FreeX-saved copy opened, saved, reopened, reloaded in FreeX, and passed Open XML SDK schema
  validation with `errors=0`. The stricter supported-workbook gate also passed with zero FreeX load
  warnings before Excel and zero FreeX load warnings after reloading Excel's saved copy.
- Generated `supported-metadata-pass` corpus rows selected from `test-corpus/manifest.csv` with
  `--save-reopen --freex-resave-before-excel --generate-supported-corpus-fixtures --corpus-status supported-metadata-pass`
  passed: `52/52`. This covers printer settings, workbook and worksheet smart tags, worksheet
  single XML cells, slicers, timelines, external links, custom XML, calc chains, document
  properties, and worksheet/workbook native metadata in the repair-free desktop Excel
  open/save/reopen path. Slicer, timeline, and custom XML rows additionally assert that their
  required package parts remain present in Excel-saved ZIPs; the generated external-link placeholder
  row remains covered by FreeX package-retention tests and repair-free Excel open/save/reopen, but
  is not yet promoted to an Excel-saved package-part retention assertion because desktop Excel drops
  those placeholder external-link parts on `SaveCopyAs`.
  Concrete Excel-visible feature assertions are enabled for non-native metadata rows whose package
  fixtures surface charts, data validation, or conditional formatting, plus selected native
  metadata rows that desktop Excel exposes as workbook structure protection, worksheet protection,
  protected ranges, workbook defined names, header/footer text, x14 sparklines, structured-reference
  formula cells, structured tables, cross-sheet formulas, and the twelve-name workbook fixture.
- The default generated corpus command now selects all materializable generated supported rows,
  covering `supported-pass` plus `supported-metadata-pass` fixtures in one bidirectional
  FreeX-resave -> desktop Excel save/reopen gate. The current default generated corpus run passed
  `104/104`: `52` supported-pass rows and `52` supported-metadata-pass rows, with zero FreeX load
  warning rows before Excel and zero FreeX load-warning rows after reloading Excel-saved copies.

The 2026-06-03 corpus pass specifically covers prior Excel/OpenXML failures from invalid
`styles.xml` ordering (`dxfs`/`tableStyles`/`colors`), invalid `workbook.xml` ordering
(`workbookPr` before `workbookProtection`), dangling authored pivot-style `dxfId` references,
missing authored pivot cache records, missing pivot data-field markers, and invalid preserved
`x14:workbookPr/@defaultImageDpi` values, plus generated metadata failures from a placeholder
printer-settings binary, worksheet `singleXmlCells` ordering, and legacy smart-tag schema
diagnostics that desktop Excel accepts without repair logs.
