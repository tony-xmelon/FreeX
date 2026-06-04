# FreeX XLSX Fidelity Contract

**Status:** v1 working contract  
**Last updated:** 2026-06-02

FreeX saves supported `.xlsx` workbook content from the in-memory model. For workbooks opened from native `.xlsx`, it also keeps a source package snapshot and merges package entries the model writer did not produce, along with content type declarations and relationships to copied targets. This is package-preserving best effort, not byte-for-byte editing of every OOXML node.

## XLSX Feature Coverage Summary

| Feature Category | Status | Notes |
|---|---|---|
| Cell values (blank/number/text/bool/date/error) | Implemented | |
| Formulas and cached values | Implemented | |
| Row heights / column widths | Implemented | |
| Hidden rows/columns/sheets | Implemented | |
| Freeze panes | Implemented | |
| Worksheet tab colors | Implemented | |
| Custom sheet views | Partial | Supported worksheet `customSheetView` entries linked to workbook custom-view GUIDs load into `Workbook.CustomViews` and save back with modeled sheet-view state; native-only view metadata and unsupported custom views are retained or merged best-effort |
| Worksheet scenarios | Partial | Supported worksheet What-If Analysis `scenarios/scenario` entries with same-sheet A1 `inputCells/@r` refs and literal `@val` values load into `Workbook.Scenarios` and save back grouped per sheet; unsupported entries and native metadata are retained or merged best-effort |
| Worksheet extension lists | Partial | Unknown worksheet `extLst` entries are merged back after ordinary model edits, including alongside rewritten modeled sparkline extensions |
| Workbook extension lists | Partial | Unknown workbook `extLst` entries are merged back after ordinary model edits; payloads are retained but not interpreted |
| Workbook file version | Partial | Native `fileVersion` metadata is retained after ordinary model edits |
| Workbook file sharing | Partial | Native `fileSharing` reservation/read-only metadata is retained after ordinary model edits |
| Workbook file recovery | Partial | Native `fileRecoveryPr` autorecovery metadata is retained after ordinary model edits |
| Document properties | Partial | Stable native `docProps/core.xml` and `docProps/app.xml` fields are retained after ordinary model edits; volatile timestamps and revision counters remain writer-owned |
| Workbook smart tags | Partial | Native workbook `smartTagPr` and `smartTagTypes` metadata is retained after ordinary model edits; smart-tag editing UI is deferred |
| Workbook function groups | Partial | Native `functionGroups` metadata is retained after ordinary model edits; custom function group editing UI is deferred |
| Workbook views | Partial | Additional native `workbookView` entries load into `Workbook.AdditionalViews`, persist through Native JSON, and save back alongside the modeled primary workbook view; native-only metadata on the primary workbook view is retained after ordinary model edits; workbook-window view editing is deferred |
| Custom workbook views | Partial | Supported `customWorkbookView` name/GUID entries load into `Workbook.CustomViews` when matching worksheet view state exists and save back from the model; unsupported native custom-view metadata remains retained or merged best-effort |
| Workbook properties | Partial | Unsupported native `workbookPr` attributes and child elements are retained without overwriting modeled workbook properties |
| Worksheet sheet properties | Partial | Unsupported native `sheetPr` attributes and child elements are retained without overwriting modeled sheet properties |
| Worksheet sheet format properties | Partial | Native-only `sheetFormatPr` attributes and child payloads such as `zeroHeight`, `thickTop`, and outline-level metadata are retained without overwriting modeled row/column sizing |
| Worksheet dimension metadata | Partial | Native-only `dimension` attributes are retained after ordinary model edits while the generated `ref` remains model-authoritative |
| Worksheet column metadata | Partial | Native-only `cols` container attributes and column attributes are retained by column span after ordinary model edits when the column span remains in the saved worksheet |
| Worksheet row metadata | Partial | Native-only `sheetData` container attributes plus row attributes and non-cell child payloads are retained by row number after ordinary model edits when the row remains in the saved sheet data |
| Worksheet cell metadata | Partial | Native-only cell attributes and non-value/formula child payloads are retained by cell reference after ordinary model edits when the cell remains in the saved sheet data |
| Worksheet formula metadata | Partial | Native formula element attributes such as array/shared-calculation metadata are retained when the formula text is unchanged |
| Merged-cell metadata | Partial | Native-only `mergeCells` container attributes and matching `mergeCell` entry attributes are retained while merge refs remain model-authoritative |
| Worksheet ignored errors | Partial | Supported active `ignoredError` cell refs/ranges load into `Cell.IgnoreFormulaError` and save back as modeled worksheet `ignoredErrors`; detailed native flags/unsupported refs remain retained or merged best-effort after ordinary model edits |
| Worksheet cell watches | Partial | Supported worksheet `cellWatches/cellWatch[@r]` single-cell A1 refs load into `Workbook.WatchedCells` and save back as modeled worksheet `cellWatches`; malformed refs are skipped, watched cells do not create blank cells, and native-only watch attributes/unsupported entries are retained or merged best-effort after ordinary model edits |
| Worksheet calculation properties | Partial | Supported worksheet `sheetCalcPr/@fullCalcOnLoad` loads into `Sheet.FullCalculationOnLoad` and saves back as modeled worksheet calculation metadata; native-only attributes/children remain retained or merged best-effort; per-sheet calculation UI is deferred |
| Worksheet phonetic properties | Partial | Supported worksheet `phoneticPr` fontId/type/alignment attributes load into `Sheet.PhoneticProperties` and save back as modeled worksheet phonetic metadata; native-only attributes/children remain retained or merged best-effort; phonetic display editing/rendering is deferred |
| Worksheet sort state | Partial | Native `sortState` blocks load into `Sheet.SortState`, persist through Native JSON, and save back after ordinary model edits; sort execution/editing UI is deferred |
| Worksheet data consolidation | Partial | Native `dataConsolidate` blocks load into `Sheet.DataConsolidation`, persist through Native JSON, and save back after ordinary model edits; Data Consolidate execution/editing UI is deferred |
| Advanced worksheet protection metadata | Partial | Unsupported native `sheetProtection` attributes and child elements are retained without overwriting modeled protection state |
| Advanced workbook protection metadata | Partial | Unsupported native `workbookProtection` attributes and child elements are retained without overwriting modeled workbook protection state |
| Protected range metadata | Partial | Supported single-area worksheet `protectedRange/@sqref` entries load into `Sheet.AllowEditRanges` and are model-authoritative on save; native attributes and child elements are retained by matching modeled `sqref`, while malformed, missing, or multi-area native-only entries are retained best-effort; advanced allow-edit-range UI is deferred |
| Custom XML parts | Partial | Native `customXml/*` package parts are retained after ordinary model edits; custom XML mapping/editing UI is deferred |
| Header/footer legacy drawings | Partial | Native worksheet `legacyDrawingHF` references and linked VML/media package parts are retained after ordinary model edits; header/footer image editing UI is deferred |
| Worksheet custom properties | Partial | Supported worksheet `customProperties/customPr` name/id entries load into `Sheet.CustomProperties` and save back as modeled worksheet custom properties; native-only attributes/children and malformed entries are retained or merged best-effort; worksheet custom-property editing UI is deferred |
| Worksheet smart tags | Partial | Native worksheet `smartTags` blocks are retained after ordinary model edits; smart-tag editing UI is deferred |
| Sheet-level AutoFilter metadata | Partial | Native worksheet `autoFilter` blocks are retained after ordinary model edits; filter execution/editing UI is deferred |
| Additional worksheet views | Partial | Additional non-primary worksheet `sheetView` entries load into `Sheet.AdditionalViews`, persist through Native JSON, and save back after ordinary model edits; native-only metadata on the primary worksheet view is retained after ordinary model edits; multi-view editing UI is deferred |
| Worksheet page-break metadata | Partial | Supported row/column break IDs are model-authoritative: native attributes are retained only for modeled matching break `id`s, removed modeled breaks are not resurrected, and malformed/native-only break entries are retained best-effort; advanced page-break editing UI is deferred |
| Worksheet print options metadata | Partial | Native-only `printOptions` attributes are retained after ordinary model edits; modeled print gridline/headings/centering attributes are never restored from the source package over `Sheet` state |
| Worksheet page setup metadata | Partial | Native-only `pageSetup` attributes and child payloads are retained after ordinary model edits; modeled orientation, scaling, paper, first-page-number, print-quality, comments/errors, black-and-white, and draft attributes are never restored from the source package over `Sheet` state, while printer-setting relationships remain handled by the dedicated relationship-retention path |
| Worksheet header/footer metadata | Partial | Native-only `headerFooter` attributes are retained after ordinary model edits while modeled header/footer text and page flags remain model-authoritative |
| Basic cell styles (font/fill/border/alignment/number format) | Implemented | |
| Stylesheet native metadata | Partial | Native stylesheet `colors`, custom `tableStyles`, native `tableStyles` child payloads, and unknown stylesheet `extLst` entries are retained after ordinary model edits; deep style-table editing semantics remain modeled through FreeX styles |
| Named ranges | Implemented | Simple range names are modeled; unsupported/native `definedName` elements are retained after ordinary model edits |
| Merged regions | Implemented | |
| Conditional formatting (cell-value/formula/top-bottom/color-scale/data-bar) | Implemented | |
| Data validation rules | Implemented | |
| Comments/notes | Implemented | |
| Hyperlinks | Implemented | |
| Page layout settings (margins/orientation/paper/print-area/headers/footers) | Implemented | |
| Workbook structure protection + sheet protection + allow-edit ranges | Implemented | |
| Charts (column/bar/line/area/scatter/bubble/pie/doughnut/radar/stock) | Implemented | |
| Sparklines | Implemented | |
| Text boxes + basic drawing shapes | Implemented | |
| Pictures/images | Implemented | |
| PivotTable + pivot-cache metadata (load/save; native parts retained) | Partial | Creation from same-sheet and cross-sheet source ranges, refresh, undoable command-level field layout/source/view/options changes, package retention, authored pivot package parts, values-only and column-only layouts, multiple row/column/value fields, Compact/Outline/Tabular report-layout state with Compact row-label rendering, nested column-field matrices, common and statistical summaries, single/multi-select page/row/column checked-item filters, date/number grouping, row/column label filters including comparison/between variants, row/column value filters with field targets including between/not-between and above/below-average variants, Excel-style Show Values As modes including percent totals, running total, difference/% difference, rank, index, and parent-total variants with base field/item settings, value/label sorting including column label/value sorting, separate row/column grand-total visibility, repeated-label suppression, blank-line spacing, PivotTable style names, custom PivotStyle definitions, and style flags with rendered header/subtotal/grand-total/banded formatting, top/bottom subtotals, calculated fields/items, GETPIVOTDATA, ribbon/double-click Show Details drill-down sheets for item/subtotal/grand-total/matrix/column-only data cells, PivotChart sync, Field List drag/drop, Insert Slicer/Insert Timeline authoring, slicer/timeline pane controls, cache relationships, refresh flags, shared-item edge metadata, external/OLAP cache source metadata, native pivot cache records relationship retention, and retained slicer/timeline floating drawing anchors are implemented; exact full-gallery PivotStyle UI/rendering semantics and external/OLAP/data-model refresh or execution remain partial or excluded |
| PivotCharts | Partial | Existing/native and authored PivotCharts bind to modeled PivotTables, native same-sheet and cross-sheet PivotChart package graphs resolve back to their PivotTable cache ids, refresh their materialized output range, render through the chart surface, read/write chart `pivotSource`, round-trip PivotChart `pivotFmts`, chart external-data relationship pointers plus relationship type/target/target-mode metadata, plot-area and legend manual layout metadata, 3D view metadata, date-system/language, color-map overrides, print settings, style ids, chart protection flags, rounded-corner, auto-title-deleted, hidden-row-data visibility, blank-display, and data-label-over-maximum chart-space metadata from package design metadata, support undoable bound chart-type changes, and expose field-button menus through the PivotTable filter/sort UI; full Excel PivotChart Tools layout/design editing remains partial |
| Structured tables (load/save; native parts retained) | Partial | Metadata, style flags, totals-row labels/functions, simple value AutoFilter metadata, authored table parts, and native references are retained; command-level and XLSX-loaded table value filters apply row visibility for multi-column checked-item filters while excluding totals rows; totals-row labels and common functions can be materialized with undo; basic data-body column structured references such as `Sales[Amount]` evaluate through formula functions and register recalculation dependencies; whole-table section selectors `#Headers`, `#Data`, `#All`, and `#Totals` plus section-column intersections such as `Sales[[#Totals],[Amount]]` evaluate through formula functions; scalar current-row references such as `[@Amount]` and `Sales[@Amount]` evaluate and register same-row dependencies for formulas hosted inside table data rows; multi-column structured-reference ranges such as `Sales[[Amount]:[Tax]]` and `Sales[[#Data],[Amount]:[Tax]]` evaluate through formula functions; qualified and unqualified `#This Row` selectors resolve relative to the formula cell for formulas hosted inside table data rows; full table style galleries remain partial |
| Workbook theme (load/save; cell-style color resolution; chart/shape rendering) | Partial | Loaded `fmtScheme` XML is preserved and the first supported effect style is interpreted for bounded non-chart drawing-object theme shadows, glow, and soft edges; deeper OOXML effects remain deferred |
| Conditional formatting (icon sets) | Partial | Model scaffold; rendering partial |
| Advanced chart families (surface/treemap/waterfall/etc.) | Partial | Combo/radar/stock, 2D/3D surface, histogram/Pareto, waterfall, treemap, sunburst, box-whisker, and funnel charts have package and rendering paths; the final 2026-06-01 chart harness passed 28/28 openability/export and visual gates, with the chartEx subset passing 7/7; map charts are recognized as deferred models when their package parts are parseable, while unparseable or unsupported chart parts still use the unsupported-feature warning path; deeper authoring/editing polish and richer formatting remain partial |
| Advanced chart formatting (rich per-series dialogs) | Partial | Baseline implemented; full format pane deferred |
| Slicer metadata | Partial | Load/save, native caption/style metadata, authored selection state, cache relationships, pane tiles, and connected PivotTable filtering implemented; exact native Excel floating drawing object styling remains partial |
| Timeline metadata | Partial | Load/save, native caption/style metadata, authored range state, cache relationships, pane controls, and connected PivotTable filtering implemented; exact native Excel floating drawing object styling remains partial |
| External workbook link metadata | Partial | Load/save; formula resolution deferred |
| VBA macros | Excluded | Retained as package part; not executed |
| Power Query | Excluded | Retained as package part; not executed |
| Data Model / Power Pivot | Excluded | Retained as package part; not executed |
| Linked data types | Excluded | Retained as package parts, including rich value data/structure metadata |
| Threaded comments | Excluded | Retained as package part |
| Track changes / revision history | Excluded | Retained as package part |
| Form controls / ActiveX | Excluded | Retained as package part |
| Digital signatures | Excluded | Retained as package part |
| Custom ribbon UI | Excluded | Retained as package part |
| Office add-ins / web extensions | Excluded | Retained as package part |
| Embedded / OLE objects | Excluded | Retained as package part |
| Live web queries / web publishing | Excluded | Retained as package part; not executed |
| Sensitivity labels / IRM | Excluded | Retained as package part |
| SmartArt diagrams | Excluded | Retained as package part |
| Printer settings | Partial | Native `xl/printerSettings/*.bin` parts and worksheet `pageSetup` relationships are retained; binary DEVMODE payload is not interpreted |
| Unsupported sheet types (chart/dialog/macro sheets) | Excluded | Retained as package part |

**Coverage: 19 Implemented + 52 Partial = 71 documented in-scope feature categories with at least partial support.**
**15 Excluded feature categories are retained as opaque package parts where safe (package-preserving save).**

| Status | Count |
|---|---:|
| Implemented | 19 |
| Partial | 52 |
| Excluded (retained) | 15 |
| Excluded (not retained) | 0 |

## Preserved On XLSX Round-Trip

- Workbook sheets and XLSX-compatible sheet names (unique, <=31 chars, no `: \ / ? * [ ]`)
- Cell values: blank, number, text, boolean, date/time, and error values
- Formulas and cached formula values where available, including quoted cross-sheet references FreeX can parse
- Row heights and column widths
- Hidden sheets, hidden rows/columns, freeze panes, worksheet tab colors, native custom sheet views, and supported worksheet scenarios
- Basic styles: font weight, font color, fill color, borders, alignment, wrap text, and number format IDs we model
- Native stylesheet `colors`, custom `tableStyles`, native `tableStyles` child payloads, and unknown stylesheet `extLst` entries from source `.xlsx` packages
- Named ranges that can be mapped to FreeX ranges
- Unsupported/native workbook `definedName` entries that are not mapped to FreeX range names
- Stable native core and extended document properties, excluding volatile timestamps/revision counters
- Cell-value conditional formatting rules we model
- Data validation rules we model
- Merged regions
- Modeled page layout settings: print area, margins, orientation, paper size, print gridlines/headings, and scale-to-fit
- Worksheet background images
- Modeled worksheet objects: comments (including legacy VML comment rich-text run metadata), hyperlinks, basic charts, sparklines, text boxes, and basic drawing shapes
- Rich inline cell format runs (bold/italic/color/font-size segments within shared-string cells) are retained on XLSX round-trip
- PivotTable and pivot-cache metadata plus native PivotTable package references for workbooks opened from `.xlsx`
- PivotChart bindings for supported chart families via chart `pivotSource` metadata
- VeryHidden worksheet state, worksheet code names, and calculation-chain package parts when opened from native `.xlsx`
- Workbook calculation properties such as full-calc-on-load, force-full-calc, iterative calculation settings, and native-only calculation metadata
- Native printer settings package parts and worksheet `pageSetup` relationship pointers
- Supported workbook and worksheet custom views through `Workbook.CustomViews`, plus native-only custom-view metadata where safe
- Supported worksheet `scenarios` definitions through `Workbook.Scenarios`, plus native-only scenario metadata where safe
- Unknown worksheet `extLst` extension entries alongside modeled sparkline extensions
- Unknown workbook `extLst` extension entries
- Native workbook file-version metadata
- Native workbook file-sharing metadata
- Native workbook file-recovery metadata
- Native workbook smart-tag metadata
- Native workbook function-group metadata
- Additional native workbook view entries
- Native custom workbook views
- Unsupported native workbook `workbookPr` attributes and child elements
- Unsupported native worksheet `sheetPr` attributes and child elements
- Native worksheet ignored-error metadata
- Native worksheet cell-watch metadata
- Native worksheet dimension, formula, merged-cell, and header/footer element metadata that does not conflict with modeled state
- Native worksheet calculation metadata outside modeled `fullCalcOnLoad`
- Native worksheet phonetic-property metadata outside modeled fontId/type/alignment attributes
- Model-backed worksheet sort-state metadata
- Model-backed worksheet data-consolidation metadata
- Advanced native worksheet protection metadata
- Advanced native workbook protection metadata
- Native protected-range metadata
- Native custom XML package parts
- Native header/footer legacy drawing references and linked VML/media parts
- Native worksheet custom-property metadata
- Native worksheet smart-tag metadata
- Native sheet-level AutoFilter metadata
- Additional native worksheet view entries

## Best-Effort Or Partial

- Conditional formatting beyond modeled rules may be skipped.
- Supported custom views are model-backed through `Workbook.CustomViews` when Excel workbook custom-view GUIDs match worksheet custom-sheet-view entries. FreeX persists view mode, pane state, gridline/headings/ruler/formula flags, and zoom; print settings, hidden row/column snapshots, filters, selections, window geometry, and personal/shared-view metadata remain partial or native-retained.
- Supported What-If Analysis worksheet scenarios are model-backed for load/save only when every changing cell is a same-sheet A1 `inputCells/@r` reference with a literal scalar `@val`. Load does not execute or apply scenarios. A workbook scenario with changes on multiple sheets is saved as one worksheet scenario entry per sheet with the shared scenario name. Supported scenario names are model-authoritative on save, so removing a loaded scenario from `Workbook.Scenarios` removes its supported source entries; unsupported or malformed native scenario entries remain best-effort retained.
- Unknown worksheet extension-list entries are retained by extension URI; FreeX does not interpret those extension payloads.
- Unknown workbook extension-list entries are retained by extension URI; FreeX does not interpret those extension payloads.
- Native workbook file-version metadata is retained but not interpreted.
- Native workbook file-sharing metadata is retained but not interpreted.
- Native workbook file-recovery metadata is retained but not interpreted.
- Native workbook smart-tag metadata is retained, but FreeX does not expose smart-tag editing.
- Native workbook function-group metadata is retained, but FreeX does not expose custom function group editing.
- Additional workbook views are model-backed through `Workbook.AdditionalViews` and persist through Native JSON, but FreeX does not yet expose workbook-window view editing.
- Native custom workbook views are retained, but FreeX does not expose custom-view editing.
- Unsupported workbook `workbookPr` details are retained, but FreeX does not expose every native workbook-property switch.
- Unsupported worksheet `sheetPr` details are retained, but FreeX does not expose every native sheet-property switch.
- Supported ignored-error refs are model-backed through `Cell.IgnoreFormulaError`; detailed native flags and unsupported refs remain best-effort retained.
- Supported cell-watch refs are model-backed through `Workbook.WatchedCells` and the Watch Window UI; native-only watch attributes and unsupported entries remain best-effort retained.
- Worksheet `sheetCalcPr/@fullCalcOnLoad` is model-backed through `Sheet.FullCalculationOnLoad`; native-only calculation attributes remain best-effort retained, and FreeX does not expose per-sheet calculation settings.
- Worksheet `phoneticPr` fontId/type/alignment attributes are model-backed through `Sheet.PhoneticProperties`; native-only phonetic metadata remains best-effort retained, but FreeX does not expose phonetic display editing or rendering.
- Native worksheet sort-state metadata is model-backed through `Sheet.SortState`, but FreeX does not expose the full sort-state editing surface.
- Native worksheet data-consolidation metadata is model-backed through `Sheet.DataConsolidation`, but FreeX does not expose Data Consolidate execution or editing.
- Unsupported native `sheetProtection` details are retained, but FreeX does not expose every native protection option or strong-hash setting.
- Unsupported native `workbookProtection` details are retained, but FreeX does not expose every native workbook protection option or strong-hash setting.
- Supported protected ranges are model-backed through `Sheet.AllowEditRanges`; native-only advanced allow-edit-range security options remain partial.
- Native custom XML package parts are retained, but FreeX does not expose XML mapping or custom XML editing.
- Native header/footer legacy drawing references and linked VML/media parts are retained, but FreeX does not expose header/footer image editing.
- Native worksheet custom-property metadata is retained, but FreeX does not expose worksheet custom-property editing.
- Native worksheet smart-tag metadata is retained, but FreeX does not expose smart-tag editing.
- Native sheet-level AutoFilter metadata is retained, but FreeX does not expose the full worksheet filter execution/editing surface.
- Additional worksheet views are model-backed through `Sheet.AdditionalViews`, but FreeX does not expose multi-view editing.
- Worksheet `printOptions` and `pageSetup` source-package merges are model-authoritative for fields represented on `Sheet`; native-only attributes are copied only when they do not conflict with modeled state.
- Data validation formulas are preserved only for supported rule shapes.
- PivotTable metadata load/save, native package retention, authored pivot package parts, same-sheet/cross-sheet creation, refresh, undoable command-level field layout/source editing, values-only and column-only layouts, multiple row fields, multiple column fields with nested matrix headers, Compact/Outline/Tabular report-layout state with Compact row-label rendering, multiple data fields, common/statistical summary functions, built-in and custom workbook-catalog value-field number formats with Value Field Settings custom-code authoring, single/multi-select page/row/column checked-item filtering, date/number grouping, row/column label filters including comparison/between variants, row/column value filters with field-target round-trip including between/not-between and above/below-average variants, Excel-style Show Values As modes including percent totals, running total, difference/% difference, rank, index, and parent-total variants with base field/item settings, value/label sorting including column label/value sorting, separate row/column grand-total visibility, repeated-label suppression, blank-line spacing, undoable PivotTable Options editing for modeled "For empty cells show" text on missing matrix intersections, style-name/style-option/custom PivotStyle definition round-trip with rendered header/subtotal/grand-total/banded formatting, top/bottom subtotals, calculated fields/items, ribbon/double-click Show Details drill-down detail-sheet creation for item/subtotal/grand-total/matrix/column-only data cells, PivotChart output-range sync, Field List drag/drop, PivotChart field-button menus, slicer/timeline filtering UI, authored slicer/timeline state/cache relationships, and pivot-cache refresh/shared-item/external-OLAP source metadata are implemented. Exact full-gallery PivotStyle UI/rendering semantics and external/OLAP/data-model refresh or execution remain partial.
- PivotCharts are modeled as bound charts and round-trip native `pivotSource`, `pivotFmts`, chart external-data relationship pointers and package relationship type/target/target-mode metadata, plot-area and legend manual layout metadata, date-system/language, color-map overrides, print-settings, style id, chart protection flags, rounded-corner, auto-title-deleted, hidden-row-data visibility, blank-display, and data-label-over-maximum metadata. Field buttons are rendered with master and per-button report-filter/axis-field/value-field visibility, the PivotChart Options command/dialog exposes the same visibility flags with undo, route to PivotTable sort/filter/value-settings menus, and bound chart type changes preserve the PivotTable connection; Excel's full PivotChart layout/editing surface remains partial.
- FreeX has a native workbook theme model scaffold, maps `.xlsx` theme parts to/from it, preserves loaded `fmtScheme` OOXML details on save, interprets the first supported `outerShdw`/`prstShdw`/`glow`/`softEdge` effect style into bounded non-chart drawing-object theme effect defaults, resolves loaded cell-style theme colors/tints against it, renders persisted drawing-object plus chart theme color references, renders Subtle/Refined drawing-object shadow effects, and has undoable Page Layout Themes/Colors/Fonts/Effects preset menus plus a custom theme dialog for name, heading/body fonts, effects, and core color slots. `Core.IO` can parse DrawingML `schemeClr`/`srgbClr` colors and load/save simple embedded package parts for every current native chart type through worksheet/drawing relationships with `twoCellAnchor` bounds/EMU offsets, `oneCellAnchor` bounds, `absoluteAnchor` bounds, no-header and no-category-column series range semantics, chart title/range with title text color/font size, axis titles with text color/font size, value-axis bounds/units/log-scale/number formats, axis gridline visibility/color/thickness, tick marks, axis label visibility, axis line color/thickness, legend visibility/position/text/fill/border/theme-text/font-size, global data-label visibility/position/content/number-format/fill/border/text/font/rotation/callout baseline, per-point data-label fill/border/text/font formatting, trendline type/equation/R-squared/line formatting, common column/area combo line-overlay and column/area/line/scatter secondary-value-axis package state, chart/plot area fill and plot border, bar direction/grouping, scatter/bubble X/Y ranges and value-axis pairs, bubble-size ranges, pie/doughnut first-slice angle and exploded-slice package state, doughnut hole size, line/scatter series color-width-dash-marker and marker-fill package formatting, and filled-series fill/outline color-width-dash package formatting, but richer XLSX chart-package formatting and deeper OOXML effect interpretation remain deferred, so chart theme/indexed colors from unsupported `.xlsx` chart parts may still be incomplete until those adapters consume the theme model end to end.
- Formula compatibility depends on the current parser/function library. Unsupported Excel syntax may load as text/formula text but fail FreeX calculation.

## Retained As Unsupported Package Parts

These feature assets are retained best-effort when the workbook was opened from `.xlsx`, even though FreeX does not execute or deeply edit them:

- VBA macros and VBA projects
- Unmodeled slicer/timeline OOXML package details beyond FreeX's modeled metadata, authored selection state, connected filtering, and retained floating drawing anchors
- Map/unparseable chart parts and unsupported or richer chart formatting
- Deeper OOXML effect semantics beyond the current first-supported `outerShdw`/`prstShdw`/`glow`/`softEdge` non-chart theme-effect slice, plus full XLSX chart-theme extraction beyond the native/XLSX workbook theme model, loaded-cell-style color-resolution, drawing-object theme-rendering/effect baseline, simple embedded native-chart package loading, chart theme-color rendering, preset menus, and custom theme dialog baseline
- External workbook links and linked data model artifacts
- Microsoft linked data type rich-data parts, including rich value data/structure metadata
- Embedded/OLE objects
- Custom OOXML package parts not represented in `Core.Model`
- Unsupported workbook, worksheet, view, protection, and metadata settings

Microsoft 365 Share/co-authoring state, cloud permissions, presence, version history, and other cloud/service state are outside local XLSX package fidelity.

## Explicit Product Exclusions

The following Excel features are not FreeX parity targets unless a future design document explicitly brings them into scope:

- Microsoft 365 Share/co-authoring, OneDrive/SharePoint permissions, Teams-linked sharing, and live collaborator presence.
- VBA compatibility, macro execution, COM add-ins, and Office Scripts.
- Power Query, Power Pivot, OLAP/data model features, and Microsoft linked data types.
- Enterprise Microsoft 365 controls such as sensitivity labels and IRM.

See [COMMAND_SURFACE_PARITY.md](COMMAND_SURFACE_PARITY.md) for the command-level parity matrix.
See [XLSX_TEST_CORPUS_PLAN.md](XLSX_TEST_CORPUS_PLAN.md) for the Sprint 2 corpus collection and reporting plan.
See [XLSX_CORPUS_REPORT.md](XLSX_CORPUS_REPORT.md) for the current executable corpus status.

## Required Before Claiming Higher Fidelity

- Add more committed issue-specific regression workbooks and local-private user torture samples.
- Complete manual desktop Excel open/save/reopen review for representative native samples.
- Extend unsupported-feature detection and user warnings as new unsupported OOXML classes are discovered.
- Keep this contract aligned with executable tests in `tests/FreeX.Core.IO.Tests`.
