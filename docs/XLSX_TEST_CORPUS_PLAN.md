# FreeX XLSX Test Corpus Plan

**Status:** Executable scaffold active  
**Last updated:** 2026-06-04
**Goal:** Build a 100+ workbook corpus that measures whether FreeX preserves supported Excel workbook content while clearly reporting excluded or deferred features.

Current executable manifest baseline: 176 rows (121 generated, 25 public, 21 local-private, 9 regression).

## Acceptance Target

- Minimum corpus size: 100 `.xlsx` files.
- Release target: at least 95% of corpus files open and save without data loss for supported modeled features.
- Reporting unit: one workbook counts as pass only when all supported feature checks pass for that workbook.
- Unsupported-package content is not a failure when FreeX detects it and reports it through the documented warning path before save.

## Corpus Buckets

| Bucket | Count | Purpose | Required Checks |
|---|---:|---|---|
| Basic grid data | 20 | Plain workbooks with numbers, text, blanks, booleans, dates, and errors | Values, sheet names, dimensions |
| Formulas | 20 | Common arithmetic, aggregate, lookup, date/time, text, logical, and cross-sheet formulas | Formula text, cached values when present, recalc result |
| Formatting | 15 | Fonts, fills, borders, alignment, wrapping, number formats, style-only empty cells | Style IDs, rendered display text, cell style properties, plus Excel-visible smoke counters for styled cells and non-General number-format cells |
| Structure | 10 | Multiple sheets, hidden rows/columns, row heights, column widths, freeze panes, merged regions | Model metadata plus Excel-visible smoke counters for merged areas, freeze panes, hidden rows/columns, custom dimensions, and outline groups |
| Named ranges and validation | 10 | Defined names, list validation, numeric/date/text/custom validation, input/error messages | Native model records, XLSX round-trip |
| Conditional formatting | 10 | Modeled conditional-format rules plus unknown/future rules retained from native XML | Supported rules preserved, unknown rules retained |
| Objects and links | 10 | Comments, hyperlinks, images, text boxes, basic shapes, sparklines | Native objects, warning behavior for unsupported records |
| Charts | 10 | Native supported chart families, current chartEx families, and richer unsupported package chart parts | Supported native/chartEx chart model, explicit unsupported warnings for Map or unparseable package parts |
| Protection and page setup | 5 | Sheet/workbook protection, allow-edit ranges, margins, print areas, print titles, orientation, scaling, print options, headers/footers, manual page breaks | Protection/page setup model properties and Excel-visible smoke counters |

Total planned minimum: 110 files. The extra 10 files provide slack for corrupted, duplicate, or license-ineligible samples.

## Source Mix

| Source | Target Count | Inclusion Rules |
|---|---:|---|
| Locally generated fixtures | 37 | Created by deterministic tests or helper scripts; no external license risk. |
| Public government/open-data spreadsheets | 25 | Must have explicit public/open license; retain source URL and retrieval date in manifest. |
| Public sample workbooks from library/vendor docs | 20 | Must allow test redistribution or be generated from documented examples. |
| User-provided local workbooks | 21 | Must be approved for local testing; manifest stores only filename, feature tags, and anonymized notes unless user allows more detail. The manifest now includes 20 optional rows that are skipped until local files are supplied plus the user-approved Partner Dashboard workbook path for local Excel save/reopen regression coverage. |
| Regression workbooks from fixed bugs | 10 | Minimal workbooks committed with tests when they reproduce a specific fixed behavior. The regression bucket now exists; binary fixtures are added only with redistribution approval. |

## Repository Layout

Keep binary samples out of source control until license and size policies are decided.

```text
test-corpus/
  README.md
  manifest.csv
  generated/
  public/
  local-private/
  regressions/
```

`local-private/` must remain ignored by Git. User-approved absolute local workbook paths are allowed only for explicitly named private samples. Public and regression samples can be committed only after confirming redistribution rights.

## Manifest Schema

`test-corpus/manifest.csv` should use these columns:

```csv
id,path,source_type,source_url,retrieved_on,license,feature_tags,expected_warnings,expected_status,notes
```

Allowed `source_type` values:

- `generated`
- `public`
- `local-private`
- `regression`

Allowed `expected_status` values:

- `supported-pass`
- `supported-known-gap`
- `supported-pivot-metadata-pass`
- `supported-metadata-pass`
- `public-pass`
- `excluded-warning-pass`
- `corrupt-or-invalid`

## Round-Trip Check Procedure

1. Open the workbook through `XlsxFileAdapter`.
2. Capture a feature summary from the loaded `Workbook` model.
3. Save to a temporary `.xlsx`.
4. Reopen the saved file.
5. Compare supported model features against the first loaded model.
6. Verify expected unsupported/excluded warnings were emitted.
7. Verify feature tags that have deterministic model or Excel-visible signals, such as named ranges, hyperlinks, merged cells, chart counts, formatting/number-format counters, structure counters, page setup/protected-range counters, and cell-type content.
8. Compare retained critical package parts and relationship targets for known-gap packages.
9. Record pass/fail by workbook and by feature bucket.

## Required Report

The Sprint 2 report should be written to `docs/XLSX_CORPUS_REPORT.md` and include:

- Corpus size and bucket counts.
- Pass rate by workbook.
- Pass rate by feature bucket.
- Top 10 failures by user impact.
- Unsupported/excluded feature warning counts.
- A prioritized fix list mapped back to `docs/COMMAND_SURFACE_PARITY.md`.

## First Implementation Tasks

1. [x] Create `test-corpus/README.md` explaining the folder policy and license rules.
2. [x] Create `test-corpus/manifest.csv` with the schema above and generated fixture rows.
3. [x] Add an ignored `test-corpus/local-private/` entry to `.gitignore`.
4. [x] Add a non-networked corpus runner test that reads the manifest and skips missing private files.
5. [x] Generate the first 10 deterministic workbooks from existing model APIs.
6. [x] Run the corpus runner locally and publish the first `docs/XLSX_CORPUS_REPORT.md`.

## Exclusions Are Not Failures

The following content should count as a pass only when detected, disclosed, and retained as opaque package content where safe:

- VBA projects and macros.
- Microsoft 365 Share/co-authoring state.
- Power Query, Power Pivot, data model relationships, and OLAP artifacts.
- Embedded/OLE objects and custom package parts outside the FreeX model.

