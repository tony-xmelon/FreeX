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
allow-edit ranges, and PivotTables. Formatting/style tags assert Excel-visible styled cells;
number-format tags assert non-General number-format cells; formatting detail tags assert Excel-visible bold, filled,
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
Public corpus rows with package-only manifest tags also assert their declared package structures on
the produced FreeX-saved ZIPs before Excel opens them: styles/formatting parts, exact content
types, workbook relationships, and cell/row/column style indexes that resolve into `cellXfs`;
worksheet shared-string tables, exact content types, and workbook relationships; workbook sheet
relationship graphs with exact sheet content types, valid sheet names/ids/states, and bounded workbook
view sheet indexes; shared-string cell indexes that resolve into
the shared-string table; hyperlink and merged-cell XML, inline-string cells, hyperlink relationship
graphs, mixed cell types, 31-character sheet-name boundaries, worksheet drawing package graphs
through drawing/chart/image relationships and content types, direct worksheet background-image
package graphs through image relationships and content types, and chartsheet package graphs through
drawing/chart relationships and content types.
Generated supported-metadata rows also assert workbook `fileVersion`, `fileSharing`,
`workbookPr`, `workbookProtection`, `bookViews`, `customWorkbookViews`, `functionGroups`,
`definedNames`, `calcPr`, `fileRecoveryPr`, workbook `extLst` metadata, active workbook theme
package graphs, and active worksheet
`sheetPr`, `cols`, `sheetData`, `sheetProtection`, `protectedRanges`, `sheetViews`, `autoFilter`, `customSheetViews`, `mergeCells`, sort-state, data-consolidation, `conditionalFormatting`, `dataValidations`, `printOptions`,
`pageMargins`, `pageSetup`, `headerFooter`, page-break, and worksheet `extLst` metadata when present, including schema
order, view ids, pane/selection references, boolean/integer attributes, known
view/function/sort/page-setup values, `printOptions` flags, file-version edit/build ids,
workbook file-sharing flags and attributes, workbook-property flags, workbook-property enum values,
default theme versions, sheet-property flags, workbook-protection flags, workbook-protection spin
counts, workbook view flags, indexes, visibility values, custom-view GUIDs,
workbook function-group built-in counts and names, workbook defined-name names, scope ids, and flags,
workbook calculation modes, reference modes, ids, counts, and delta values, workbook
file-recovery flags, extension-list entry URIs, workbook theme relationship targets, content types,
root elements, color/font/format scheme containers, `syncRef` values, sheet-property child slots, page-margin values,
header/footer flags and child slots, custom-sheet-view GUIDs, view/state values, pane/selection refs,
child payload shape, worksheet-protection flags/spin counts/hash attrs, protected-range refs/names/ext payloads,
AutoFilter refs/filter-column ids/filter payloads, column ranges/row refs/cell refs/formula payloads, merge-cell counts/refs/overlaps, conditional-formatting order/refs/priorities/dxf refs/rule payloads, data-validation counts/refs/types/formula slots,
`brk` ids/ranges, and `dataRefs` counts.
Worksheet phonetic-property metadata is also checked for schema order, `fontId`, known phonetic
type/alignment values, and attribute-only payload shape.
Excel-saved copies assert the same Excel-stable public
package structures after `SaveCopyAs`, excluding inline-string encoding because desktop Excel may
normalize those cells into shared strings without a repair.

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
`--corpus-id <id>` is also repeatable and is useful for focused package-retention regressions,
for example:

```powershell
dotnet run --project tools/FreeX.ExcelOpenSmoke -- --save-reopen --freex-resave-before-excel --generate-supported-corpus-fixtures --corpus-manifest test-corpus\manifest.csv --corpus-id generated-slicers-001
```

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
- Any produced FreeX-saved or Excel-saved package containing repair/recovery log XML is reported as
  a workbook validation failure.
- FreeX-saved copies and Excel-saved copies are validated with the Open XML SDK Microsoft 365
  schema validator; any package-open or schema error is reported as a workbook validation failure.
- FreeX-saved and Excel-saved packages must also keep the package root wired as an XLSX workbook:
  `_rels/.rels` must contain an `officeDocument` relationship to `xl/workbook.xml`, and
  `xl/workbook.xml` must have the SpreadsheetML workbook content type.
- Active document-properties package graphs are validated in every FreeX-saved and Excel-saved
  package: package-root core, extended, and custom property relationships must target canonical
  `docProps/*.xml` parts with exact content types and root elements, and standard `docProps` parts
  must have matching root relationships.
- Active workbook `fileVersion` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must remain before later workbook metadata, known edit/build
  id attributes must remain nonnegative integers, and child payloads are rejected.
- Active workbook `fileSharing` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must remain before later workbook metadata,
  `readOnlyRecommended` must remain boolean, `spinCount` must remain unsigned, known text
  attributes must remain non-empty when present, and child payloads are rejected.
- Active workbook `workbookPr` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the element must remain before workbook protection, views, sheets, and later
  workbook metadata, known booleans and enum values must remain valid, `defaultThemeVersion` must
  remain nonnegative, and child payloads are rejected.
- Active workbook `workbookProtection` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must remain before views, sheets, and later workbook metadata,
  known boolean flags must remain valid, `spinCount` must remain nonnegative, and child payloads
  are rejected.
- Active workbook `bookViews` and `customWorkbookViews` metadata is validated in every FreeX-saved
  and Excel-saved package when present: containers must remain before later workbook metadata,
  view/custom-view entries must exist, known visibility/boolean/index attributes and GUIDs must
  remain valid, and unexpected child payloads are rejected.
- Active workbook `functionGroups` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the container must remain before later workbook metadata,
  `builtInGroupCount` must remain unsigned, `functionGroup` names must remain non-empty, and
  unexpected child payloads are rejected.
- Active workbook `definedNames` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the container must remain before later workbook metadata, `definedName`
  entries, when present, must keep non-empty names, scope/function-group ids and known flags
  must remain valid, and unexpected child payloads are rejected.
- Active workbook `calcPr` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the element must remain before later workbook metadata, known calculation and
  reference modes must remain valid, known booleans and unsigned counts/ids must remain valid,
  `iterateDelta` must remain finite and nonnegative, and child payloads are rejected.
- Active workbook `fileRecoveryPr` metadata is validated in every FreeX-saved and Excel-saved
  package when present: each block must remain before later workbook metadata, known recovery
  flags must remain boolean, and child payloads are rejected.
- Active workbook `extLst` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the extension-list block must remain after earlier workbook metadata, contain
  `ext` entries with non-empty unique `uri` values, and avoid malformed container children.
- Active worksheet hyperlink package graphs are validated in every FreeX-saved and Excel-saved
  package: each `<hyperlink r:id>` must resolve to a worksheet hyperlink relationship with an
  external target, while internal location-only hyperlinks remain valid without a relationship.
- Active worksheet background-image package graphs are validated in every FreeX-saved and
  Excel-saved package: each worksheet `<picture r:id>` must resolve to a worksheet image
  relationship whose target exists and has an image content type.
- Active worksheet printer-settings package graphs are validated in every FreeX-saved and
  Excel-saved package: each worksheet `pageSetup r:id` and printer-settings relationship must
  resolve to an internal `xl/printerSettings/*.bin` part with the exact content type.
- Active worksheet custom-property package graphs are validated in every FreeX-saved and
  Excel-saved package: each worksheet `customPr r:id` must resolve through the worksheet
  relationship part to an internal worksheet custom-property binary part with the exact content
  type, and orphan custom-property relationships or binary parts are rejected.
- Active worksheet scenario metadata is validated in every FreeX-saved and Excel-saved package:
  worksheet `scenarios/scenario` entries must have names, consistent `count` and `inputCells`
  entries, local worksheet refs, literal `val` attributes, and valid boolean/index attributes.
- Active worksheet `sheetPr` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the element must remain first before later worksheet metadata, known booleans
  must stay valid, optional `syncRef` values must remain local worksheet refs, supported child
  slots (`tabColor`, `outlinePr`, and `pageSetUpPr`) must be unique and schema-ordered, and
  unexpected or nested child payloads are rejected.
- Active worksheet `dimension` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must stay before later worksheet metadata, carry a valid
  local cell or range `ref`, and remain attribute-only. Desktop Excel may normalize the saved
  `ref` as it recalculates the used range, so the smoke gate validates structure rather than an
  exact range string.
- Active worksheet `cols` and `sheetData` structure is validated in every FreeX-saved and
  Excel-saved package: column groups must stay before `sheetData`, `sheetData` must stay before
  later worksheet metadata, column min/max ranges must be valid, row refs must stay unique and
  ascending, cell refs must stay local and unique, row/cell/formula known attributes must stay
  well-formed, `f`/`v`/`is`/`extLst` child slots must stay schema-ordered, and row/cell extension
  payloads must stay well-formed.
- Active worksheet `sheetFormatPr` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must stay in schema order before `cols`/`sheetData` and
  later worksheet metadata, numeric/default-size attributes must remain nonnegative, outline
  levels must stay within Excel's 0-7 range, known booleans must remain valid, and child payloads
  are rejected.
- Active worksheet `sheetCalcPr` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must stay after `sheetData` and before later worksheet
  metadata, `fullCalcOnLoad` must remain a valid package boolean, retained `calcId` values must
  remain nonnegative integers, and child payloads are rejected.
- Active worksheet `sheetProtection` and `protectedRanges` metadata is validated in every
  FreeX-saved and Excel-saved package when present: protection blocks must stay in schema order,
  known protection booleans, spin counts, and hash attributes must remain valid, protected ranges
  must carry valid local `sqref` refs, duplicate names/refs are rejected, and protected-range
  extension payloads must stay well-formed.
- Active worksheet `autoFilter` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the block must stay in worksheet schema order, refs must remain local, filter
  columns must have unique nonnegative ids, filter/custom/top10/dynamic/color/icon/date-group
  payloads must keep valid typed attributes, nested sort-state refs are checked, and extension
  payloads must stay well-formed.
- Active worksheet `customSheetViews` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the container must stay in worksheet schema order, each view must carry a
  valid unique GUID, known view/state/boolean/numeric attributes must stay valid, pane and selection
  refs must remain local worksheet refs, and supported child payloads must stay schema-ordered.
- Active worksheet `mergeCells` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the container must stay in worksheet schema order, declared counts must match
  `mergeCell` entries, merge refs must remain local worksheet ranges, duplicate/overlapping ranges
  are rejected, and child payloads are rejected while native attributes remain tolerated.
- Active worksheet `conditionalFormatting` metadata is validated in every FreeX-saved and
  Excel-saved package when present: each block must stay in worksheet schema order, `sqref`
  ranges must remain local, rule priorities and `dxfId` references must stay valid, common
  boolean/operator/time-period attributes must stay well-formed, formula and payload child slots
  must stay schema-ordered, color-scale, data-bar, and icon-set payloads must keep valid
  thresholds/colors, and extension payloads must stay well-formed.
- Active worksheet `dataValidations` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the container must stay in worksheet schema order, declared counts must
  match `dataValidation` entries, `sqref` ranges must remain local, known type/operator/error/IME
  values and boolean/window attributes must stay valid, formula child slots must stay ordered and
  text-only, and extension payloads must stay well-formed.
- Active worksheet `printOptions` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must stay after prior worksheet metadata and before page
  margins/setup, header/footer, page breaks, and later worksheet metadata, known flags must remain
  valid package booleans, and child payloads are rejected.
- Active worksheet `pageMargins` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the element must stay after prior worksheet metadata and before setup,
  header/footer, page breaks, and later worksheet metadata, modeled margin/header/footer values
  must remain nonnegative package decimals, and child payloads are rejected.
- Active worksheet `pageSetup` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the element must stay after prior worksheet metadata and before header/footer,
  page breaks, and later worksheet metadata, known enum values must remain recognized,
  numeric attributes must remain nonnegative, known booleans must remain valid, and child payloads
  are rejected. Any `pageSetup r:id` printer-settings reference is also covered by the
  printer-settings package-graph gate.
- Active worksheet `headerFooter` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the element must stay after prior worksheet metadata and before page
  breaks and later worksheet metadata, known booleans must remain valid, modeled header/footer
  child slots must stay unique and in schema order, and unexpected child payloads are rejected.
- Active worksheet page-break metadata is validated in every FreeX-saved and Excel-saved package
  when present: `rowBreaks` and `colBreaks` must stay in schema order, counts must remain
  consistent with `brk` entries, break ids and spans must stay within worksheet bounds, known
  booleans must remain valid, and unexpected child payloads are rejected.
- Active worksheet diagnostic metadata is validated in every FreeX-saved and Excel-saved package
  when present: `cellWatches` must stay before `ignoredErrors`, watched cells must be unique
  local cell refs, and `ignoredErrors` entries must carry valid local `sqref` ranges with valid
  known boolean flags and attribute-only payloads.
- Active worksheet `singleXmlCells` metadata is validated in every FreeX-saved and Excel-saved
  package when present: the block must remain in schema order before later worksheet metadata,
  contain `singleXmlCell` entries with nonnegative `id`/`xmlCellPrId` values and local single-cell
  refs, and avoid duplicate ids/refs or unexpected child payloads. Desktop Excel can drop legacy
  single XML cells on `SaveCopyAs`, so absence in Excel-saved packages is still accepted.
- Active worksheet `extLst` metadata is validated in every FreeX-saved and Excel-saved package
  when present: the extension-list block must remain after earlier worksheet metadata, contain
  `ext` entries with non-empty unique `uri` values, and avoid malformed container children while
  preserving vendor-specific extension payloads without interpretation.
- Active smart-tag metadata is validated in every FreeX-saved and Excel-saved package when
  present: workbook `smartTagPr` booleans and `smartTagTypes` declarations must be coherent,
  worksheet `smartTags` entries must carry local cell refs, nonnegative tag types, valid
  `deleted` booleans, and `cellSmartTagPr` key/value attributes. Desktop Excel can drop legacy
  smart tags on `SaveCopyAs`, so absence in Excel-saved packages is still accepted.
- Active workbook external-link package graphs are validated in every FreeX-saved and Excel-saved
  package: each workbook `<externalReference r:id>` must either point to a tolerated external
  workbook relationship target or resolve to an `xl/externalLinks/*.xml` part with the exact
  external-link content type and external workbook-path relationship.
- Active workbook calc-chain package graphs are validated in every FreeX-saved and Excel-saved
  package: workbook calc-chain relationships must resolve to an internal calc-chain part with the
  exact content type and root element, and each calc-chain cell entry must keep a cell reference and
  valid workbook sheet id when one is present.
- Active custom XML package graphs are validated in every FreeX-saved and Excel-saved package:
  each custom XML relationship must resolve to an XML item part whose item relationship part points
  to a custom XML properties part with the exact content type and `datastoreItem` metadata.
- Active slicer/timeline package graphs are validated in every FreeX-saved and Excel-saved
  package: workbook cache refs, worksheet visual refs, and drawing control relationships must
  resolve to slicer/timeline parts with exact relationship types, content types, and root elements.
- Metadata rows can declare required Excel-saved package parts. The smoke then opens the
  Excel `SaveCopyAs` ZIP and fails if any required package part disappeared; this now covers the
  generated printer-settings, calc-chain, header/footer legacy-drawing, slicer, timeline,
  external-link, and custom XML package rows.
- Public corpus rows with package-only tags assert the tagged XML/package structures on FreeX-saved
  workbooks and the Excel-stable subset on Excel-saved workbooks, so public style, hyperlink,
  style-relationship, hyperlink-relationship, merged-cell, shared-string-table/relationship,
  inline-string, mixed-cell-type, sheet-name-boundary, and chartsheet package graph regressions are
  caught in the desktop Excel smoke instead of only in in-memory IO tests.
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
  for FreeX-saved and Excel-saved outputs, and it also checks that saved ZIP package part names are
  canonical and unique, that saved packages contain no repair/recovery log XML, that
  `[Content_Types].xml` declarations are well-formed, unique, non-stale, and give every saved ZIP
  part an effective content type, that relationship parts use the OPC relationship content type
  and no ordinary package part masquerades as relationship XML, and that every saved `.rels` part
  has valid relationship XML, well-formed relationship declarations, and non-external targets that
  resolve to package parts before the workbook is accepted.
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
  open/save/reopen path. Printer-settings, calc-chain, document-property, header/footer
  legacy-drawing, worksheet legacy-drawing, slicer, timeline, external-link, and custom XML
  rows additionally assert that their required package parts, effective content types, and package
  relationships remain present in FreeX-saved ZIPs before Excel opens them; printer-settings,
  calc-chain, document-property, header/footer legacy-drawing, slicer, timeline, external-link,
  and custom XML rows also assert Excel-retained effective content types after desktop Excel
  `SaveCopyAs`, with the same Excel-saved check covering retained part presence. Printer-settings,
  calc-chain, document-property, header/footer legacy-drawing, slicer, timeline, external-link,
  and custom XML rows also assert the Excel-retained relationship subset after desktop Excel `SaveCopyAs`,
  while printer-settings, calc-chain, header/footer legacy-drawing, slicer, timeline,
  external-link, and custom XML rows assert Excel-saved package parts directly.
  In addition to those row-specific MIME checks, every FreeX-saved and Excel-saved package in the
  smoke run must have canonical unique ZIP package part names, no repair/recovery log XML,
  well-formed, unique, non-stale `[Content_Types].xml` declarations with effective content-type
  coverage for all ZIP parts, exact relationship-part content-type semantics, a package-root
  `officeDocument` relationship
  to `xl/workbook.xml` with the SpreadsheetML workbook content type, parseable relationship parts,
  well-formed relationship declarations, and existing package targets for every non-external
  relationship, plus workbook sheet relationship graphs with exact worksheet, chartsheet,
  dialogsheet, and macrosheet content types, direct `sheets` children, unique valid sheet names and
  sheet ids, known sheet states, and bounded workbook view `firstSheet`/`activeTab` indexes,
  workbook theme package graphs whose workbook
  relationships resolve to internal `xl/theme/*.xml` parts with exact content types, DrawingML
  `theme` root elements, and color/font/format scheme containers, and shared-string package graphs whose `t="s"` cells
  resolve to existing `xl/sharedStrings.xml` entries, and styles package graphs whose cell, row,
  and column style indexes resolve into `xl/styles.xml` `cellXfs` entries, plus stylesheet
  metadata whose top-level order, singleton containers, `colors`, `dxfs`, `tableStyles`, dxf
  references, and extension-list payloads remain valid, document-properties
  package graphs whose package-root relationships resolve to canonical `docProps` parts with exact
  content-type declarations and root elements, worksheet background image package graphs whose
  `<picture>` references resolve to image package parts with image content types, worksheet
  printer-settings package graphs whose `pageSetup r:id` references resolve to printer-settings
  binary parts with exact content-type declarations, workbook `fileVersion` metadata whose schema
  order, edit/build ids, and attribute-only payload remain valid, workbook `fileSharing` metadata
  whose schema order, read-only flag, count/string attributes, and attribute-only payload remain
  valid, workbook `workbookPr` metadata whose schema order, known boolean flags, enum values,
  default theme version, and attribute-only payload remain valid, workbook `workbookProtection`
  metadata whose schema order, known boolean flags, spin count, and attribute-only payload remain
  valid, workbook `bookViews`/`customWorkbookViews` metadata whose schema order, view containers,
  known flags/indexes, visibility values, GUIDs, and payload shape remain valid, workbook `functionGroups` metadata whose schema order, built-in counts, child names, and
  payload shape remain valid, workbook `definedNames` metadata whose schema order, names,
  scope ids, flags, and payload shape remain valid, workbook `calcPr` metadata whose schema order, modes, booleans, ids/counts, delta values,
  and attribute-only payload remain valid, workbook `fileRecoveryPr` metadata whose schema order,
  recovery flags, and attribute-only payload remain valid, workbook `extLst` metadata whose schema
  order, entry URIs, and container shape remain valid, worksheet custom-property package graphs whose
  `customPr r:id` references resolve to internal custom-property binary parts with exact
  content-type declarations, worksheet scenario metadata whose `scenario` counts, refs, values,
  and boolean/index attributes remain internally consistent, worksheet `sheetPr` metadata whose
  schema order, known boolean flags, sync refs, and child slots remain valid, worksheet `dimension` metadata
  whose schema order, local used-range refs, and attribute-only payload remain valid, worksheet `cols`/`sheetData`
  structure whose schema order, column ranges, row refs, cell refs, formula payloads, and extension payload shape remain valid, worksheet `sheetFormatPr` metadata
  whose schema order, size attributes, outline levels, and known boolean flags remain valid, worksheet `sheetCalcPr` metadata
  whose schema order, boolean flags, and retained calculation ids remain valid, worksheet `conditionalFormatting` metadata
  whose schema order, local refs, rule priorities, dxf refs, rule payloads, thresholds/colors, and extension payload shape remain valid, worksheet `dataValidations` metadata
  whose schema order, counts, local refs, known type/operator/error/IME values, boolean/window attributes, formula slots, and extension payload shape remain valid, worksheet `printOptions` metadata
  whose schema order, known boolean flags, and attribute-only payload remain valid, worksheet `pageMargins` metadata
  whose schema order, margin/header/footer values, and attribute-only payload remain valid, worksheet `pageSetup` metadata
  whose schema order, known enum values, numeric attributes, boolean flags, and attribute-only payload remain valid, worksheet `headerFooter` metadata
  whose schema order, known boolean flags, and child slot payload remain valid, worksheet page-break metadata whose
  `rowBreaks`/`colBreaks` order, counts, `brk` ids/ranges, and known boolean flags remain valid, worksheet diagnostic metadata whose
  `cellWatches`/`ignoredErrors` order, cell refs, `sqref` ranges, and known boolean flags remain valid, worksheet `singleXmlCells` metadata
  whose schema order, required ids, single-cell refs, and property ids remain valid, worksheet `extLst` metadata whose
  schema order, entry URIs, and container shape remain valid, and workbook external-link package graphs
  whose `<externalReference r:id>` entries either point to external workbook relationship targets
  or resolve to external-link parts with exact content-type and external workbook-path
  relationships, custom XML package graphs whose XML
  item parts resolve to `datastoreItem` properties parts with exact content-type declarations, and
  slicer/timeline package graphs whose workbook cache refs, worksheet visual refs, and drawing
  control relationships resolve to matching package parts with exact relationship and content-type
  declarations, and worksheet drawing package graphs whose drawing/chart/image references resolve
  to drawing, chart, and image package parts with matching relationship and content-type
  declarations, legacy comment and VML package graphs whose worksheet comment, `legacyDrawing`,
  `legacyDrawingHF`, and VML image references resolve to matching package parts with exact
  relationship and content-type declarations, worksheet
  table package graphs whose `tableParts` references resolve to table package parts with exact
  relationship and content-type declarations and whose table XML has valid ids, local refs,
  tableColumns counts/ids/names/formulas, table AutoFilter/sortState payloads, style-info flags,
  and extension payload shape, and PivotTable package graphs whose worksheet
  pivot-table references, workbook pivot-cache references, pivot-cache records references, and
  pivot-table cache bindings resolve to matching package parts with exact relationship and
  content-type declarations.
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
