# Commands Parity Large Pieces Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the remaining large command-parity gaps through testable waves that keep `main` buildable.

**Architecture:** Preserve the current layered boundaries: PDF export and dialogs in `App.Host`, formatting in `Core.Calc`, PivotTable materialization in `Core.Commands`, durable model state in `Core.Model`, and XLSX/package fidelity in `Core.IO`. Each wave narrows one documented parity gap and updates architecture/parity docs before merge.

**Tech Stack:** C# 12, .NET 10, WPF, PDFsharp-WPF, ClosedXML, xUnit, FluentAssertions.

---

### Task 1: PDF Publish Options And Bookmark Modes

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/ExportPlanner.cs`
- Modify: `FreeX/src/FreeX.App.Host/ExportOptionsDialog.cs`
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.PrintExport.cs`
- Modify: `FreeX/src/FreeX.App.Host/PdfDocumentExporter.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add failing tests for bookmark modes**

Add tests that construct `ExportOptions` with `PdfBookmarkMode.SheetNames`, `PdfBookmarkMode.PrintTitles`, and `PdfBookmarkMode.PageNumbers`, then assert `ExportPlanner.DescribeOptions` names each mode.

- [x] **Step 2: Add the model**

Add `PdfBookmarkMode { None, SheetNames, PrintTitles, PageNumbers }` and replace `bool CreateBookmarks` with `PdfBookmarkMode BookmarkMode`. Preserve compatibility through `ExportOptionsDialog.CreateResult(..., bool createBookmarks)` by mapping `true` to `SheetNames`.

- [x] **Step 3: Generate bookmark captions**

Update `MainWindow.CreatePdfBookmarks` so sheet mode keeps current sheet names, print-title mode uses a sheet print-title summary when available and falls back to sheet name, and page-number mode writes `Page 1`, `Page 2`, etc. after page-range filtering.

- [x] **Step 4: Verify and commit**

Run:

```powershell
dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "FullyQualifiedName~ExportPlannerTests" -v minimal
dotnet build FreeX\FreeX.slnx --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v minimal
```

Commit:

```powershell
git add FreeX\src\FreeX.App.Host\ExportPlanner.cs FreeX\src\FreeX.App.Host\ExportOptionsDialog.cs FreeX\src\FreeX.App.Host\MainWindow.PrintExport.cs FreeX\src\FreeX.App.Host\PdfDocumentExporter.cs FreeX\tests\FreeX.App.Host.Tests\ExportPlannerTests.cs FreeX\docs\ARCHITECTURE.md FreeX\docs\COMMAND_SURFACE_PARITY.md
git commit -m "Expand PDF bookmark publish options"
```

### Task 2: PDF Viewer Publish Options

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/ExportPlanner.cs`
- Modify: `FreeX/src/FreeX.App.Host/ExportOptionsDialog.cs`
- Modify: `FreeX/src/FreeX.App.Host/PdfDocumentExporter.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`

- [x] **Step 1: Add tests for page layout and page mode**

Assert default PDF export uses single-page layout, outline bookmarks set outline mode, and new options can request one-column continuous layout and full-screen mode.

- [x] **Step 2: Add option enums**

Add `PdfInitialView { SinglePage, OneColumn, TwoColumnLeft, TwoColumnRight }` and `PdfOpenMode { Normal, Outlines, FullScreen }` to `ExportPlanner.cs`. Store them on `ExportOptions`.

- [x] **Step 3: Apply viewer preferences**

Update `PdfDocumentExporter` to map initial view to `/PageLayout` and open mode to `/PageMode`, while preserving outline mode when bookmarks are present unless the user explicitly requests full screen.

- [x] **Step 4: Verify and commit**

Run App.Host tests filtered to `PdfDocumentExporter` plus full build, then commit `Add PDF initial view options`.

### Task 3: Selectable PDF Text Overlay Foundation

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/PdfDocumentExporter.cs`
- Create: `FreeX/src/FreeX.App.Host/PdfTextOverlayExtractor.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`

- [x] **Step 1: Add a test document with a `TextBlock`**

Export a one-page `FixedDocument` with a `TextBlock` and assert the PDF content stream contains the text when vector text overlay is enabled.

- [x] **Step 2: Add overlay extraction**

Create `PdfTextOverlayExtractor` that walks `FixedPage.Children`, extracts simple `TextBlock` text, margin, font size, and foreground brush, and returns page-relative overlay records.

- [x] **Step 3: Draw invisible or visible text overlay**

Use PDFsharp text drawing at matching point coordinates after raster draw. Keep raster as visual truth; overlay text should not change page dimensions.

- [x] **Step 4: Verify and commit**

Run `PdfDocumentExporter` tests and full build, then commit `Add selectable PDF text overlay`.

### Task 4: Accounting Width Formatting

**Files:**
- Modify: `FreeX/src/FreeX.Core.Calc/NumberFormatter.cs`
- Modify: `FreeX/tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `FreeX/tests/FreeX.Core.Calc.Tests/ViewportStyleTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add tests for accounting fill alignment**

Add cases for `_($* #,##0.00_);_($* (#,##0.00);_($* "-"??_);_(@_)` that assert positive, negative, and zero outputs keep deterministic symbol, sign, and trailing placeholder spacing.

- [x] **Step 2: Implement accounting section token interpretation**

Teach `PreserveAccountingFillSpace` to account for `_` skip directives and `*` fill directives as deterministic spaces around currency symbols and zero dashes.

- [x] **Step 3: Verify**

Run `NumberFormatterTests` and full build, then commit `Improve accounting layout spacing`.

### Task 5: OS-Localized Date/Time Pattern Provider

**Files:**
- Modify: `FreeX/src/FreeX.Core.Calc/NumberFormatter.DateTime.cs`
- Modify: `FreeX/tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add culture-scoped tests**

Add tests that set `CurrentCulture` to a known culture and assert `[$-F800]` and `[$-F400]` use the culture's long date/time patterns rather than hardcoded invariant strings.

- [x] **Step 2: Use OS/.NET current-culture patterns**

Resolve special Excel system date/time tokens through `CultureInfo.CurrentCulture.DateTimeFormat` while keeping explicit LCID separator mappings deterministic.

- [x] **Step 3: Verify**

Run `NumberFormatterTests` and full build, then commit `Add date time pattern provider`.

### Task 6: PivotTable Compact/Subtotal Merge Fidelity

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.Writers.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add compact subtotal regression**

Test a compact three-row-field PivotTable with `ShowSubtotals = true`; assert nested subtotal captions use the field being subtotaled instead of the first outer row field.

- [x] **Step 2: Refine subtotal caption selection**

Update `WriteSubtotalRow` to derive the visible subtotal caption from the last value in the subtotal key, preserving two-row-field behavior while fixing deeper nested compact layouts.

- [x] **Step 3: Verify**

Run `PivotTableRefreshServiceTests` and full build, then commit `Refine PivotTable compact merges`.

### Task 7: PivotStyle Theme Semantics

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotStylePaletteResolver.cs`
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.Styles.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add tests for theme-driven built-in style colors**

Create a workbook theme with changed accent slots and assert a supported PivotStyle resolves header/stripe colors from the theme instead of fixed RGB.

- [x] **Step 2: Add theme-aware resolver**

Pass `WorkbookTheme` into the resolver and map supported style families to theme slots plus tint values.

- [x] **Step 3: Verify**

Run PivotTable style tests and full build, then commit `Resolve PivotStyles from workbook theme`.

### Task 8: Native Slicer/Timeline Drawing Fidelity

**Files:**
- Modify: `FreeX/src/FreeX.Core.Model/SlicerModel.cs`
- Modify: `FreeX/src/FreeX.Core.Model/TimelineModel.cs`
- Modify: `FreeX/src/FreeX.Core.IO/XlsxSlicerTimelineMetadataReader.cs`
- Modify: `FreeX/tests/FreeX.Core.IO.Tests/FileAdapterSmokeTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add package round-trip tests for anchors**

Extend existing slicer/timeline package fixture tests to assert loaded anchor coordinates and nonvisual shape names are available on `SlicerModel` and `TimelineModel`.

- [x] **Step 2: Model drawing anchors**

Add nullable anchor records with from/to row/column and EMU offsets. Keep missing anchor data null for authored pane-only slicers/timelines.

- [x] **Step 3: Load modeled anchors**

Update XLSX slicer/timeline drawing readers to populate modeled anchors and nonvisual shape names. Source-package merge remains best-effort for unsupported drawing children and continues preserving native drawing XML on save.

- [x] **Step 4: Verify**

Run the slicer/timeline smoke tests and full build, then commit `Model slicer timeline drawing anchors`.

### Task 9: PDF Overlay And Accounting Follow-Up

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/PdfTextOverlayExtractor.cs`
- Modify: `FreeX/src/FreeX.App.Host/FormatCellsDialog.Number.cs`
- Modify: `FreeX/src/FreeX.Core.Calc/NumberFormatter.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`
- Modify: `FreeX/tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Extend selectable PDF text regressions**

Add red tests for `RichTextBox`, `FlowDocumentScrollViewer`, hidden/collapsed elements, headered controls with both
header and body text, and `ItemsControl` UIElement items.

- [x] **Step 2: Refine the PDF overlay extractor**

Skip hidden/collapsed elements, flatten simple flow documents through `TextRange`, include both non-UIElement header and
body text for headered controls, and recurse into UIElement items.

- [x] **Step 3: Correct Accounting command presets and spacing**

Change the Format Cells Accounting preset to the modeled accounting format code, preserve raw multi-character accounting
symbol fill gaps, and keep trailing `_` skip spacing from left-padding target-width display.

- [x] **Step 4: Verify**

Run focused PDF/export, Format Cells, and NumberFormatter tests, then run full build before commit.

### Task 10: PivotTable Merge-And-Center Alignment

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.cs`
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.MergedLabels.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add regression coverage for centered merged labels**

Extend the non-compact repeated outer row-label merge test to assert the retained top-left label cell receives centered
horizontal and vertical alignment.

- [x] **Step 2: Apply alignment after PivotStyle visual formatting**

Run PivotTable visual styling before merge materialization, then update the retained merged-label cell by cloning its
current registered style, setting center/center alignment, and registering the composed style back on the workbook.

- [x] **Step 3: Verify**

Run focused merged-label tests, PivotTable refresh tests, and full build before commit.

### Task 11: Selectable PDF Text For Printed Worksheet Cells

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/PdfTextOverlayExtractor.cs`
- Modify: `FreeX/src/FreeX.App.Host/PrintRenderer.cs`
- Modify: `FreeX/src/FreeX.App.Host/PrintRenderer.HeaderFooter.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add real worksheet PDF overlay regressions**

Add red tests that export a real `PrintRenderer.RenderWorksheet` page and a real `PrintRenderer.RenderWorkbook` page
with `includeSelectableText: true`, then assert the generated PDF stream contains the printed cell strings.

- [x] **Step 2: Carry printed cell text as overlay metadata**

Record displayed cell strings and print coordinates while rendering worksheet `DrawingVisual` pages, attach that overlay
metadata to the `VisualHost`, and preserve it when workbook export clones sheet pages as bitmaps.

- [x] **Step 3: Verify**

Run focused PDF exporter tests and full build before commit.

### Task 12: Format Cells Accounting Decimal Placeholder Fidelity

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/FormatCellsDialog.Number.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add live dialog regression coverage**

Extend the Format Cells Number tab test so Accounting with one selected decimal place and a raw symbol emits one `?`
placeholder in the zero section instead of the two-placeholder preset shape.

- [x] **Step 2: Share the accounting format builder**

Route the live Accounting category composition through the same decimal-count-aware builder used by static format
resolution.

- [x] **Step 3: Verify**

Run focused Format Cells dialog tests and full build before commit.

### Task 13: PivotTable Report-Filter Header Styling

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.Styles.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add report-filter style regression**

Extend the page-field style test to assert materialized report-filter caption and selected-item cells receive the
selected PivotStyle header fill and bold styling.

- [x] **Step 2: Style page-field rows separately from the body**

Apply the existing PivotStyle header visual style to rows occupied by page fields, while preserving the blank separator
row and the shifted body-start calculations for body headers, stripes, subtotals, grand totals, and compact indent.

- [x] **Step 3: Verify**

Run focused PivotTable refresh tests and full build before commit.

### Task 14: PivotStyle Light Theme Semantics

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotStylePaletteResolver.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add Light-family custom-theme regression**

Add a PivotTable refresh test for `PivotStyleLight16` with a custom Accent1 color and assert header, stripe, and grand
total fills resolve through workbook theme tints instead of fixed Office colors.

- [x] **Step 2: Add themed light palette mapping**

Extend `PivotStylePaletteResolver` so non-Office workbooks resolve `PivotStyleLight16` through a light Accent1 tint
palette while preserving existing Office-default fixed snapshots.

- [x] **Step 3: Verify**

Run focused PivotStyle tests and full build before commit.

### Task 15: PivotTable Row Items With No Data

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.ColumnKeys.cs`
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.Writers.cs`
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.MatrixWriter.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Add row no-data regression coverage**

Add row-only and matrix PivotTable refresh tests proving `ShowItemsWithNoDataOnRows` materializes missing row-field
items from PivotCache shared items and displays `EmptyValueText` for generated no-data rows/intersections.

- [x] **Step 2: Reuse cache-backed item expansion for rows**

Introduce a reusable row-group builder that adds empty row groups from PivotCache shared items, then route row-only and
matrix PivotTable writers through it while preserving label filters, value filters, sorting, totals, and matrix column
key generation.

- [x] **Step 3: Verify**

Run focused row no-data tests, PivotTable refresh tests, diff checks, and full build before commit.

### Task 16: PivotTable No-Data Subtotal Empty Text

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.Writers.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`

- [x] **Step 1: Add nested no-data subtotal regression**

Add a row-only PivotTable refresh test with two row fields, cache-backed no-data row items, subtotals enabled, and
`EmptyValueText`, proving a subtotal whose row group has no source records displays the configured empty text instead
of a numeric zero value.

- [x] **Step 2: Route subtotal values through empty-intersection handling**

Pass the PivotTable options into subtotal value-cell writes and mark subtotal values empty when the subtotal row group
contains no source rows.

- [x] **Step 3: Verify**

Run the focused subtotal regression, PivotTable refresh tests, diff checks, and full build before commit.

### Task 17: Custom Number Spaced Indexed Colors

**Files:**
- Modify: `FreeX/src/FreeX.Core.Calc/NumberFormatColorMapper.cs`
- Modify: `FreeX/tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`
- Modify: `FreeX/docs/COMMAND_SURFACE_PARITY.md`
- Modify: `FreeX/docs/MENU_TOOLBAR_PARITY.md`

- [x] **Step 1: Add formatter regression coverage**

Extend custom number color tests so `[Color 5]` and `[ Color 56 ]` resolve to the same indexed colors as compact
`[Color5]` and `[Color56]`.

- [x] **Step 2: Accept Excel's spaced indexed-color syntax**

Relax indexed color token parsing to allow optional whitespace between `Color` and the 1-56 index while preserving the
existing bounds checks and named-color behavior.

- [x] **Step 3: Verify**

Run focused NumberFormatter tests, diff checks, and full build before commit.

### Task 18: PDF Bookmark Option Normalization

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/ExportOptionsDialog.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: `FreeX/docs/ARCHITECTURE.md`

- [x] **Step 1: Add export-options regression**

Add a dialog factory test proving an explicit bookmark mode is ignored when the Create PDF bookmarks checkbox value is
false.

- [x] **Step 2: Gate bookmark mode by the checkbox state**

Normalize `ExportOptionsDialog.CreateResult` so it only carries a non-None `BookmarkMode` when `createBookmarks` is
true; otherwise the resulting options keep bookmarks disabled.

- [x] **Step 3: Verify**

Run focused export planner tests, diff checks, and full build before commit.

### Task 19: Workbook Indexed Colors For Custom Number Formats

**Files:**
- Modify: `FreeX/src/FreeX.Core.Model/Workbook.cs`
- Add: `FreeX/src/FreeX.Core.Model/WorkbookIndexedColorPalette.cs`
- Modify: `FreeX/src/FreeX.Core.Calc/NumberFormatter*.cs`
- Modify: `FreeX/src/FreeX.Core.Calc/ViewportService.cs`
- Add: `FreeX/src/FreeX.Core.IO/XlsxIndexedColorPaletteMapper.cs`
- Modify: `FreeX/src/FreeX.Core.IO/XlsxFileAdapter.cs`
- Modify: `FreeX/src/FreeX.Core.IO/XlsxFileAdapter.SavePostProcessing.cs`
- Modify: focused calc, viewport, and XLSX smoke tests
- Modify: architecture/parity docs

- [x] **Step 1: Add red formatter and viewport regressions**

Add tests proving `[Color 5]` can resolve from a workbook palette override and that viewport display applies the
resolved indexed color to the cloned display style.

- [x] **Step 2: Model and propagate indexed color palettes**

Introduce `WorkbookIndexedColorPalette`, add palette-aware formatter overloads, and pass workbook palette context from
`ViewportService` without mutating registered styles.

- [x] **Step 3: Load and save XLSX indexed colors**

Read stylesheet `indexedColors` into the workbook palette and write authored overrides back to `styles.xml` while keeping
the built-in 1-56 palette as formatter fallback.

- [x] **Step 4: Verify and document**

Run focused NumberFormatter/Viewport tests, focused XLSX indexed-color tests, diff checks, and full build before commit.

### Task 20: Grouped Active-Sheet PDF/XPS Export

**Files:**
- Modify: `FreeX/src/FreeX.App.Host/MainWindow.PrintExport.cs`
- Modify: `FreeX/tests/FreeX.App.Host.Tests/ExportPlannerTests.cs`
- Modify: architecture/parity docs

- [x] **Step 1: Add active-sheet grouping regression**

Add an export planner test proving active-sheet export resolves grouped visible worksheets in workbook order and ignores
hidden grouped sheets.

- [x] **Step 2: Route active-sheet render and bookmarks through selection planning**

Extract grouped sheet selection and render all resolved sheets through the existing print renderer path. Reuse the same
selection for PDF sheet-name bookmark creation.

- [x] **Step 3: Verify and document**

Run focused export planner tests, diff checks, and full build before commit.

### Task 21: PivotTable Subtotal Caption Merges

**Files:**
- Modify: `FreeX/src/FreeX.Core.Commands/PivotTableRefreshService.MergedLabels.cs`
- Modify: `FreeX/tests/FreeX.Core.Model.Tests/PivotTableRefreshServiceTests.cs`
- Modify: architecture/parity docs

- [x] **Step 1: Add subtotal merge regression**

Add a PivotTable refresh test proving subtotal captions merge horizontally across row-label columns when
`MergeAndCenterLabels` is enabled.

- [x] **Step 2: Merge subtotal caption label spans**

Reuse the existing PivotTable-owned merge path for subtotal captions that have no more-specific row label to the right,
centering the retained label and preserving style composition.

- [x] **Step 3: Verify and document**

Run focused PivotTable refresh tests, diff checks, and full build before commit.

## Merge Discipline

After each task:

```powershell
git fetch origin
git merge origin/main --no-edit
dotnet build FreeX\FreeX.slnx --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v minimal
git push origin HEAD:main
git fetch origin
git merge origin/main --no-edit
```

If `main` moves during push, merge `origin/main`, rerun the focused tests for the task, and push again.
